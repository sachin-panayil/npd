from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from django.contrib.postgres.search import SearchVector
from rest_framework import viewsets, generics
from rest_framework.response import Response
from rest_framework.pagination import PageNumberPagination
from django.core.cache import cache
from .models import Provider, ClinicalOrganization
from .serializers import PractitionerSerializer, ClinicalOrganizationSerializer, BundleSerializer
from .mappings import genderMapping
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi

default_page_size = 10
max_page_size = 1000
page_size_param = openapi.Parameter(
    'page_size',
    openapi.IN_QUERY,
    description="Limit the number of results returned per page",
    type=openapi.TYPE_STRING,
    minimum=1,
    maximum=max_page_size,
    default=default_page_size
)


def createFilterParam(field: str, display: str = None, enum: list = None):
    if display is None:
        display = field.replace('_', ' ')
    param = openapi.Parameter(
        field,
        openapi.IN_QUERY,
        description=f"Filter by {display}",
        type=openapi.TYPE_STRING,
    )
    if enum is not None:
        param.enum = enum
    return param


def index(request):
    return HttpResponse("Connection to npd database: successful")


def health(request):
    return HttpResponse("healthy")


class FHIRPractitionerViewSet(viewsets.ViewSet):
    """
    ViewSet for FHIR Practitioner resources
    """
    # permission_classes = [permissions.IsAuthenticated]
    @swagger_auto_schema(
        manual_parameters=[
            page_size_param,
            createFilterParam('name'),
            createFilterParam('gender', enum=['Female', 'Male', 'Other']),
            createFilterParam('practitioner_type'),
            createFilterParam(
                'address-state', '2 letter US State abbreviation')
        ],
        responses={200: "Successful response",
                   404: "Error: The requested Practitioner resource cannot be found."}
    )
    def list(self, request):
        """
        Return a list of all providers as FHIR Practitioner resources
        """
        page_size = default_page_size

        all_params = request.query_params

        providers = Provider.objects.all().prefetch_related(
            'npi', 'individual', 'individual__individualtoname_set', 'individual__individualtoaddress_set', 'individual__individualtoaddress_set__address__address_us', 'individual__individualtoaddress_set__address__address_us__state_code', 'individual__individualtoaddress_set__address_use', 'individual__individualtophone_set', 'individual__individualtoemail_set', 'providertootherid_set', 'providertotaxonomy_set')

        for param, value in all_params.items():
            if param == 'page_size':
                try:
                    value = int(value)
                    if value <= max_page_size:
                        page_size = value
                except:
                    page_size = page_size
            if param == 'name':
                providers = providers.annotate(
                    search=SearchVector('individual__individualtoname__last_name',
                                        'individual__individualtoname__first_name', 'individual__individualtoname__middle_name')
                ).filter(search=value)
            if param == 'gender':
                gender = genderMapping.toNPD(value)
                providers = providers.filter(individual__gender=gender)
            if param == 'practitioner_type':
                providers = providers.annotate(
                    search=SearchVector(
                        'providertotaxonomy__nucc_code__display_name')
                ).filter(search=value)
            if param == 'address-state':
                providers = providers.annotate(
                    search=SearchVector(
                        'individual__individualtoaddress__address__address_us__state_code__abbreviation')
                ).filter(search=value)

        paginator = PageNumberPagination()
        paginator.page_size = page_size
        queryset = paginator.paginate_queryset(providers, request)

        # Serialize the bundle
        serializer = PractitionerSerializer(queryset, many=True)
        bundle = BundleSerializer(serializer)

        # Set appropriate content type for FHIR responses
        response = paginator.get_paginated_response(bundle.data)
        response["Content-Type"] = "application/fhir+json"

        return response

    def retrieve(self, request, pk=None):
        """
        Return a single provider as a FHIR Practitioner resource
        """
        provider = get_object_or_404(Provider, pk=int(pk))

        practitioner = PractitionerSerializer(provider)

        # Set appropriate content type for FHIR responses
        response = Response(practitioner.data)
        response["Content-Type"] = "application/fhir+json"

        return response


class FHIROrganizationViewSet(viewsets.ViewSet):
    """
    ViewSet for FHIR Practitioner resources
    """
    # permission_classes = [permissions.IsAuthenticated]
    @swagger_auto_schema(
        manual_parameters=[
            page_size_param,
            createFilterParam('name'),
            createFilterParam('organization_type')
        ],
        responses={200: "Successful response",
                   404: "Error: The requested Organization resource cannot be found."}
    )
    def list(self, request):
        """
        Return a list of all providers as FHIR Practitioner resources
        """
        page_size = default_page_size

        all_params = request.query_params

        organizations = ClinicalOrganization.objects.all().prefetch_related(
            'npi', 'organization', 'organization__organizationtoname_set', 'organization__organizationtoaddress_set', 'organization__organizationtoaddress_set__address', 'organization__organizationtoaddress_set__address__address_us', 'organization__organizationtoaddress_set__address__address_us__state_code', 'organization__organizationtoaddress_set__address_use', 'organizationtootherid_set', 'organizationtotaxonomy_set', 'organization__authorized_official__individualtophone_set', 'organization__authorized_official__individualtoname_set', 'organization__authorized_official__individualtoemail_set', 'organization__authorized_official__individualtoaddress_set')

        for param, value in all_params.items():
            if param == 'page_size':
                try:
                    value = int(value)
                    if value <= max_page_size:
                        page_size = value
                except:
                    page_size = page_size
            if param == 'name':
                organizations = organizations.annotate(
                    search=SearchVector(
                        'organization__organizationtoname__name')
                ).filter(search=value)
            if param == 'organization_type':
                organizations = organizations.annotate(
                    search=SearchVector(
                        'organizationtotaxonomy__nucc_code__display_name')
                ).filter(search=value)
            if param == 'address-state':
                organizations = organizations.annotate(
                    search=SearchVector(
                        'organization__organizationtoaddress__address__address_us__state_code__abbreviation')
                ).filter(search=value)

        paginator = PageNumberPagination()
        paginator.page_size = page_size
        queryset = paginator.paginate_queryset(organizations, request)

        # Serialize the bundle
        serializer = ClinicalOrganizationSerializer(queryset, many=True)
        bundle = BundleSerializer(serializer)

        # Set appropriate content type for FHIR responses
        response = paginator.get_paginated_response(bundle.data)
        response["Content-Type"] = "application/fhir+json"

        return response

    def retrieve(self, request, pk=None):
        """
        Return a single provider as a FHIR Practitioner resource
        """
        clinicalorg = get_object_or_404(ClinicalOrganization, pk=int(pk))

        organization = ClinicalOrganizationSerializer(clinicalorg)

        # Set appropriate content type for FHIR responses
        response = Response(organization.data)
        response["Content-Type"] = "application/fhir+json"

        return response

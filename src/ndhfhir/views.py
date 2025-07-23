from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from django.contrib.postgres.search import SearchVector
#from djangp.db.models import FilteredRelation, Q
from rest_framework import viewsets, generics
from rest_framework.response import Response
from rest_framework.pagination import PageNumberPagination
from .models import Provider
from .adapters import create_fhir_practitioner
from .serializers import PractitionerSerializer, PractitionerFHIRSerializer, BundleSerializer, create_bundle
from .mappings import genderMapping

def index(request):
    return HttpResponse("Connection to ndh database: successful")

def health(request):
    return HttpResponse("healthy")


class FHIRPractitionerViewSet(viewsets.ViewSet):
    """
    ViewSet for FHIR Practitioner resources
    """
    #permission_classes = [permissions.IsAuthenticated]
    def list(self, request):

        """
        Return a list of all providers as FHIR Practitioner resources
        parameters:
            - name: name
              description: Practitioner name
              required: false
              type: string
              paramType: query
            - name: gender
              description: Practitioner gender; Options: (Female, Male, Other)
              required: false
              type: string
              paramType: query
        """
        page_size = 10

        all_params = request.query_params

        providers = Provider.objects.all()

        for param, value in all_params.items():
            if param == 'page_size':
                try:
                    value = int(value)
                    if value < 1000:
                        page_size = value
                except:
                    page_size = page_size
            if param == 'name':
                providers = providers.annotate(
                    search = SearchVector('individual__individualtoname__last_name','individual__individualtoname__first_name','individual__individualtoname__middle_name')
                ).filter(search = value)
            if param == 'gender':
                gender = genderMapping.toNDH(value)
                providers = providers.filter(individual__gender_code = gender)
            if param == 'practitioner_type':
                providers = providers.annotate(
                    search = SearchVector('individual__individualtonucctaxonomycode__nucc_taxonomy_code__display_name')
                ).filter(search = value)
            #if param == 'address-state':
            #    providers = providers.filter(individual__individualtoaddress__address__addressus__fipsstate__abbreviation = value) #fipsstate__abbreviation
        
        paginator = PageNumberPagination()
        paginator.page_size = page_size
        queryset = paginator.paginate_queryset(providers, request)

        # Convert each provider to a FHIR Practitioner
        fhir_practitioners = [create_fhir_practitioner(provider) for provider in queryset]
        
        # Create a Bundle containing all practitioners
        bundle = create_bundle(fhir_practitioners)
        
        # Serialize the bundle
        serializer = BundleSerializer(bundle)
        
        # Set appropriate content type for FHIR responses
        response = paginator.get_paginated_response(serializer.data)
        response["Content-Type"] = "application/fhir+json"
        
        return response
    
    def retrieve(self, request, pk=None):
        """
        Return a single provider as a FHIR Practitioner resource
        """
        provider = get_object_or_404(Provider, pk=int(pk))

        serializer = PractitionerSerializer(provider)
        
        # Convert provider to FHIR Practitioner
        #fhir_practitioner = create_fhir_practitioner(provider)
        
        # Serialize the FHIR Practitioner
        #serializer = PractitionerFHIRSerializer(fhir_practitioner)
        
        # Set appropriate content type for FHIR responses
        response = Response(serializer.data)
        response["Content-Type"] = "application/fhir+json"
        
        return response
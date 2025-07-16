from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from rest_framework import viewsets, permissions, status
from models import Individual

def index(request):
    return HttpResponse("Connection to ndh database: successful")

def health(request):
    return HttpResponse("healthy")

class FHIRPractitionerViewSet(viewsets.ViewSet):
    """
    ViewSet for FHIR Practitioner resources
    """
    #permission_classes = [permissions.IsAuthenticated]
    
    def retrieve(self, request, pk=None):
        """
        Return a single provider as a FHIR Practitioner resource
        """
        doctor = get_object_or_404(Individual, pk=pk)
        
        # Convert Doctor to FHIR Practitioner
        fhir_practitioner = create_fhir_practitioner(doctor)
        
        # Serialize the FHIR Practitioner
        serializer = PractitionerFHIRSerializer(fhir_practitioner)
        
        # Set appropriate content type for FHIR responses
        response = Response(serializer.data)
        response["Content-Type"] = "application/fhir+json"
        
        return response
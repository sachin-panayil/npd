from rest_framework import serializers
from fhir.resources.practitioner import Practitioner
from fhir.resources.bundle import Bundle
from .models import IndividualToName, Provider, Individual
from fhir.resources.practitioner import Practitioner as FHIRPractitioner
from fhir.resources.humanname import HumanName
from fhir.resources.identifier import Identifier
from fhir.resources.contactpoint import ContactPoint
from fhir.resources.codeableconcept import CodeableConcept
from fhir.resources.coding import Coding
from fhir.resources.period import Period
from fhir.resources.meta import Meta

class NameSerializer(serializers.ModelSerializer):
    family = serializers.CharField(source = "last_name")
    first_name = serializers.CharField()
    middle_name = serializers.CharField()
    effective_date = serializers.DateField()
    end_date = serializers.DateField()
    prefix = serializers.CharField()
    suffix = serializers.CharField()
    class Meta:
        model = IndividualToName
        fields = ['family', 'first_name', 'middle_name', 'effective_date', 'end_date','prefix', 'suffix']
    """def to_representation(self, name):
        human_name = HumanName(
            family=name.last_name,
            given=[name.first_name, name.middle_name],
            use=name.fhir_name_use.value,
            period=Period(
                start=name.effective_date,
                end=name.end_date
            )
        )
        if name.prefix!='':
            human_name.prefix = [name.prefix]
        if name.suffix!='':
            human_name.suffix = [name.suffix]
        return human_name.model_dump()"""

class IndividualSerializer(serializers.ModelSerializer):
    individual_to_name = NameSerializer(many=True)
    class Meta:
        model = Individual
        fields = ['individual_to_name']

class PractitionerSerializer(serializers.ModelSerializer):
    npi = serializers.CharField(read_only=True)
    individual = IndividualSerializer()

    class Meta:
        model = Provider
        fields = ['npi', 'individual']#'family','given','use', 'period', 'prefix','suffix']

class FHIRSerializer(serializers.Serializer):
    """
    Base serializer for FHIR resources
    """
    def to_representation(self, instance):
        """
        Convert FHIR resource to JSON
        """
        # Use the resource's as_json() method to convert to JSON
        if hasattr(instance, 'dict'):
            return instance.dict()
        return super().to_representation(instance)

class PractitionerFHIRSerializer(FHIRSerializer):
    """
    Serializer for FHIR Practitioner resource
    """
    class Meta:
        model = Practitioner

class BundleSerializer(FHIRSerializer):
    """
    Serializer for FHIR Bundle resource
    """
    class Meta:
        model = Bundle


def create_bundle(resources, bundle_type="searchset"):
    """
    Create a FHIR Bundle containing multiple resources
    
    Args:
        resources: List of FHIR resources to include in the bundle
        bundle_type: Type of bundle (e.g. 'searchset', 'collection')
    
    Returns:
        A FHIR Bundle resource
    """
    entries = []
    
    for resource in resources:
        # Get the resource type (Patient, Practitioner, etc.)
        resource_type = resource.get_resource_type()
        
        # Create an entry for this resource
        entry = {
            "fullUrl": f"{resource_type}/{resource.id}",
            "resource": resource,
        }
        
        entries.append(entry)
    
    # Create the bundle
    bundle = Bundle(
        type=bundle_type,
        entry=entries,
        total=len(entries)
    )
    
    return bundle
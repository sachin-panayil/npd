from rest_framework import serializers
from fhir.resources.practitioner import Practitioner
from fhir.resources.bundle import Bundle
from .models import IndividualToEmailAddress, ProviderToOtherIdentifier, IndividualToName, Provider, Individual
from fhir.resources.practitioner import Practitioner as FHIRPractitioner
from fhir.resources.humanname import HumanName
from fhir.resources.identifier import Identifier
from fhir.resources.contactpoint import ContactPoint
from fhir.resources.codeableconcept import CodeableConcept
from fhir.resources.coding import Coding
from fhir.resources.period import Period
from fhir.resources.meta import Meta
from .cache import other_identifier_type, fhir_name_use

class EmailSerializer(serializers.Serializer):
    email_address = serializers.CharField(read_only = True)

    class Meta:
        fields = ['email_address']


class OtherIdentifierSerializer(serializers.Serializer):
    value = serializers.CharField(read_only = True)
    issue_date = serializers.DateField(read_only = True)
    expiry_date = serializers.DateField(read_only = True)

    class Meta:
        fields = ['value', 'issue_date', 'expiry_date','other_identifier_type', 'other_identifier_type_id', 'other_identifier_type_value']
    def to_representation(self, id):
        other_identifier_type_id = id.other_identifier_type_id
        license_identifier = Identifier(
            #system="", TODO: Figure out how to associate a system with each identifier
            value=id.value,
            type=CodeableConcept(
                coding=[Coding(
                    system="http://terminology.hl7.org/CodeSystem/v2-0203",
                    code=str(other_identifier_type_id),
                    display=other_identifier_type[other_identifier_type_id]
                )]
            ),
            #use="" TODO: Add use for other identifier
            period=Period(
                start=id.issue_date,
                end=id.expiry_date
        )
        )
        return license_identifier.model_dump()

class NameSerializer(serializers.Serializer):
    last_name = serializers.CharField(read_only = True)
    first_name = serializers.CharField(read_only = True)
    middle_name = serializers.CharField(read_only = True)
    effective_date = serializers.DateField(read_only = True)
    end_date = serializers.DateField(read_only = True)
    prefix = serializers.CharField(read_only = True)
    suffix = serializers.CharField(read_only = True)
    class Meta:
        fields = ['last_name', 'first_name', 'middle_name', 'effective_date', 'end_date','prefix', 'suffix']
    def to_representation(self, name):
        human_name = HumanName(
            family=name.last_name,
            given=[name.first_name, name.middle_name],
            use=fhir_name_use[name.fhir_name_use_id],
            period=Period(
                start=name.effective_date,
                end=name.end_date
            )
        )
        if name.prefix!='':
            human_name.prefix = [name.prefix]
        if name.suffix!='':
            human_name.suffix = [name.suffix]
        return human_name.model_dump()

class PractitionerSerializer(serializers.ModelSerializer):
    npi = serializers.CharField(source="npi__npi", read_only=True)
    name = NameSerializer(source = 'individual__individualtoname', read_only = True, many = True)
    email = EmailSerializer(source = 'individual__individualtoemail', read_only = True, many = True)
    identifier = OtherIdentifierSerializer(source='providertootheridentifier_set', many = True, read_only = True)
   
    class Meta:
        model = Provider
        fields = ['npi', 'name', 'email', 'identifier']

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
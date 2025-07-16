from fhir.resources.practitioner import Practitioner as FHIRPractitioner
from fhir.resources.humanname import HumanName
from fhir.resources.identifier import Identifier
from fhir.resources.contactpoint import ContactPoint
from utils import FhirAddressResourceFromSmartyStreets
from fhir.resources.codeableconcept import CodeableConcept
from fhir.resources.coding import Coding
from fhir.resources.period import Period
from fhir.resources.meta import Meta

def create_fhir_practitioner(individual):
    """Convert an Individual model to a FHIR Practitioner resource"""
    
    # Create FHIR Practitioner
    fhir_practitioner = FHIRPractitioner()
    
    # Set ID
    fhir_practitioner.id = str(individual.id)
    
    # Set meta
    fhir_practitioner.meta = Meta(
        profile=["http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner"]
    )
    
    # Set identifiers
    identifiers = []
    
    # Doctor ID identifier
    doctor_identifier = Identifier(
        system="http://terminology.hl7.org/NamingSystem/npi",
        value=str(individual.npi.npi),
        type=CodeableConcept(
                coding=[Coding(
                    system="http://terminology.hl7.org/CodeSystem/v2-0203",
                    code="PRN",
                    display="Provider number"
                )]
            ),
        use='official',
        period=Period(
            start=individual.npi.enumeration_date,
            end=individual.npi.deactivation_date
    )
    )
    identifiers.append(doctor_identifier)

    for id in individual.individualtootheridentifier_set.all():
        license_identifier = Identifier(
            #system="", TODO: Figure out how to associate a system with each identifier
            value=id.value,
            type=CodeableConcept(
                coding=[Coding(
                    system="http://terminology.hl7.org/CodeSystem/v2-0203",
                    code=id.otherIdentifierType.id,
                    display=id.otherIdentifierType.value
                )]
            ),
            #use="" TODO: Add use for other identifier
            period=Period(
                start=id.issue_date,
                end=id.expiry_date
        )
        )
        identifiers.append(license_identifier)
    
    fhir_practitioner.identifier = identifiers

    names=[]
    
    for name in individual.individualtoname_set.all():
        human_name = HumanName(
            family=name.last_name,
            given=[name.first_name, name.middle_name],
            prefix=name.prefix,
            suffix=name.suffix,
            use=name.use,
            period=Period(
                start=name.effective_date,
                end=name.end_date
            )
        )
        names.append(human_name)
    fhir_practitioner.name = names
    
    # Set contact (email and phone)
    contacts = []
    for email in individual.individualtoemailaddress_set.all():
        email_contact = ContactPoint(
            system="email",
            value=email.email_address,
            #use="work" TODO: add email use
        )
        contacts.append(email_contact)
    
    for phone in individual.individualtophone_set.all():
        phone_contact = ContactPoint(
            system=phone.phone_type.value,
            value=f"{phone.phone_number.value} ext. {phone.extension}",
            #use="work" TODO: add phone use
        )
        contacts.append(phone_contact)
    
    if contacts:
        fhir_practitioner.telecom = contacts
    
    # Set address
    for address in individual.individualtoaddress_set.all():
        practitioner_address=FhirAddressResourceFromSmartyStreets(address)
        fhir_practitioner.address = [practitioner_address]
    
    # Set qualification (specialty, education)
    qualifications = []
    
    # Add specialty as qualification
    for taxonomy in individual.individualtonucctaxonomy_set.all():
        specialty_qualification = dict(
            code=CodeableConcept(
                coding=[Coding(
                    system="http://nucc.org/provider-taxonomy",
                    code=taxonomy.id,
                    display=taxonomy.display_name
                )]
            )
        )
        qualifications.append(specialty_qualification)
    
    if qualifications:
        fhir_practitioner.qualification = qualifications
    
    # Set active status
    fhir_practitioner.active = individual.npi.status=='Active'
    
    return fhir_practitioner
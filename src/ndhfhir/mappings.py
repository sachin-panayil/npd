from bidict import bidict

class Mapping():
    def __init__(self, mapping: dict):
        self.mapping=bidict(mapping)
    def toFHIR(self, ndhValue):
        return self.mapping[ndhValue]
    def toNDH(self, fhirValue):
        return self.mapping.inverse[fhirValue]
    
genderMapping = Mapping(
    {
        "F": "Female",
        "M": "Male",
        "O": "Other"
    }
)
import json
from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from pathlib import Path
import uuid

from ndhfhir.models import Provider, Individual, IndividualToName
from django.test.runner import DiscoverRunner
from django.db import connection

class SchemaTestRunner(DiscoverRunner):
    def setup_databases(self, **kwargs):
        old_config = super().setup_databases(**kwargs)
        # Apply unmanaged tables
        with connection.cursor() as cursor:
            cursor.execute(open("../db/sql/schemas/ndh.sql").read())
            cursor.execute(open("../db/sql/schemas/create_tables.sql").read())
        return old_config

class ProviderApiTests(TestCase):

    def setUp(self):
        self.client = APIClient()

        # Create Individual 1
        self.individual1 = Individual.objects.create(
            id=uuid.uuid4(),   # Required since unmanaged models won’t autogen IDs
            gender_code="M"
        )
        self.name1 = IndividualToName.objects.create(
            individual=self.individual1,
            first_name="John",
            last_name="Smith",
        )
        self.provider1 = Provider.objects.create(
            id=uuid.uuid4(),
            individual=self.individual1
        )

        # Create Individual 2
        self.individual2 = Individual.objects.create(
            id=uuid.uuid4(),
            gender_code="F"
        )
        self.name2 = IndividualToName.objects.create(
            individual=self.individual2,
            first_name="Jane",
            last_name="Doe",
        )
        self.provider2 = Provider.objects.create(
            id=uuid.uuid4(),
            individual=self.individual2
        )

    def test_provider_list(self):
        """Test that the API returns providers"""
        response = self.client.get("/api/providers/")
        self.assertEqual(response.status_code, 200)
        self.assertGreaterEqual(len(response.data), 2)

    def test_provider_detail(self):
        """Test provider detail endpoint"""
        response = self.client.get(f"/api/providers/{self.provider1.id}/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["individual"]["gender_code"], "M")
#
#class ProviderFHIRJSONTests(TestCase):
#    @classmethod
#    def setUpTestData(cls):
#        """Load test data once for all tests"""
#        test_file_path = Path(__file__).parent / 'test_data' / 'users.json'
#        with open(test_file_path, 'r') as f:
#            cls.test_data = json.load(f)
#    
#    def test_json_structure_exists(self):
#        """Verify the JSON file exists and has content"""
#        self.assertIsNotNone(self.test_data, "JSON data failed to load")
#        self.assertIsInstance(self.test_data, (dict, list), 
#                             "JSON should be an object or array")
#
#    def test_required_top_level_fields(self):
#        """Test for required top-level fields in FHIR JSON"""
#        required_fields = {
#            'resourceType': str,
#            'id': str,
#            'meta': dict,
#            'name': str,
#            'mode': str,
#            'address': dict,
#            'physicalType': str,
#            'managingOrganization': str
#        }
#        
#        if isinstance(self.test_data, dict):
#            for field, field_type in required_fields.items():
#                with self.subTest(field=field):
#                    self.assertIn(field, self.test_data, 
#                                 f"Missing required field: {field}")
#                    self.assertIsInstance(self.test_data[field], field_type,
#                                         f"Field {field} has wrong type")
#
#    def test_fhir_object_structure(self):
#        """Test structure of individual FHIR objects"""
#        if isinstance(self.test_data, dict) and 'meta' in self.test_data:
#            self.assertIn('profile',self.test_data['meta'])
#
#        if isinstance(self.test_data,dict) and 'address' in self.test_data:
#            required_fhir_fields = {
#                'line': list,
#                'city': str,
#                'state': str,
#                'postalCode': str
#            }
#
#            for field, field_type in required_fhir_fields.items():
#                with self.subTest(address_field=field):
#
#                    self.assertIn(field, self.test_data['address'], 
#                                f"Provider missing required field: {field}")
#                    self.assertIsInstance(self.test_data['address'][field], field_type,
#                                        f"Provider field {field} has wrong type")
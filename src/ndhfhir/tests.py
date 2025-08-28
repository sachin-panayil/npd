import json
from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase, APIClient
from pathlib import Path
import uuid

from ndhfhir.models import Provider, Individual, IndividualToName
from django.test.runner import DiscoverRunner
from django.db import connection
from ndhfhir.models import OtherIdentifierType, FhirNameUse, NuccTaxonomyCode
from ndhfhir.cache import cacheData

class SchemaTestRunner(DiscoverRunner):
    def setup_databases(self, **kwargs):
        old_config = super().setup_databases(**kwargs)

        # Apply unmanaged tables
        with connection.cursor() as cursor:
            cursor.execute(open("../db/sql/schemas/ndh.sql").read())
            cursor.execute(open("../db/sql/inserts/sample_data.sql").read())

        return old_config

class BasicViewsTestCase(APITestCase):
    def test_index_view(self):
        url = reverse("index")  # maps to "/"
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(
            response.content.decode(),
            "Connection to ndh database: successful"
        )

    def test_health_view(self):
        url = reverse("healthCheck")  # maps to "/healthCheck"
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.content.decode(), "healthy")


class PractitionerViewSetTestCase(APITestCase):

    def setUp(self):
        self.client = APIClient()
        #other_identifier_type = cacheData(OtherIdentifierType)
        #fhir_name_use = cacheData(FhirNameUse)
        #nucc_taxonomy_codes = cacheData(NuccTaxonomyCode)


    def test_list_default(self):
        url = reverse("fhir-practitioner-list")  # /Practitioner/
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response["Content-Type"], "application/fhir+json")
        self.assertIn("results", response.data)

    def test_list_with_custom_page_size(self):
        url = reverse("fhir-practitioner-list")
        response = self.client.get(url, {"page_size": 2})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertLessEqual(len(response.data["results"]), 2)

    def test_list_filter_by_gender(self):
        url = reverse("fhir-practitioner-list")
        response = self.client.get(url, {"gender": "Male"})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("results", response.data)

    def test_list_filter_by_name(self):
        url = reverse("fhir-practitioner-list")
        response = self.client.get(url, {"name": "Smith"})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("results", response.data)

    def test_list_filter_by_practitioner_type(self):
        url = reverse("fhir-practitioner-list")
        response = self.client.get(url, {"practitioner_type": "Nurse"})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("results", response.data)

    def test_retrieve_existing(self):
        # adjust PK according to your sample_data.sql contents
        url = reverse("fhir-practitioner-detail", args=[1])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response["Content-Type"], "application/fhir+json")

    def test_retrieve_nonexistent(self):
        url = reverse("fhir-practitioner-detail", args=[999999])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

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
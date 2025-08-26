import json
from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient

from models import Provider, Individual, IndividualToName


class APITests(TestCase):
    def setUp(self):
        self.client = APIClient()

        # Create example provider 1
        self.individual1 = Individual.objects.create(gender_code="M")
        self.name1 = IndividualToName.objects.create(
            individual=self.individual1,
            first_name="John",
            last_name="Smith",
        )
        self.provider1 = Provider.objects.create(individual=self.individual1)

        # Create example provider 2
        self.individual2 = Individual.objects.create(gender_code="F")
        self.name2 = IndividualToName.objects.create(
            individual=self.individual2,
            first_name="Jane",
            last_name="Doe",
        )
        self.provider2 = Provider.objects.create(individual=self.individual2)

    def test_index_returns_200(self):
        url = reverse("index")
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("successful", response.content.decode())

    def test_health_returns_200(self):
        url = reverse("health")
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("healthy", response.content.decode())

    def test_practitioner_list_returns_200_and_paginated_data(self):
        url = reverse("fhir-practitioner-list")
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response["Content-Type"], "application/fhir+json")

        data = response.json()
        self.assertIn("results", data)
        self.assertEqual(len(data["results"]), 2)  # we created 2 providers

    def test_practitioner_list_with_page_size(self):
        url = reverse("fhir-practitioner-list") + "?page_size=1"
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        data = response.json()
        self.assertEqual(len(data["results"]), 1)

    def test_practitioner_list_filter_by_name(self):
        url = reverse("fhir-practitioner-list") + "?name=Smith"
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        data = response.json()
        self.assertEqual(len(data["results"]), 1)
        self.assertIn("Smith", str(data["results"][0]))

    def test_practitioner_list_filter_by_gender(self):
        url = reverse("fhir-practitioner-list") + "?gender=Female"
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        data = response.json()
        self.assertEqual(len(data["results"]), 1)

    def test_practitioner_retrieve_returns_single_provider(self):
        url = reverse("fhir-practitioner-detail", args=[self.provider1.id])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response["Content-Type"], "application/fhir+json")

        data = response.json()
        self.assertEqual(data["id"], self.provider1.id)




class GenericFHIRJSONTests(TestCase):
    @classmethod
    def setUpTestData(cls):
        """Load test data once for all tests"""
        test_file_path = Path(__file__).parent / 'test_data' / 'users.json'
        with open(test_file_path, 'r') as f:
            cls.test_data = json.load(f)
    
    def test_json_structure_exists(self):
        """Verify the JSON file exists and has content"""
        self.assertIsNotNone(self.test_data, "JSON data failed to load")
        self.assertIsInstance(self.test_data, (dict, list), 
                             "JSON should be an object or array")




class ProviderFHIRJSONTests(GenericFHIRJSONTests):
    def test_required_top_level_fields(self):
        """Test for required top-level fields in FHIR JSON"""
        required_fields = {
            'resourceType': str,
            'id': str,
            'meta': dict,
            'name': str,
            'mode': str,
            'address': dict,
            'physicalType': str,
            'managingOrganization': str
        }
        
        if isinstance(self.test_data, dict):
            for field, field_type in required_fields.items():
                with self.subTest(field=field):
                    self.assertIn(field, self.test_data, 
                                 f"Missing required field: {field}")
                    self.assertIsInstance(self.test_data[field], field_type,
                                         f"Field {field} has wrong type")

    def test_fhir_object_structure(self):
        """Test structure of individual FHIR objects"""
        if isinstance(self.test_data, dict) and 'meta' in self.test_data:
            self.assertIn('profile',self.test_data['meta'])

        if isinstance(self.test_data,dict) and 'address' in self.test_data:
            required_fhir_fields = {
                'line': list,
                'city': str,
                'state': str,
                'postalCode': str
            }

            for field, field_type in required_fhir_fields.items():
                with self.subTest(address_field=field):

                    self.assertIn(field, self.test_data['address'], 
                                f"Provider missing required field: {field}")
                    self.assertIsInstance(self.test_data['address'][field], field_type,
                                        f"Provider field {field} has wrong type")
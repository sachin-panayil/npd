import json
from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from pathlib import Path

class UserJSONFieldTests(TestCase):
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

    def test_required_top_level_fields(self):
        """Test for required top-level fields in FHIR JSON"""
        required_fields = {
            'entry': list,
            'resourceType': str,
            'type': str
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
        if isinstance(self.test_data, dict) and 'entry' in self.test_data:
            for entry in self.test_data['entry']:
                with self.subTest(user_id=entry.get('fullUrl', 'unknown')):
                    required_fhir_fields = {
                        'fullUrl': str,
                        'resource': str,
                        'request': str
                    }
                    
                    for field, field_type in required_fhir_fields.items():
                        self.assertIn(field, entry, 
                                    f"User missing required field: {field}")
                        self.assertIsInstance(field[field], field_type,
                                            f"User field {field} has wrong type")

import pandas as pd
import requests
import itertools

download_url = 'https://lantern.healthit.gov/session/ee83deeb5446f6f6e7a478f69a955440/download/endpoints_page-download_data?w='

lantern_df = pd.read_csv(download_url)

org_lists = lantern_df['list_source'].unique()

endpoints = []
org_to_endpoint = []
for list in org_lists:
    resp = requests.get(list, verify=False).json()
    for entry in resp['entries']:
        resource = entry['resource']
        if resource['ResourceType'] == 'Organization':
            npis = [id['value'] for id in resource['identifier']
                    if id['system'] == 'http://hl7.org/fhir/sid/us-npi']
            endpoint_ids = [endpoint['reference']
                            for endpoint in resource['endpoint']]
            for npi in npis:
                for id in endpoint_ids:
                    org_to_endpoint.append({'npi': npi, 'endpoint_id': id})
        elif resource['ResourceType'] == 'Endpoint':
            endpoints.append(resource)

endpoints.to_csv('endpoints.csv')
org_to_endpoint.to_csv('org_to_endpoint.csv')

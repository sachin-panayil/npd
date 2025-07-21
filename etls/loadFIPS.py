import requests
import json
import csv
import os

import pandas as pd

from io import StringIO
from sqlalchemy import create_engine
from dotenv import load_dotenv

def extract(): 
    fips_states = {} # holds the config json but can prob move the nest around to remove this var
    api_data = {}

    try:
        with open("./config/fips_states.json", "r") as file:
            fips_states = json.load(file) # i was given a CSV with state names so wonder if i should use that rather than creating a new json object for it 

    except Exception as e:
        print(f"An error loading the JSON occured:", e)

    # looping through each state and grabbing the county data
    for state in fips_states:
        filename = f'st{state["code"]}_{state["abbrev"]}_cou2020.txt'
        url = f"https://www2.census.gov/geo/docs/reference/codes2020/cou/{filename}"

        try:
            response = requests.get(url) # gives us back responses as .txt files, not JSON so we gotta use csv + StringIO
            response.raise_for_status()

            if not api_data:
                api_data = response.text
            else:
                api_data += '\n'.join(response.text.split('\n')[1:])

        except requests.RequestException as e:
            print("Error fetching data:", e)
        except Exception as e:
            print("Error wuth something", e)

    transform(api_data)
            
def transform(api_data):
    transform_data = []

    parser = csv.DictReader(StringIO(api_data), delimiter="|")

    for row in parser:
        single_row = {
            "id": row["STATEFP"]+row["COUNTYFP"],
            "name": row["COUNTYNAME"],  
            "fips_state_id": row["STATEFP"]
        }

        transform_data.append(single_row)

    df = pd.DataFrame(transform_data)

    df.to_csv("output.csv")
    load(df)

def load(transformed_data: pd.DataFrame):
    load_dotenv("config/.env")

    engine = create_engine(
    f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@"
    f"{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)

    try:
        transformed_data.to_sql(
            name = "ndh.fips_county",
            con = engine,
            if_exists = "replace",
            index = False,
            method = "multi"
        )
    except Exception as e:
        print(f"Error occured: {e}")

    engine.dispose()
    print("Database created!")

def main():
    extract()

if __name__ == "__main__":
    main()
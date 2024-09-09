import json
import requests
import boto3
import json
import os
from datetime import datetime

## import pandas as pd

def get_data(api_url):
    response = requests.get(api_url)
    if response.status_code == 200:
        print('Successfully pulled')
        return response.json()
    else:
        raise Exception(f'Failed to pull data with {response.status_code}')
        

def extract_currency_data(data):
    time_last_update_utc = data['time_last_update_utc']
    time_next_update_utc = data['time_next_update_utc']
    rates = data.get('rates', {})
    current_pull_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Prepare rows for output
    rows = []
    for currency, rate in rates.items():
        row = {
            "currency": currency,
            "rate": rate,
            "last_update": time_last_update_utc,
            "next_update": time_next_update_utc,
            "api_pull_datetime" : current_pull_time
        }
        rows.append(row)
    return rows

def lambda_handler(event, context):
    api_url = os.environ['api_url']
    data = get_data(api_url)
    # Extract necessary information
   
    extracted_data = extract_currency_data(data)
    json_lines = "\n".join(json.dumps(row) for row in extracted_data)
    
    s3_client = boto3.client('s3')
    s3_bucket = os.environ['bucket_destination']
    s3_key = f"currency_data/currency_data_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.json"
    s3_client.put_object(Bucket=s3_bucket, Key=s3_key, Body=json_lines)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

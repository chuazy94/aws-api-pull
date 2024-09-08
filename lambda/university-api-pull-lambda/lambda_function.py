import json
import requests
import boto3
import json
import os
from datetime import datetime
import random
## import pandas as pd

def get_data(api_url):
    response = requests.get(api_url)
    if response.status_code == 200:
        print('Successfully pulled')
        return response.json()
    else:
        raise Exception(f'Failed to pull data with {response.status_code}')
        

def extract_university_fees_data(data):

    # Randomly generate some tuition fee value
    current_pull_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    for uni in data:
        uni['annual_tuition_fee'] = random.randint(10000,90000)
        uni['api_pull_datetime'] = current_pull_time
    
    return data

def lambda_handler(event, context):
    api_url = os.environ['api_url']
    data = get_data(api_url)
    uni_data = extract_university_fees_data(data)
    # Extract necessary information
    
    #extracted_data = extract_currency_data(data)
    json_lines = "\n".join(json.dumps(item) for item in uni_data)

    data_dumps = json.dumps(data)
    s3_client = boto3.client('s3')
    s3_bucket = os.environ['bucket_destination']
    s3_key = f"unversity_data/unversity_data_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.json"
    s3_client.put_object(Bucket=s3_bucket, Key=s3_key, Body=json_lines)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

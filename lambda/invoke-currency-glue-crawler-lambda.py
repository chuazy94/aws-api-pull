import json
import boto3
import time
import os

def lambda_handler(event, context):
    # Initialize Glue client
    glue_client = boto3.client('glue')

    
    # Specify the crawler name
    crawler_name = os.environ['crawler_name']
    
    max_retries = 10
    retry_count = 0
    wait_time = 30  # seconds
    
    try:
        # Start the Glue Crawler
        glue_client.start_crawler(Name=crawler_name)
        print(f"Started Glue Crawler: {crawler_name}")
        
        while retry_count < max_retries:
            # Check the status of the crawler
            response = glue_client.get_crawler(Name=crawler_name)
            crawler_state = response['Crawler']['State']
            print(f"Crawler {crawler_name} is in state: {crawler_state}")
            
            if crawler_state == 'READY':
                # Crawler has completed
                print(f"Crawler {crawler_name} has completed successfully.")
                break
            print('Crawler not ready yet, lets wait ')    
            # If crawler is not ready, wait for 30 seconds before checking again
            time.sleep(wait_time)
            retry_count += 1
        
        # If the maximum retries have been reached
        print(f"Max retries reached. Crawler {crawler_name} did not reach 'READY' state.")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Max retries reached. Crawler {crawler_name} did not reach 'READY' state.")
        }
    
    except Exception as e:
        # Handle exception if the crawler fails to start or any other error occurs
        print(f"Error with Glue Crawler: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error with Glue Crawler: {str(e)}")
        }

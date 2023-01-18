import os
import json


def lambda_handler(event, context):
    json_region = os.environ['AWS_REGION']
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": json_region,
            "Client_Payload": event['requestContext']['authorizer']['client_payload'],
            "Principal_ID": event['requestContext']['authorizer']['principalId']
        })
    }

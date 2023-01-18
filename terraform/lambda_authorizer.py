import uuid


def lambda_handler(event, context):
    # Get the token from the authorization header
    token = event["authorizationToken"]
    uuidOne = uuid.uuid4()

    # Verify the token
    if not verify_token(token):
        return generate_policy(uuidOne.hex, "Deny", event["methodArn"], token)

    # Token is valid, generate an IAM policy
    return generate_policy(uuidOne.hex, "Allow", event["methodArn"], token)


def verify_token(token):
    # Verify the token here (e.g. by checking against a database or a JWT library)
    # and return true if the token is valid, false otherwise
    return True


def generate_policy(principal_id, effect, resource, client_payload):
    # Generate an IAM policy for the user
    return {
        "principalId": principal_id,
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [{
                "Action": "execute-api:Invoke",
                "Effect": effect,
                "Resource": resource
            }]
        },
        "context": {
            "client_payload": client_payload
        }
    }

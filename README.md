# AWS ApiGateway Custom Lambda Authorizer

This is a Proof of Concept for AWS ApiGateway using a Custom Lambda Authorizer for the endpoints.

The terraform code creates all the needed infrastructure:
- two lambdas
- one Api Gateway configured with a lambda as a custom authorizer and the other lambda as an endpoint
- IAM roles and policies for Lambdas and Api Gateway

To set it up:
```shell
terraform init
terraform plan
terraform apply
```

After the infra resources are created, run a curl command using the `api_endpoint` output from the terraform :
```shell
curl -s https://<api_endpoint> -H 'Authorization: some payload'
```

Example:
```shell
curl -s https://1234567890.execute-api.us-east-1.amazonaws.com/poc_api_auth/demo -H 'Authorization: some payload' | jq .
{
  "Region ": "us-east-1",
  "Client_Payload": "some payload",
  "Principal_ID": "e2bf74b4792e4d0b84acb843c8b3be79"
}
```

Lambda Event Payload is configured as `TOKEN`.

> Token authorizers are the most straight-forward. You specify the name of a header, usually Authorization, that is used to authenticate your request. The value of this header is passed into your custom authorizer for your authorizer to validate.

To destroy the created resources from AWS:
```shell
terraform destroy
```

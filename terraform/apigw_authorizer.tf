resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name = "${var.title}_lambda_authorizer"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  type = "TOKEN"
  authorizer_result_ttl_in_seconds = 0
  authorizer_uri = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.ApiGatewayInvokeLambdaRole.arn
}
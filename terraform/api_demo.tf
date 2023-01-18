#######################################
# /api/demo resource
#######################################
resource "aws_api_gateway_resource" "api_demo" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "demo"
}

#######################################
# /api/demo GET method
#######################################
resource "aws_api_gateway_method" "api_demo_GET" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_demo.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "api_demo_GET" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_demo.id
  http_method             = aws_api_gateway_method.api_demo_GET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.demo.invoke_arn
  credentials             = aws_iam_role.ApiGatewayInvokeLambdaRole.arn
}

resource "aws_lambda_permission" "apigw_lambda_demo_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/${aws_api_gateway_stage.rest_api.stage_name}/${aws_api_gateway_method.api_demo_GET.http_method}${aws_api_gateway_resource.api_demo.path}"
}

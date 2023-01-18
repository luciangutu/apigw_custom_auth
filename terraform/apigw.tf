#######################################
# API GATEWAY
#######################################
resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.title

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#######################################
# API GATEWAY STAGE
#######################################
resource "aws_api_gateway_stage" "rest_api" {
  stage_name           = var.title
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  deployment_id        = aws_api_gateway_deployment.rest_api.id
}

#######################################
# STAGE/deployment resource
#######################################
resource "aws_api_gateway_deployment" "rest_api" {
  depends_on = [
    aws_api_gateway_integration.api_demo_GET
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = ""

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(md5(file("${path.module}/api_demo.tf")))
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}


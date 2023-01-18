#######################################
# ApiGw invoke Lambda
#######################################
data "aws_iam_policy_document" "ApiGatewayInvokeLambdaRole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ApiGatewayInvokeLambdaRole" {
  name = format("%s-ApiGatewayInvokeLambdaRole", var.title)
  description = "ApiGateway Invoke Lambda Role"
  assume_role_policy = data.aws_iam_policy_document.ApiGatewayInvokeLambdaRole.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "ApiGatewayInvokeLambda" {
  role       = aws_iam_role.ApiGatewayInvokeLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}
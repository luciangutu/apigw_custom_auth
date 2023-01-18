##################
# LAMBDA ZIPFILE
##################
data "archive_file" "authorizer" {
    type          = "zip"
    source_file   = "lambda_authorizer.py"
    output_path   = "${path.cwd}/lambda_authorizer.zip"
}

##################
# LAMBDA FUNCTION
##################
resource "aws_lambda_function" "authorizer" {
  function_name = format("%s-authorizer", var.title)
  role = aws_iam_role.authorizer.arn
  runtime = "python3.9"
  handler = "lambda_authorizer.lambda_handler"
  memory_size = 256
  timeout = 10
  filename = "${path.cwd}/lambda_authorizer.zip"
  source_code_hash = data.archive_file.authorizer.output_base64sha256

  depends_on = [data.archive_file.authorizer, aws_iam_role.authorizer, aws_cloudwatch_log_group.authorizer]
}

#######################################
# CloudWatch Log Groups
#######################################
resource "aws_cloudwatch_log_group" "authorizer" {
  name              = format("/aws/lambda/%s-authorizer", var.title)
  retention_in_days = 7
}

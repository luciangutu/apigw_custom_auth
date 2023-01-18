##################
# LAMBDA ZIPFILE
##################
data "archive_file" "demo" {
    type          = "zip"
    source_file   = "demo.py"
    output_path   = "${path.cwd}/demo.zip"
}

##################
# LAMBDA FUNCTION
##################
resource "aws_lambda_function" "demo" {
  function_name = format("%s-demo", var.title)
  role = aws_iam_role.demo.arn
  runtime = "python3.9"
  handler = "demo.lambda_handler"
  memory_size = 256
  timeout = 10
  filename = "${path.cwd}/demo.zip"
  source_code_hash = data.archive_file.demo.output_base64sha256

  depends_on = [data.archive_file.demo, aws_iam_role.demo, aws_cloudwatch_log_group.demo]
}

#######################################
# CloudWatch Log Groups
#######################################
resource "aws_cloudwatch_log_group" "demo" {
  name              = format("/aws/lambda/%s-demo", var.title)
  retention_in_days = 7
}

##################################
# LAMBDA IAM Policy authorizer
##################################
resource "aws_iam_policy" "authorizer" {
  name        = format("%s-authorizer", var.title)
  description = "IAM Policy to grant necessary permissions to authorizer Lambda"
  policy      = data.aws_iam_policy_document.authorizer.json
}

data "aws_iam_policy_document" "authorizer" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      format("arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/%s-*", var.title)
    ]
  }
}

##################################
# LAMBDA IAM Role authorizer
##################################
resource "aws_iam_role" "authorizer" {
  name                  = format("%s-authorizer", var.title)
  description           = "Lambda IAM role for authorizer Lambda"
  assume_role_policy    = data.aws_iam_policy_document.authorizer_Role.json
  force_detach_policies = true
}

data "aws_iam_policy_document" "authorizer_Role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "authorizer" {
  role       = aws_iam_role.authorizer.name
  policy_arn = aws_iam_policy.authorizer.arn
  depends_on = [aws_iam_role.authorizer, aws_iam_policy.authorizer]
}


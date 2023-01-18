###########################
# LAMBDA IAM Policy demo
###########################
resource "aws_iam_policy" "demo" {
  name        = format("%s-demo", var.title)
  description = "IAM Policy to grant necessary permissions to demo Lambda"
  policy      = data.aws_iam_policy_document.demo.json
}

data "aws_iam_policy_document" "demo" {
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

###########################
# LAMBDA IAM Role demo
###########################
resource "aws_iam_role" "demo" {
  name                  = format("%s-demo", var.title)
  description           = "Lambda IAM role for demo Lambda"
  assume_role_policy    = data.aws_iam_policy_document.demo_Role.json
  force_detach_policies = true
}

data "aws_iam_policy_document" "demo_Role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "demo" {
  role       = aws_iam_role.demo.name
  policy_arn = aws_iam_policy.demo.arn
  depends_on = [aws_iam_role.demo, aws_iam_policy.demo]
}


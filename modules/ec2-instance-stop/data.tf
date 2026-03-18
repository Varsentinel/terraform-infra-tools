# IAM assume role policy for Lambda
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM permissions policy for Lambda
data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid    = "AllowLambdaToStopEC2"
    effect = "Allow"

    actions = [
      "ec2:StopInstances",
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowLambdaToUseKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowLambdaToWriteCW"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.function_name}*"
    ]
  }
}

# Package the Lambda function code
data "archive_file" "ec2-stop" {
  type        = "zip"
  source_dir  = "${path.module}/script"
  output_path = "${path.module}/lambda/function.zip"
  excludes    = tolist(fileset("${path.module}/script/.venv", "**"))
}
# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowLambdaToStopEC2"
    effect = "Allow"

    actions = [
      "ec2:StopInstances",
      "ec2:DescribeInstances"
    ]
  }

  statement {
    sid    = "AllowLambdaToUseKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
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
      "arn:aws:logs:${var.region}:${var.account_id}:log-group/aws/lambda/ops/${var.function_name}"
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
# Lambda function
resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "/aws/lambda/ops/${var.function_name}"
  retention_in_days = 7
}

resource "aws_lambda_function" "ec2-stop" {
  filename         = data.archive_file.ec2-stop.output_path
  function_name    = var.function_name
  role             = aws_iam_role.ec2-stop.arn
  handler          = "main.lambda_handler"
  code_sha256      = data.archive_file.ec2-stop.output_sha256
  timeout          = 900
  memory_size      = "256"
  source_code_hash = data.archive_file.ec2-stop.output_base64sha256
  publish          = true


  runtime = "python3.12"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
  logging_config {
    log_group             = aws_cloudwatch_log_group.cw_log_group.name
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }
}

resource "aws_cloudwatch_event_rule" "ec2-stop" {
  name                = var.function_name
  description         = "Daily triggered at 12:00 AM for ${var.function_name}"
  schedule_expression = "cron(0 17 * * ? *)"
}

resource "aws_cloudwatch_event_target" "ec2-stop" {
  rule      = aws_cloudwatch_event_rule.ec2-stop.name
  target_id = aws_lambda_function.ec2-stop.function_name
  arn       = aws_lambda_function.ec2-stop.arn
}

resource "aws_lambda_permission" "ec2-stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2-stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2-stop.arn
}
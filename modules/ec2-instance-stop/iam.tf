resource "aws_iam_role" "ec2-stop" {
  name               = "${var.function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "ec2-stop" {
  name   = "${var.function_name}-permissions"
  role   = aws_iam_role.ec2-stop.id
  policy = data.aws_iam_policy_document.lambda_permissions.json
}
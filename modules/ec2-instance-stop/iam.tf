resource "aws_iam_role" "ec2-stop" {
  name               = "${var.function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
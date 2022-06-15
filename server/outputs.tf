output "web_instance" {
  value = aws_instance.webserver.id
}

output "iam_policy" {
    value = aws_iam_policy.iam_policy
}

output "iam_role" {
    value = aws_iam_role.iam_role
}

output "test-attach" {
    value = aws_iam_role_policy_attachment.test-attach
}

output "instance_profile" {
    value = aws_iam_instance_profile.instance_profile
}

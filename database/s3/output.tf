output "s3_bucket" {
  value = aws_s3_bucket.bucket-demo1126.id
}

output "s3_bucket_object" {
  value = aws_s3_bucket_object.object.id
}

output "test-role" {
  value = aws_iam_role.test-role.id
}

output "test-policy" {
  value = aws_iam_policy.test-policy.id
}

output "test-attach" {
  value = aws_iam_role_policy_attachment.test-attach.id
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.test-profile.id
}

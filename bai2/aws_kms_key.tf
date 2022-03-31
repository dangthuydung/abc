resource "aws_kms_key" "kms_key_abc" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "alias" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.kms_key_abc.key_id
}
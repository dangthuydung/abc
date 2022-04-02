/*terraform {
  backend "s3" {
    bucket = "terraform-bucket-abfffuww"
    key ="key/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-dynamodb-loking"
    encrypt = true
    kms_key_id = "alias/my-key-alias"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "terraform-bucket-abfffuww"
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt-configuration_example" {
  bucket = aws_s3_bucket.b.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_key_abc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "example122" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform-dynamodb-loking"
  #billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
*/
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.aws_vpc_endpoint
  service_name = "com.amazonaws.ap-southeast-1.s3"
}

resource "aws_s3_bucket" "bucket-demo1126" {
  bucket = "${var.bucket_name}"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  acl    = var.acl_bucket
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  key    = var.key_bucket_object_1
  acl = var.acl_bucket
  source = var.source_bucket_object_1
  etag = var.etag_bucket_object_1
}

// ec2 truy cap vao s3 bang IAM
resource "aws_iam_role" "test-role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "test-policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.test-role.name
  policy_arn = aws_iam_policy.test-policy.arn
}

resource "aws_iam_instance_profile" "test-profile" {
  name = "test_profile"
  role = aws_iam_role.test-role.name
}

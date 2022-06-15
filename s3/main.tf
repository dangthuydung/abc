resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.aws_vpc_endpoint
  service_name = "com.amazonaws.ap-southeast-1.s3"
}

resource "aws_s3_bucket" "bucket123456abcddd22" {
  bucket = "my-tf-test-bucket112"

  tags = {
    Name        = "${var.bucket_name}"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket123456abcddd22.id
  acl    = var.acl
}

resource "aws_s3_bucket_object" "object_1" {
  bucket = aws_s3_bucket.bucket123456abcddd22.id
  key    = "nginx.txt"
  acl    = "private"  
  source = "./s3/nginx.txt"
  etag = filemd5("./s3/nginx.txt")
}

resource "aws_s3_bucket_object" "object_12" {
  bucket = aws_s3_bucket.bucket123456abcddd22.id
  key    = "ssl-params.txt"
  acl    = "private"  
  source = "./s3/ssl-params.txt"
  etag = filemd5("./s3/ssl-params.txt")
}

resource "aws_s3_bucket_object" "object_123" {
  bucket = aws_s3_bucket.bucket123456abcddd22.id
  key    = "env.txt"
  acl    = "private"  
  source = "./s3/env.txt"
  etag = filemd5("./s3/env.txt")
}

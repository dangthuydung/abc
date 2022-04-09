# Create a bucket
resource "aws_s3_bucket" "bucket-demo1126" {
  bucket = "bucket-demo1126"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  acl    = "private"
}

# Upload an object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  key    = "nginx.txt"
  acl    = "private"  # or can be "public-read"
  source = "/home/dang/abc/bai2/nginx.txt"
  etag = filemd5("/home/dang/abc/bai2/nginx.txt")
}

resource "aws_s3_bucket_object" "object-111" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  key    = "env.txt"
  acl    = "private"  # or can be "public-read"
  source = "/home/dang/abc/bai2/env.txt"
  etag = filemd5("/home/dang/abc/bai2/env.txt")
}

resource "aws_s3_bucket_object" "object-1112" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  key    = "app-key-1.pem"
  acl    = "private"  # or can be "public-read"
  source = "/home/dang/bbb/abc/bai2/app-key-1.txt"
  etag = filemd5("/home/dang/bbb/abc/bai2/app-key-1.txt")
}
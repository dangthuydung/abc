/*resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.ap-southeast-1.s3"
}

resource "aws_s3_bucket" "bucket-demo1126" {
  bucket = "bucket-demo1126"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.bucket-demo1126.id
  acl    = var.acl_bucket
}

//lien ket ec2 - s3_bucket

*/
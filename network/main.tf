resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "${var.instance_tenancy}"

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_numbers
  vpc_id     = aws_vpc.vpc.id

  //10.0.0.0/16
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4 ,each.value)

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnet_numbers
  vpc_id     = aws_vpc.vpc.id

  //10.0.0.0/16
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4 ,each.value)

  tags = {
    Name = "Main"
  }
}


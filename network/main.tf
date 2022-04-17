resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "${var.instance_tenancy}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_numbers
  vpc_id     = var.vpc_id

  //10.0.0.0/16
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4 ,each.value)

  tags = {
    Name = "${var.publicsubnet_name}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnet_numbers
  vpc_id     = var.vpc_id

  //10.0.0.0/16
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4 ,each.value)

  tags = {
    Name = "${var.privatesubnet_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
}

resource "aws_route_table_association" "public" {
  for_each  = aws_subnet.public_subnets_numbers
  subnet_id = aws_subnet.public_subnets_numbers[each.key].id
  route_table_id = aws_route_table.public.id

}

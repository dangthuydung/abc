resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "${var.instance_tenancy}"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_numbers)
  vpc_id     = aws_vpc.main.id
  availability_zone = element(var.subnet_azs, count.index)
  cidr_block = element(var.public_subnet_numbers, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.publicsubnet_name}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_numbers)
  vpc_id     = aws_vpc.main.id
  availability_zone = element(var.subnet_azs, count.index)
  cidr_block = element(var.private_subnet_numbers, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.privatesubnet_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = length(var.public_subnet_numbers)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.route_table.id

}


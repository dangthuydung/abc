resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "${var.vpc_instance_tenancy}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet, count.index)
  availability_zone = element(var.subnet_azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet, count.index)
  availability_zone = element(var.subnet_azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "route_table_id" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = length(var.public_subnet)
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.route_table_id.id

}

resource "aws_security_group" "security_group" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  tags = {
    Name = "allow_ssh"
  }
}


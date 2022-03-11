# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

#create a VPC
resource "aws_vpc" "vpc-1" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "vpc-1"
  }
}

#tao internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "internet-gateway"
  }
}
# tao subnet 
resource "aws_subnet" "subnet-public-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "subnet-public-1"
  }
}
resource "aws_subnet" "subnet-private-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "subnet-private-1"
  }
}

#tao route table

resource "aws_route_table" "routetable-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "routetable-1"
  }
}

#associate with publicsubnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.routetable-1.id
}

#tao security group
resource "aws_security_group" "web_traffic-1" {
  name        = "web_traffic-1"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.vpc-1.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-traffic-1"
  }
}

# tao network interface

resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.subnet-public-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.web_traffic-1.id]


}
 #tao ElasticIP
 resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}
#tao EC2
resource "aws_instance" "EC2-instance11" {
  ami           = "ami-0abb8f6b71e7614d5"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }
  key_name = "RSA-key"

  tags = {
    Name = "EC2-instance"
  }
}
resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "${var.instance_tenancy}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_numbers
  vpc_id     = aws_vpc.main.id
  map_public_ip_on_launch = true

  //10.0.0.0/16
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4 ,each.value)

  tags = {
    Name = "${var.publicsubnet_name}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnet_numbers
  vpc_id     = aws_vpc.main.id
  map_public_ip_on_launch = false

  //10.0.0.0/16
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4 ,each.value)

  tags = {
    Name = "${var.privatesubnet_name}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  for_each  = aws_subnet.public_subnets
  subnet_id = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public.id

}

//security group
resource "aws_security_group" "basion-sg" {
  name        = "basion-s"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh from VPC"
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
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "basion-s"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app-demo-sg"
  }
}

resource "aws_security_group_rule" "example11" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.basion-sg.id 
  security_group_id = aws_security_group.web-sg.id
}


# tao 1 vpc
resource "aws_vpc" "vpc-demo-1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-demo-1"
  }
}

#tao subnet
resource "aws_subnet" "subnet-public-1" {
  vpc_id     = aws_vpc.vpc-demo-1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "subnet-public-1"
  }
}

resource "aws_subnet" "subnet-private-1" {
  vpc_id     = aws_vpc.vpc-demo-1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "subnet-private-1"
  }
}

resource "aws_subnet" "subnet-private-2" {
  vpc_id     = aws_vpc.vpc-demo-1.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "subnet-private-2"
  }
}

resource "aws_subnet" "subnet-public-2" {
  vpc_id     = aws_vpc.vpc-demo-1.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "subnet-public-2"
  }
}
#tao internet gateway
resource "aws_internet_gateway" "gw-demo" {
  vpc_id = aws_vpc.vpc-demo-1.id

  tags = {
    Name = "internet gateway demo"
  }
}

#tao routetable
resource "aws_route_table" "route-table-demo" {
  vpc_id = aws_vpc.vpc-demo-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-demo.id
  }

  tags = {
    Name = "route-table-demo"
  }
}

# routetable association
resource "aws_route_table_association" "a" {
  subnet_id      = [aws_subnet.subnet-public-1.id, aws_subnet.subnet-public-2.id]
  route_table_id = aws_route_table.route-table-demo.id
}

#tao security group
resource "aws_security_group" "basion-demo-sg" {
  name        = "basion-demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc-demo-1.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "basion-demo-sg"
  }
}

resource "aws_security_group" "app-demo-sg" {
  name        = "app-demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc-demo-1.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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
    Name = "app-demo-sg"
  }
}

#security group cho alb
resource "aws_security_group" "alb-demo-sg" {
  name        = "lb-demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc-demo-1.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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
    Name = "alb-demo-sg"
  }
}

resource "aws_security_group_rule" "example11" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.basion-demo-sg.id 
  security_group_id = aws_security_group.app-demo-sg.id
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.basion-demo-sg.id
}

# tao network interface
resource "aws_network_interface" "test1" {
  subnet_id       = [
    aws_subnet.subnet-public-1.id, 
    aws_subnet.subnet-public-2.id]
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.basion-demo-sg.id]

}

resource "aws_network_interface" "test2" {
  subnet_id       = aws_subnet.subnet-private-1.id
  private_ips     = ["10.0.2.51"]
  security_groups = [aws_security_group.app-demo-sg.id]


}

#tao ElasticIP
 resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test1.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw-demo]
}

#tao ec2 instance
resource "aws_instance" "basion-demo-ec2" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  key_name = "bastion-key"

  network_interface {
    network_interface_id = aws_network_interface.test1.id
    device_index         = 0
  }
  
  credit_specification {
    cpu_credits = "unlimited"
  }
  
  tags = {
      name = "basion-demo-ec2"
  }
}

resource "aws_instance" "app-demo-ec2" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  key_name = "app-key"

  network_interface {
    network_interface_id = aws_network_interface.test2.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
      name = "app-demo-ec2"
  }
  user_data = <<-EOF
    sudo apt install -y update
    sudo apt install -y nginx
  EOF
}

#tao alb
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb-demo"

  load_balancer_type = "application"

  vpc_id             = "vpc-demo-1"
  subnets            = [
    aws_subnet.subnet-public-1.id,
    aws_subnet.subnet-public-2.id]
  security_groups    = [aws_security_group.alb-demo-sg.id]

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-0123456789abcdefg"
          port = 80
        },
        {
          target_id = "i-a1b2c3d4e5f6g7h8i"
          port = 8080
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}

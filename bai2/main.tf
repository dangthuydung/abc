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
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.route-table-demo.id
}

#tao security group
resource "aws_security_group" "basion-demo-sg" {
  name        = "basion-demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc-demo-1.id

  ingress {
    description      = "SSH"
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
    Name = "basion-demo-sg"
  }
}


resource "aws_security_group" "app-demo-sg" {
  name        = "app-demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc-demo-1.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.basion-demo-sg.id]
    
  }

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
    Name = "basion-demo-sg"
  }
}

# tao network interface

resource "aws_network_interface" "test1" {
  subnet_id       = aws_subnet.subnet-public-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.basion-demo-sg.id]


}

resource "aws_network_interface" "test2" {
  subnet_id       = aws_subnet.subnet-private-1.id
  private_ips     = ["10.0.1.51"]
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
  key_name = "basion-key"

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
  key_name = "app-demo-key"

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
    sudo apt install mysql-server
    sudo apt install php-fpm php-mysql


  EOF

}
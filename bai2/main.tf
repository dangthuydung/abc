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
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.route-table-demo.id
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.subnet-public-2.id
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
  subnet_id       = aws_subnet.subnet-public-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.basion-demo-sg.id]

}

resource "aws_network_interface" "test2" {
  subnet_id       = aws_subnet.subnet-public-2.id
  private_ips     = ["10.0.4.51"]
  security_groups = [aws_security_group.app-demo-sg.id]
}

#tao ElasticIP
 resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test1.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw-demo]
}

resource "aws_eip" "two" {
  vpc                       = true
  network_interface         = aws_network_interface.test2.id
  associate_with_private_ip = "10.0.4.51"
  depends_on                = [aws_internet_gateway.gw-demo]
}

#tao ec2 instance
resource "aws_instance" "basion-demo-ec2" {
  ami           = "ami-0801a1e12f4a9ccc0"
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
  ami           = "ami-0801a1e12f4a9ccc0"
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
    sudo apt install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbst
    sudo apt install composer -y
    composer create-project --prefer-dist laravel/laravel my_app
  EOF
}

#tao alb
resource "aws_alb" "test-alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-demo-sg.id]
  subnets            = [aws_subnet.subnet-public-2.id,aws_subnet.subnet-public-1.id]

  enable_deletion_protection = false
}

#tao alb target group 
resource "aws_alb_target_group" "alb-tg-demo" {
  name = "alb-tg-demo"
  port = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-demo-1.id
}   

# tao alb target group attachment
resource "aws_alb_target_group_attachment" "attach-alb-demo" {
  target_group_arn = aws_alb_target_group.alb-tg-demo.arn
  target_id        = aws_instance.app-demo-ec2.id
  port             = 80
}

#tao listener cho alb
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.test-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-tg-demo.arn
  }
}

resource "aws_alb_listener_rule" "static" {
  listener_arn = aws_alb_listener.alb-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-tg-demo.arn
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }
}


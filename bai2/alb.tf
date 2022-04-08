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

   health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}   
/*
# tao alb target group attachment
resource "aws_alb_target_group_attachment" "attach-alb-demo" {
  target_group_arn = aws_alb_target_group.alb-tg-demo.arn
  target_id        = aws_instance.app-demo-ec2.id
  port             = 80
}
*/

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

resource "aws_autoscaling_attachment" "alb_autoscale" {
  alb_target_group_arn   = aws_alb_target_group.alb-tg-demo.arn
  autoscaling_group_name = aws_autoscaling_group.aws-asg-demo.id
}


resource "aws_alb" "test-alb" {
  name               = "${var.name_alb}"
  internal           = false // If true, the LB will be internal.
  load_balancer_type = "application"
  security_groups    = [var.security_group_id_alb]
  subnets            = var.public_subnets_id

  enable_deletion_protection = false // ngan xoa alb

  tags = {
    Environment = "production"
  }
}

resource "aws_alb_target_group" "alb-tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30 // khoang tgian check
    path                = "/index.html" // duong dan dich
    port                = 80
    protocol            = "HTTP"
    timeout             = 5 //tgian cho
    unhealthy_threshold = 2 // so lan check khong thanh cong
    matcher             = 200 // ma phan hoi
  }
}

resource "aws_alb_target_group_attachment" "alb-tg-attach" {
  target_group_arn = aws_alb_target_group.alb-tg.arn
  target_id        = var.web_instance_id
  port             = 80
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.test-alb.arn
  port              = "80"
  protocol          = "HTTP"
  //ssl_policy        = "ELBSecurityPolicy-2016-08"
  //certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward" 
    target_group_arn = aws_alb_target_group.alb-tg.arn
  }
}

resource "aws_alb_listener_rule" "target" {
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 100

  action {
    type             = "forward" // phuong thuc dinh tuyen
    target_group_arn = aws_alb_target_group.alb-tg.arn
  }

  condition {
    path_pattern { // cai dat dieu kien. htai chi ho tro path..
      values = ["/target/*"] // khop thi chuyen den target group
    }
  }
}


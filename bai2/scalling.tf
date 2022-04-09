data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

#security group cho instance_type
resource "aws_security_group" "instance-sg" {
  name        = "instance-sg"
  description = "security group for instance"
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
    
  } 
  tags = {
    Name = "instance security group"
  }
}

  resource "aws_security_group_rule" "example111" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.basion-demo-sg.id 
  security_group_id = aws_security_group.instance-sg.id
}

 

resource "aws_launch_configuration" "aws_launch_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "app-key-1"
  user_data = <<EOF
    #!/bin/bash
  sudo apt -y update
  sudo apt install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  aws s3 cp s3:///bucket-demo1126/app-key-1.pem 
  EOF

  security_groups = [aws_security_group.instance-sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aws-asg-demo" {
  name                      = "aws-autoscaling-group-test"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 4
  force_delete              = true
  launch_configuration      = aws_launch_configuration.aws_launch_conf.name
  vpc_zone_identifier       = [aws_subnet.subnet-public-2.id,aws_subnet.subnet-public-1.id]

  tag {
    key                 = "Name"
    value               = "custome-ec2-instance"
    propagate_at_launch = true
  }
}

/*
resource "aws_autoscaling_policy" "aws-as-policy-demo" {
  name                   = "aws-autoscaling-policy-demo"
  scaling_adjustment     = 4 # The number of instances by which to scale
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.aws-asg-demo.name
  policy_type = "SimpleScaling"
}

#create cloud watch monitoring
resource "aws_cloudwatch_metric_alarm" "aws-cloudwatch-demo" {
  alarm_name                = "aws_cloudwatch_metric_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.aws-asg-demo.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.aws-as-policy-demo.arn]
  actions_enabled = true
}

#descaling policy
resource "aws_autoscaling_policy" "aws-as-policy-scaledown" {
  name                   = "aws-autoscaling-policy-scaledown"
  scaling_adjustment     = -1 # The number of instances by which to scale
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.aws-asg-demo.name
  policy_type = "SimpleScaling"
}

#decloud watch
resource "aws_cloudwatch_metric_alarm" "aws-cloudwatch-scaledown" {
  alarm_name                = "terraform-aws-cloudwatch-scaledown"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.aws-asg-demo.name
  }

  alarm_description = "This metric monitors ec2 cpu decreases"
  alarm_actions     = [aws_autoscaling_policy.aws-as-policy-demo.arn]
  actions_enabled = true
}


output "alb" {
  value = aws_alb.test-alb.dns_name
}
*/
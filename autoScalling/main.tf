data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "aws_launch_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_asg
  key_name = var.key_name_asg
  user_data = filebase64(var.path_user_data_asg)

  security_groups = [var.security_group_id_asg]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aws-asg" {
  name                      = var.asg_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  launch_configuration      = aws_launch_configuration.aws_launch_conf.name
  vpc_zone_identifier       = [element(var.public_subnets_id,2)]
  tag {
    key                 = "Name"
    value               = "custome-ec2-instance"
    propagate_at_launch = true
  }
}


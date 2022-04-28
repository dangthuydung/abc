output "aws_autoscaling_group" {
    value = aws_autoscaling_group.aws-asg.id
}

output "aws_launch_configuration" {
    value = aws_launch_configuration.aws_launch_conf.id
}
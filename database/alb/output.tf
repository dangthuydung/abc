output "test_alb" {
    value = aws_alb.test-alb.id
}

output "alb_target_group" {
    value = aws_alb_target_group.alb-tg.id
}

output "alb_target_group_attachment" {
    value = aws_alb_target_group_attachment.alb-tg-attach.id
}

output "aws_alb_listener" {
    value = aws_alb_listener.alb_listener.id
}

output "alb_listener_rule" {
    value = aws_alb_listener_rule.target.id
}

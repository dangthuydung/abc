output "aws_db_subnet_group" {
    value = aws_db_subnet_group.db_subnet_group.id
}

output "aws_db_instance" {
    value = aws_db_instance.db_instance.id
}

output "user_name" {
    value = aws_db_instance.db_instance.username
}

output "password" {
    value = aws_db_instance.db_instance.password
}


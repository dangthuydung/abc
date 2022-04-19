resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]
  tags = {
    Name = "My DB subnet group"

  }
}

resource "aws_db_instance" "db_instance" {
    identifier = "db-mysql" // name  RDS instance
  allocated_storage    = 10
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  name                 = var.db_name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}



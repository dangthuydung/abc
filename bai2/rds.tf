# tao mot MySQL RDS instance
resource "aws_db_instance" "demo_mysql_db" {
  identifier           = "db-mysql"
  allocated_storage    = 20
  storage_type         = "gp2"

  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"

  db_subnet_group_name = aws_vpc.vpc-demo-1.id

  name                 = "mydb-demo"
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql8.0"
  availability_zone    = "ap-southeast-1a"
  publicly_accessible = true
  skip_final_snapshot  = true
  
  tags = {
      name = "Demo Mysql"
  }
}
resource "aws_instance" "basion_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.key_name_basion
  subnet_id = element(var.public_subnet_ids,0)
  vpc_security_group_ids = var.security_group_id_basion
  tags = {
    Name = "basion instance"
  }
}

resource "aws_instance" "web_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.key_name_web
  subnet_id = element(var.public_subnet_ids,1)
  vpc_security_group_ids = var.security_group_id_web
  //A managed resource "aws_subnet" "public_subnets" has not been declared in module.module-server.
  tags = {
    Name = "web instance"
  }
}

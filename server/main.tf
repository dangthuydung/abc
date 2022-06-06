resource "aws_instance" "web_instance" {
  ami           = var.ami
  instance_type = "${var.instance_type}"
  associate_public_ip_address = true
  key_name = var.key_name
  subnet_id = element(var.public_subnet,0)
  vpc_security_group_ids = var.security_group
  tags = {
    Name = "web_instance"
  }
}
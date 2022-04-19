resource "aws_instance" "basion_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.key_name_basion
  subnet_id = aws_subnet.public_subnets[1].id
  //A managed resource "aws_subnet" "public_subnets" has not been declared in module.module-server.
  // em co gan map cho public subnet ma sao o day ghi k khai bao a?
│ 
  vpc_security_group_ids = [aws_security_group.basion-sg.id]
  tags = {
    Name = "basion instance"
  }
}

resource "aws_instance" "web_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.key_name_web
  subnet_id = aws_subnet.public_subnets[2].id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  tags = {
    Name = "web instance"
  }
}
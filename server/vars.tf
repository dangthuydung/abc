variable "ami" {
  type = string
  default = "ami-055d15d9cfddf7bd3"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name_basion" {
    type = string
    default = "bastion-key"
}

variable "key_name_web" {
    type = string
    default = "app-key-1"
}
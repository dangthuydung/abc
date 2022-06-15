variable "ami" {
  default = "ami-0750a20e9959e44ff"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "public_subnet" {}

variable "key_name" {
    default = "app-key-1"
}

variable "security_group" {
    type = list
}

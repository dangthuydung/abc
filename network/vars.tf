variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  default = "test vpc"
}

variable "instance_tenancy" {
    description = "A tenancy option for instances launched into the VPC"
    type = string
    default = "default"
}

variable "public_subnet_numbers" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_numbers" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "subnet_azs" {
  type = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "publicsubnet_name" {
  type = string
  default = "public subnet"
}

variable "privatesubnet_name" {
  type = string
  default = "private subnet"
}






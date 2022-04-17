
variable "vpc_id" {}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
}

variable "vpc_name" {
  type = string
}

variable "instance_tenancy" {
    description = "A tenancy option for instances launched into the VPC"
    type = string
  
}

variable "public_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for public subnets"

  default = {
    "ap-southeast-1a" = 1
    "ap-southeast-1b" = 2
  }
}

variable "private_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for private subnets"

  default = {
    "ap-southeast-1a" = 4
    "ap-southeast-1b" = 5
  }
}

variable "publicsubnet_name" {
  type = string
  default = "public subnet"
}

variable "privatesubnet_name" {
  type = string
  default = "private subnet"
}



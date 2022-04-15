variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
    description = "A tenancy option for instances launched into the VPC"
    type = string
    default = "default"
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


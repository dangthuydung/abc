variable "vpc_name" {}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
    default = "default"
} 

variable "public_subnet" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]  
} 

variable "private_subnet" {
    type = list(string)
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "subnet_azs" {
    type = list(string)
    default = ["ap-southeast-1a", "ap-southeast-1b"]
}
variable "instance_type_asg" {
    type = string
    default = "t2.micro"
}

variable "key_name_asg" {
    type = string
    default = "app-key-1"
}

variable "path_user_data_asg" {
    type = string
    default = "/home/dang/bai3_module/abc/autoScalling/bashh.sh"
}

variable "security_group_id_asg" {}

variable "asg_name" {}

variable "public_subnets_id" {}

variable "max_size" {
  type = string
  default = "5"
}

variable "min_size" {
  type = string
  default = "2"
}

variable "health_check_grace_period" {
  type = string
  default = "300"
}

variable "health_check_type" {
  type = string
  default = "EC2"
}

variable "desired_capacity" {
  type = string
  default = "4"
}

variable "force_delete" {
  type = bool
  default = "true"
}
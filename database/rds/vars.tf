variable "engine" {
    type = string
    default = "mysql"
}

variable "engine_version" {
    type = string
    default = "5.7"
}

variable "instance_class" {
    type = string
    default = "db.t2.micro"
}

variable "db_name" {
    type = string
    default = "mydb"
}

variable "username" {
    type = string
    default = "admin"
}

variable "password" {
    type = string
    default = "pass12345678"
    sensitive = true
}

variable "public_subnet_ids" {
    type = list
}
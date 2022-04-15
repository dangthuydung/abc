provider "aws" {
    region = "ap-southeast-1"
}

module "module-network" {
    source = "/home/dang/terraform-demo/modules/network" 
}

module "module-database" {
    source = "/home/dang/terraform-demo/modules/database"  
}

module "module-server" {
    source = "/home/dang/terraform-demo/modules/server"
}

provider "aws" {
    region = "ap-southeast-1"
}

module "module-network" {
    source = "/home/dang/modules/network"
}

module "module-database" {
    source = "/home/dang/modules/database"  
}

module "module-server" {
    source = "/home/dang/modules/server"
}

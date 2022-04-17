provider "aws" {
    region = "ap-southeast-1"
}

module "module-network" {
    source = "/home/dang/modules/network"
    vpc_cidr_block = "10.0.0.0/16" 
    vpc_name = "test-vpc-module"
    instance_tenancy = "default"
    vpc_id = aws_vpc.main.vpc_id //?? em bi loi 
    // A managed resource "aws_vpc" "main" has not been declared in the root module.
// em khong biet sua nhu nao??? 

    route_table_public_id = aws_route_table.public.route_table_public_id
    internet_gateway_id = aws_internet_gateway.igw.internet_gateway_id

}

module "module-database" {
    source = "/home/dang/modules/database"  
}

module "module-server" {
    source = "/home/dang/modules/server"
}

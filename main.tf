provider "aws" {
    region = "ap-southeast-1"
}

module "module-network" {
    source = "/home/dang/modules/network"
}


module "module-server" {
    source = "/home/dang/modules/server"
    public_subnet_ids  = module.module-network.public_subnets_id
    private_subnet_ids = module.module-network.private_subnets_id
    security_group_id_basion = [module.module-network.security_group_id_basion]
    security_group_id_web = [module.module-network.security_group_id_web]
    aws_iam_instance_profile = module.module-database-s3.aws_iam_instance_profile
}

module "module-database-rds" {
    source = "/home/dang/modules/database/rds" 
    public_subnet_ids  = [module.module-network.public_subnets_id]
    
}
module "module-database-s3" {
    source = "/home/dang/modules/database/s3"
    bucket_name = "bucket-example-112236"
    key_bucket_object_1 = "README.md"
    source_bucket_object_1 = "/home/dang/modules/README.md"
    etag_bucket_object_1 = filemd5("/home/dang/modules/README.md")
    aws_vpc_endpoint = module.module-network.vpc_id
}

module "module-database-alb" {
    source = "/home/dang/modules/database/alb"
    name_alb = "alb-demo"
    public_subnets_id = module.module-network.public_subnets_id
    security_group_id_alb = module.module-network.security_group_id_alb
    web_instance_id = module.module-server.web_instance_id
    vpc_id = module.module-network.vpc_id
}

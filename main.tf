provider "aws" {
    region = "ap-southeast-1"
}

module "module-network" {
    source = "/home/dang/modules/network"
}

module "module-database-rds" {
    source = "/home/dang/modules/database/rds" 
    public_subnet_ids  = [module.module-network.public_subnets_id
    ]
}

module "module-server" {
    source = "/home/dang/modules/server"
    public_subnet_ids  = module.module-network.public_subnets_id
    private_subnet_ids = module.module-network.private_subnets_id
    security_group_id_basion = [module.module-network.security_group_id_basion]
    security_group_id_web = [module.module-network.security_group_id_web]
}

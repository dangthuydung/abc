provider "aws" {
  region = "ap-southeast-1"
}

module "module_network" {
    source = "./network"
}

module "module_server"{
    source = "./server"
    public_subnet = module.module_network.public_subnet
    security_group = [module.module_network.security_group]
}

module "module_ECR" {
  source = "./ECS"
  cluster_name = "cluster_demo"
  public_subnet = module.module_network.public_subnet
}

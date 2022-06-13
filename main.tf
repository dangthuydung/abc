provider "aws" {
  region = "ap-southeast-1"
}

module "network-module" {
  source = "./network"
}

module "eks-module" {
  source = "./EKS"
  public_subnets = module.network-module.public_subnets_id
}

output "config_map_aws_auth" {
  value = module.eks-module.config_map_aws_auth
}
output "kubeconfig" {
  value = module.eks-module.kubeconfig
}
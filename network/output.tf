output "vpc_cidr_block" {
    description = "The CIDR block of the VPC"
    value = aws_vpc.vpc.cidr_block
}

output "vpc_instance_tenancy" {
    value = aws_vpc.vpc.instance_tenancy
}

output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "vpc_public_subnet" {
    value = {
        for subnet in aws_subnet.public_subnets :
        subnet.id => subnet.cidr_block
    }
}

output "vpc_private_subnet" {
    value = {
        for subnet in aws_subnet.private_subnets :
        subnet.id => subnet.cidr_block
    }
}
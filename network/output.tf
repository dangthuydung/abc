output "vpc_id" {
    value = aws_vpc.main.id
}

output "vpc_cidr_block" {
    description = "The CIDR block of the VPC"
    value = aws_vpc.main.cidr_block
}

output "vpc_instance_tenancy" {
    value = aws_vpc.main.instance_tenancy
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

output "internet_gateway_id" {
    value = aws_internet_gateway.igw.id
}

output "route_table_public_id"{
    value = aws_route_table.public.id
}
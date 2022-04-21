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

output "public_subnets_id" {
    value =aws_subnet.public_subnets[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.igw.id
}

output "route_table_public_id"{
    value = aws_route_table.route_table.id
}

output "security_group_id_basion" {
    value = aws_security_group.basion-sg.id
}

output "security_group_id_web" {
    value = aws_security_group.web-sg.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
    value = aws_vpc.main.cidr_block 
}

output "vpc_instance_tenancy" {
    value =  aws_vpc.main.instance_tenancy
}

output "public_subnet" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

output "route_table" {
  value = aws_route_table.route_table_id.id
}

output "internet_gateway" {
  value = aws_internet_gateway.gw.id
}

output "route_table_association" {
  value = aws_route_table_association.route_table_association
}

output "security_group" {
  value = aws_security_group.security_group.id
}

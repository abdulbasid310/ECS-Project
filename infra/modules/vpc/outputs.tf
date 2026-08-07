output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
    value = aws_subnet.PublicSubnet[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.PrivateSubnet[*].id
}
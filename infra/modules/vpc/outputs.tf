output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
    value = [aws_subnet.PublicSubnetA.id, aws_subnet.PublicSubnetB.id]
}
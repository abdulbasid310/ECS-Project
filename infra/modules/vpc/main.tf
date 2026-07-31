resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Two public subnets and two private subnets across different AZs for availability
resource "aws_subnet" "PublicSubnetA" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az_A
}

resource "aws_subnet" "PublicSubnetB" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.az_B
}

resource "aws_subnet" "PrivateSubnetA" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az_A 
}

resource "aws_subnet" "PrivateSubnetB" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = var.az_B 
}  

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.PublicSubnetA.id

    depends_on = [
      aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_route_table_association" "public_subnet_association_A" {
  subnet_id      = aws_subnet.PublicSubnetA.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_B" {
  subnet_id      = aws_subnet.PublicSubnetB.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_associationA" {
  subnet_id = aws_subnet.PrivateSubnetA.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_associationB" {
  subnet_id = aws_subnet.PrivateSubnetB.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = { 
  Name = "my-vpc" 
  } 
}

# Two public subnets and two private subnets across different AZs for availability
resource "aws_subnet" "PublicSubnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]

  tags = {
  Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "PrivateSubnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
  Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
  Name = "gatus-internet-gateway"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.PublicSubnet[0].id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
  Name = "gatus-nat-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
  Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
  Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = 2
  subnet_id      = aws_subnet.PublicSubnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count = 2
  subnet_id = aws_subnet.PrivateSubnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Two public subnets and two private subnets across different AZs for availability
resource "aws_subnet" "PublicSubnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "PrivateSubnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
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
// 1. VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}-vpc"
  }
}

// 2. Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}

// 3. Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${var.name}-subnet-1"
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "${var.name}-subnet-2"
  }
}

// 4. Routing Table
resource "aws_route_table" "routing-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "${var.name}-routing-table"
  }
}

// 5. Routing Table Association (Subnet + Routing Table)
resource "aws_route_table_association" "routing-table-association-1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.routing-table.id
}
resource "aws_route_table_association" "routing-table-association-2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.routing-table.id
}

// 1. VPC
resource "aws_vpc" "iac-vpc-20220223" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "iac-vpc-20220223"
  }
}

// 2. Internet Gateway
resource "aws_internet_gateway" "iac-igw-20220223" {
  vpc_id = aws_vpc.iac-vpc-20220223.id

  tags = {
    Name = "iac-igw-20220223"
  }
}

// 3. Subnet
resource "aws_subnet" "iac-subnet-20220223" {
  vpc_id     = aws_vpc.iac-vpc-20220223.id
  cidr_block = "10.0.1.0/24"
}

// 4. Routing Table
resource "aws_route_table" "iac-routing-table-20220223" {
  vpc_id = aws_vpc.iac-vpc-20220223.id
  subnet_id = aws_subnet.iac-subnet-20220223.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac-igw-20220223.id
  }

  tags = {
    Name = "iac-routing-table-20220223"
  }
}

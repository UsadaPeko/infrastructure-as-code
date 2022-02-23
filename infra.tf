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

  tags = {
    Name = "iac-subnet-20220223"
  }
}

// 4. Routing Table
resource "aws_route_table" "iac-routing-table-20220223" {
  vpc_id = aws_vpc.iac-vpc-20220223.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac-igw-20220223.id
  }

  tags = {
    Name = "iac-routing-table-20220223"
  }
}

// 5. Routing Table Association (Subnet + Routing Table)
resource "aws_route_table_association" "iac-routing-table-association-20220223" {
  subnet_id      = aws_subnet.iac-subnet-20220223.id
  route_table_id = aws_route_table.iac-routing-table-20220223.id
}

// 6. Route53
resource "aws_route53_zone" "rhea-so" {
  name = "rhea-so.com"
}

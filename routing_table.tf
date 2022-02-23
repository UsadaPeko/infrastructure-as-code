resource "aws_route_table" "iac-routing-table" {
  vpc_id = aws_vpc.iac-vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.iac-igw.id
  }

  tags = {
    Name = "iac-routing-table"
  }
}

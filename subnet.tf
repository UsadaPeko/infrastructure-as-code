resource "aws_subnet" "iac-subnet" {
  vpc_id     = aws_vpc.iac-vpc.id
  cidr_block = "10.0.1.0/24"
}

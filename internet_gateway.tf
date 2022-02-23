resource "aws_internet_gateway" "iac-igw" {
  vpc_id = aws_vpc.iac-vpc.id

  tags = {
    Name = "iac-igw"
  }
}

// 1. VPC
resource "aws_vpc" "iac-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "iac-vpc"
  }
}

// 2. Internet Gateway
resource "aws_internet_gateway" "iac-igw" {
  vpc_id = aws_vpc.iac-vpc.id

  tags = {
    Name = "iac-igw"
  }
}

// 3. Subnet
resource "aws_subnet" "iac-subnet-1" {
  vpc_id     = aws_vpc.iac-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "iac-subnet-1"
  }
}
resource "aws_subnet" "iac-subnet-2" {
  vpc_id     = aws_vpc.iac-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "iac-subnet-2"
  }
}

// 4. Routing Table
resource "aws_route_table" "iac-routing-table" {
  vpc_id = aws_vpc.iac-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac-igw.id
  }

  tags = {
    Name = "iac-routing-table"
  }
}

// 5. Routing Table Association (Subnet + Routing Table)
resource "aws_route_table_association" "iac-routing-table-association-1" {
  subnet_id      = aws_subnet.iac-subnet-1.id
  route_table_id = aws_route_table.iac-routing-table.id
}
resource "aws_route_table_association" "iac-routing-table-association-2" {
  subnet_id      = aws_subnet.iac-subnet-2.id
  route_table_id = aws_route_table.iac-routing-table.id
}

// 6. Route53
resource "aws_route53_zone" "rhea-so" {
  name = "rhea-so.com"
  force_destroy = true
}

resource "aws_route53_record" "memo-domain" {
  zone_id = aws_route53_zone.rhea-so.zone_id
  name    = "atlantis.rhea-so.com"
  type    = "A"
  ttl     = "300"
  records = ["52.78.144.248"] // Atlantis EC2 (Terraform을 통해 만들지 않았음)
}

// 7. ECR
# resource "aws_ecr_repository" "iac-ecr" {
#   name                 = "iac-ecr"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

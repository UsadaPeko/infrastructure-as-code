// 1. Security Group
resource "aws_security_group" "iac-security-group-20220223" {
  name        = "iac-security-group-20220223"
  description = "Allow CoffeeTree inbound traffic"
  vpc_id      = aws_vpc.iac-vpc-20220223.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["39.7.28.205/32"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "iac-security-group-20220223"
  }
}

// 2. EC2
resource "aws_instance" "iac-ec2-20220223" {
   ami           = "ami-0454bb2fefc7de534"
   instance_type = "t3.nano"
   key_name = "Home"
   subnet_id = aws_subnet.iac-subnet-20220223.id
   vpc_security_group_ids = [aws_security_group.iac-security-group-20220223.id]

   tags = {
     Name = "iac-ec2-20220223"
   }
 }

// 3. EIP
resource "aws_eip" "iac-eip-20220223" {
  instance = aws_instance.iac-ec2-20220223.id
  vpc      = true

   tags = {
     Name = "iac-eip-20220223"
   }
}

// 4. Route53
resource "aws_route53_record" "iac-route53-20220223" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "iac.rhea-so.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.iac-eip-20220223.public_ip]
}

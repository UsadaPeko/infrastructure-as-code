resource "aws_security_group" "iac-security-group" {
  name        = "iac-security-group"
  description = "Allow Home inbound traffic"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["121.161.240.241/32"]
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
    Name = "iac-security-group"
  }
}

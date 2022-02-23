resource "aws_security_group" "allow_coffee_tree" {
  name        = "allow_coffee_tree"
  description = "Allow CoffeeTree inbound traffic"
  vpc_id      = aws_vpc.iac-vpc.id

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
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_coffee_tree"
  }
}

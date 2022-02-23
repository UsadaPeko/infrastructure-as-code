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

resource "aws_instance" "EC2" {
   ami           = "ami-0454bb2fefc7de534"
   instance_type = "t3.nano"
   key_name = "Home"
   subnet_id = aws_subnet.iac-subnet.id
   security_groups = [aws_security_group.allow_coffee_tree.id]

   tags = {
     Name = "EC2"
   }
 }

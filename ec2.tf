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
resource "aws_eip" "stage_server" {
  instance = aws_instance.iac-ec2-20220223.id
  vpc      = true
}

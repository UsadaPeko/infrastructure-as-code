resource "aws_instance" "iac-ec2" {
   ami                    = "ami-0454bb2fefc7de534"
   instance_type          = "t3.nano"
   key_name               = "Home"
   subnet_id              = aws_subnet.iac-subnet-1.id
   vpc_security_group_ids = [aws_security_group.iac-security-group.id]

   tags = {
     Name                 = "iac-ec2"
   }
 }


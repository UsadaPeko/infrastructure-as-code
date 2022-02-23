resource "aws_instance" "EC2" {
   ami           = "ami-0454bb2fefc7de534"
   instance_type = "t3.nano"
   key_name = "Home"
   subnet_id = aws_subnet.iac-subnet.id
   vpc_security_group_ids = [aws_security_group.allow_coffee_tree.id]

   tags = {
     Name = "EC2"
   }
 }

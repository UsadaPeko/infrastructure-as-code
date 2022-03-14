module "vpc" {
  source = "../../aws/vpc"

  name = var.name
}

resource "aws_instance" "ec2" {
   ami = var.ami
   instance_type = var.instance_type
   key_name = var.key_name
   subnet_id = module.vpc.subnet_ids[0]
   vpc_security_group_ids = [var.security_group_ids]

   tags = {
     Name = "${var.name}-ec2"
   }
 }

resource "aws_eip" "eip" {
  instance = aws_instance.ec2.id
  vpc = true

   tags = {
     Name  = "${var.name}-eip"
   }
}

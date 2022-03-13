# resource "aws_eip" "iac-eip" {
#   instance = aws_instance.iac-ec2.id
#   vpc      = true

#    tags = {
#      Name  = "iac-eip"
#    }
# }

# output "iac-eip" {
#   value       = aws_eip.iac-eip.public_ip
#   description = "Infrastructure as Code - ec2.tf - EIP"
# }

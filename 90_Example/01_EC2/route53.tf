# module "rhea-so"{
#   source = "../../02_Route53/rhea-so.com"
# }

# resource "aws_route53_record" "rhea-so" {
#   zone_id = module.rhea-so.zone_id
#   name    = "ec2.rhea-so.com"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_eip.iac-eip.public_ip]
# }

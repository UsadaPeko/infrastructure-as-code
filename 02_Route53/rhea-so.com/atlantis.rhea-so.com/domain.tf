module "rhea-so"{ source = "../" }

resource "aws_route53_record" "atlantis-rhea-so" {
  zone_id = module.rhea-so.zone_id
  name    = "atlantis.rhea-so.com"
  type    = "A"
  ttl     = "300"
  records = ["52.78.144.248"] // Atlantis EC2 (Terraform을 통해 만들지 않아서 IP를 적어 놓음)
}

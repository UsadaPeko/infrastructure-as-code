module "atlantis-rhea-so" {
  source = "../../aws/route53/record"

  zone_id = var.route53_zone_id
  address = "atlantis.rhea-so.com"
  proxy_target = "52.78.144.248" # Atlantis를 통해 만든 EC2가 아니어서, 직접 EC2 IP를 적어줌
}

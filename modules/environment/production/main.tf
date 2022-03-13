module "atlantis-rhea-so" {
  source = "../../aws/route53/record"

  zone_id = var.route53_zone_id
  name = "atlantis.rhea-so.com"
  target = "52.78.144.248" # Atlantis를 통해 만든 EC2가 아니어서, 직접 EC2 IP를 적어줌
}

module "api-gateway" {
  source = "../../aws/api-gateway"
}

# module "production-vpc" {
#   source = "../../aws/vpc"

#   name = "production-vpc"
# }

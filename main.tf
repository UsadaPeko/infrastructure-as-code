# All services in this repository are created here
# Global Route53 Domain
# module "rhea-so" {
#   source = "./modules/aws/route53/zone"

#   name = "rhea-so.com"
# }

# Environments
module "production" {
	source = "./modules/environment/production"

	route53_zone_id = "module.rhea-so.zone_id"
}

module "staging" {
	source = "./modules/environment/staging"

	route53_zone_id = "module.rhea-so.zone_id"
}

module "dev" {
	source = "./modules/environment/dev"

	route53_zone_id = "module.rhea-so.zone_id"
}

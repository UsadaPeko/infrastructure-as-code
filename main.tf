# All services in this repository are created here
# module "rhea-so" {
#   source = "../../01_Common/01_Route53/01_Zone"

#   name = "rhea-so.com"
# }

# module "atlantis-rhea-so" {
#   source = "../../01_Common/01_Route53/02_Record"

#   zone_id = module.rhea-so.zone_id
#   name = "atlantis.rhea-so.com"
#   target = "52.78.144.248" # Atlantis를 통해 만든 EC2가 아니어서, 직접 EC2 IP를 적어줌
# }

# module "google-rhea-so" {
#   source = "../../01_Common/01_Route53/02_Record"

#   zone_id = module.rhea-so.zone_id
#   name = "google.rhea-so.com"
#   target = "172.217.31.174" # Google Test
# }

module "production" {
	source = "./environment/production"
}

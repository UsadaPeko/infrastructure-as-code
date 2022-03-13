// All services in this repository are created here
module "rhea-so-dev" {
  source = "../../01_Common/01_Route53/01_Zone"

  name = "rhea-so-dev.com"
}

module "atlantis-rhea-so-dev" {
  source = "../../01_Common/01_Route53/02_Record"

  zone_id = module.rhea-so-dev.zone_id
  name = "atlantis.rhea-so-dev.com"
  target = "52.78.144.248"
}

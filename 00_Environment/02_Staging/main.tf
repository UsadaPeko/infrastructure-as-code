// All services in this repository are created here
module "rhea-so-staging" {
  source = "../../01_Common/01_Route53/01_Zone"

  name = "rhea-so-staging.com"
}

module "atlantis-rhea-so-staging" {
  source = "../../01_Common/01_Route53/02_Record"

  zone_id = module.rhea-so-staging.zone_id
  name = "atlantis.rhea-so-staging.com"
  target = "52.78.144.248"
}

// All services in this repository are created here
module "rhea-so" {
  source = "../../01_Common/01_Route53/01_Zone"

  name = "rhea-so.com"
}

module "atlantis-rhea-so" {
  source = "../../01_Common/01_Route53/02_Record"

  zone_id = module.rhea-so.zone_id
  name = "atlantis.rhea-so.com"
  target = "52.78.144.248"
}

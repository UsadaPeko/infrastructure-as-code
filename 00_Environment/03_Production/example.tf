module "test-rhea-so" {
  source = "../../01_Common/01_Route53/02_Record"

  zone_id = module.rhea-so.zone_id
  name = "test.rhea-so.com"
  target = "172.217.31.174" # Google Test
}

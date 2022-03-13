# All services in this repository are created here
module "production" {
	source = "./modules/environment/production"
}

module "staging" {
	source = "./modules/environment/staging"
}

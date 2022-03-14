module "vpc" {
  source = "../../aws/vpc"

  name = var.name
}

module "home-sg" {
  source = "../../aws/security-group"

  name = "home-sg"
  protocol = "tcp"
  port = 22
  ip_v4_from = ["121.161.240.241/32"]
  vpc_id = module.vpc.id
}

module "ec2" {
  source = "../../service/simple-ec2"

  name = "test"
  subnet_id = module.vpc.id
  security_group_ids = [module.home-sg.id]
}

module "domain" {
  source = "../../aws/route53/record"

  zone_id = var.route53_zone_id
  address = "test.rhea-so.com"
  proxy_target = module.ec2.ip
}

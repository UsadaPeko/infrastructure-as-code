resource "aws_route53_zone" "domain" {
  name = var.name
  allow_overwrite = true
}

resource "aws_route53_zone" "domain" {
  name = var.name
  force_destroy = true
}

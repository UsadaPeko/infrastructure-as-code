resource "aws_route53_record" "domain" {
  zone_id = var.zone_id
  name = var.name
  type = var.type
  ttl = var.ttl
  records = [var.target]
  allow_overwrite = true
}

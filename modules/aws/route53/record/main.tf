resource "aws_route53_record" "domain" {
  zone_id = var.zone_id
  name = var.address
  type = var.type
  ttl = var.ttl
  records = [var.proxy_target]
  allow_overwrite = true
}

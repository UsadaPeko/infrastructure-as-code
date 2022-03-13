resource "aws_route53_zone" "rhea-so" {
  name = "rhea-so.com"
  force_destroy = true
}

output zone-id {
  value = aws_route53_zone.rhea-so.zone_id
}

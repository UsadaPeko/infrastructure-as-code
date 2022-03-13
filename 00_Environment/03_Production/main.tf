# All services in this repository are created here
resource "aws_route53_zone" "rhea-so" {
  name = "rhea-so"
  force_destroy = true
}

resource "aws_route53_record" "atlantis-rhea-so" {
  zone_id = aws_route53_zone.rhea-so.zone_id
  name = "atlantis.rhea-so.com"
  type = "A"
  ttl = "300"
  records = ["52.78.144.248"]
}

resource "aws_route53_zone" "rhea-so" {
  name = "rhea-so.com"
  force_destroy = true
}

resource "aws_route53_record" "memo-domain" {
  zone_id = aws_route53_zone.rhea-so.zone_id
  name    = "atlantis.rhea-so.com"
  type    = "A"
  ttl     = "300"
  records = ["52.78.144.248"] // Atlantis EC2 (Terraform을 통해 만들지 않아서 IP를 적어 놓음)
}

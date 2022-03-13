# All services in this repository are created here
resource "aws_route53_zone" "rhea-so" {
  name = "rhea-so.com"
  force_destroy = true
}

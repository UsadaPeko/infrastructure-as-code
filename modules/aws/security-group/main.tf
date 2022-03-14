resource "aws_security_group" "security-group" {
  name = "${var.name}-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port = var.port
    to_port = var.port
    protocol = var.protocol
    cidr_blocks = var.ip_v4_from
    ipv6_cidr_blocks = var.ip_v6_from
  }

  egress {
    from_port = var.port
    to_port = var.port
    protocol = "-1"
    cidr_blocks = var.ip_v4_to
    ipv6_cidr_blocks = var.ip_v6_to
  }

  tags = {
    Name = "${var.name}-security-group"
  }
}

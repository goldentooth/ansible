resource "aws_route53_zone" "subdomain_zone" {
  name = var.subdomain
}

resource "aws_route53_record" "subdomain_ns" {
  zone_id = var.parent_zone_id
  name    = var.subdomain
  type    = "NS"
  ttl     = var.ttl
  records = aws_route53_zone.subdomain_zone.name_servers
}

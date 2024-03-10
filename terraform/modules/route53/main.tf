module "subdomain_zone" {
  for_each       = var.parent_domains
  source         = "../route53-subdomain-zone"
  parent_zone_id = each.value.zone_id
  subdomain      = "${var.cluster_name}.${each.key}"
  ttl            = each.value.ttl
}

locals {
  public_subdomain  = module.subdomain_zone[var.public_domain]
  private_subdomain = module.subdomain_zone[var.private_domain]
}

resource "aws_route53_record" "wildcard_public_domain" {
  zone_id = local.public_subdomain.zone_id
  name    = "*.${local.public_subdomain.fqdn}"
  type    = "A"
  alias {
    name                   = local.public_subdomain.fqdn
    zone_id                = local.public_subdomain.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_domain" {
  zone_id = local.private_subdomain.zone_id
  name    = local.private_subdomain.fqdn
  type    = "A"
  ttl     = "300"
  records = var.private_domain_ips
}

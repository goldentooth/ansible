module "dynamic_dns" {
  source = "./modules/dynamic_dns"

  default_ttl = var.default_ttl
  domain_name = "dynamic-dns.${var.domain_name}"
  zone_id     = var.zone_id
}

module "bare_domain" {
  source = "./modules/bare_domain"

  domain_name = var.domain_name
  zone_id     = var.zone_id
}

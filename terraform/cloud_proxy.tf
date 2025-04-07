module "cloud_proxy" {
  source = "./modules/cloud_proxy"

  distribution_domain_name = "home-proxy.${var.domain_name}"
  origin_domain_name       = "clearbrook.${var.domain_name}"
  zone_id                  = var.zone_id
}

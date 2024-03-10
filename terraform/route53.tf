module "route53" {
  source             = "./modules/route53"
  parent_domains     = var.parent_domains
  cluster_name       = var.cluster_name
  public_domain      = var.public_domain
  private_domain     = var.private_domain
  private_domain_ips = var.private_domain_ips
}

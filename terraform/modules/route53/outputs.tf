output "domains" {
  value = {
    for domain, value in var.parent_domains : domain => {
      parent_zone_id         = value.zone_id
      subdomain_zone_id      = module.subdomain_zone[domain].zone_id
      subdomain_name_servers = module.subdomain_zone[domain].name_servers
      subdomain_fqdn         = module.subdomain_zone[domain].fqdn
    }
  }
}

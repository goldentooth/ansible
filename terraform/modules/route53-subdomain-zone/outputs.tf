output "zone_id" {
  value = aws_route53_zone.subdomain_zone.id
}

output "name_servers" {
  value = aws_route53_zone.subdomain_zone.name_servers
}

output "fqdn" {
  value = aws_route53_zone.subdomain_zone.name
}

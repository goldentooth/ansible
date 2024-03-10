variable "parent_domains" {
  description = "A map of parent domain names to their zone IDs."
  type        = map(map(string))
  default = {
    "parent-domain-1.com" = {
      domain  = "parent-domain-1.com"
      zone_id = "parent_zone_id_1"
      ttl     = "300"
    }
    "parent-domain-2.org" = {
      domain  = "parent-domain-2.org"
      zone_id = "parent_zone_id_2"
      ttl     = "300"
    }
  }
}

variable "cluster_name" {
  description = "The name of our cluster."
  type        = string
}

variable "public_domain" {
  description = "The public domain name for our cluster."
  type        = string
  default     = "my-public-domain.com"
}

variable "private_domain" {
  description = "The private domain for our cluster."
  type        = string
  default     = "my-private-domain.net"
}

variable "private_domain_ips" {
  description = "The IP addresses for the private domain."
  type        = list(string)
  default     = []
}

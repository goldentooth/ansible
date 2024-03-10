variable "cluster_name" {
  description = "The name of our cluster."
  type        = string
  default     = "goldentooth"
}

variable "parent_domains" {
  description = "A map of parent domain names to their info."
  type        = map(map(string))
  default = {
    "darkdell.net" = {
      domain  = "darkdell.net"
      zone_id = "Z10369503CRN6LP4ETMDZ"
      ttl     = "60"
    }
    "hellholt.net" = {
      domain  = "hellholt.net"
      zone_id = "Z024261316ZE4JWVSMJRN"
      ttl     = "60"
    }
  }
}

variable "public_domain" {
  description = "The public domain name for our cluster."
  type        = string
  default     = "darkdell.net"
}

variable "private_domain" {
  description = "The private domain for our cluster."
  type        = string
  default     = "hellholt.net"
}

variable "private_domain_ips" {
  description = "The IP addresses for the private domain."
  type        = list(string)
  default = [
    "10.4.0.10"
  ]
}

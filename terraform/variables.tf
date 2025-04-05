variable "cluster_name" {
  description = "The name of our cluster."
  type        = string
  default     = "goldentooth"
}

variable "domain_name" {
  description = "The domain name."
  type        = string
  default     = "goldentooth.net"
}

variable "default_ttl" {
  description = "The default TTL for records."
  type        = string
  default     = "60"
}

variable "zone_id" {
  description = "The Route53 Zone ID."
  type        = string
  default     = "Z0736727S7ZH91VKK44A"
}

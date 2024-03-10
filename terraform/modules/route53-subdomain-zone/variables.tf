variable "parent_zone_id" {
  description = "The Zone ID of the parent domain."
  type        = string
}

variable "subdomain" {
  description = "The name of the subdomain."
  type        = string
}

variable "ttl" {
  description = "The TTL of the subdomain NS record."
  type        = string
  default     = "300"
}

variable "hcloud_token" {
  sensitive = true
}

variable "cloudflare_api_token" {
  sensitive = true
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
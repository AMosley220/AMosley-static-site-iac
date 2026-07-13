terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }
}

# DNS Records
resource "cloudflare_dns_record" "static_site_record" {
  zone_id         = var.zone_id
  name            = var.domain_name
  ttl             = 1
  type            = "A"
  comment         = "Hetzner VPS public IP"
  content         = var.static_site_ip
  proxied         = true
}
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "digitalocean" {
  token = var.do_token
}

module "vps" {
  source = "./vps"
}

module "dns" {
  source         = "./dns"
  static_site_ip = module.vps.static-site-ip
  zone_id        = var.zone_id
  domain_name    = var.domain_name
}
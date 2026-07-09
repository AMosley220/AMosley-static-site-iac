terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "vps" {
  source = "./vps"
}

module "dns" {
  source = "./dns"

  static_site_ip = module.vps.static_site_server_ip
  domain_name    = var.domain_name
  zone_id        = var.zone_id
}
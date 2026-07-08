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

resource "hcloud_primary_ip" "static_site_ip" {
  name        = "static-site-primary-ip"
  location    = "nbg1"
  type        = "ipv4"
  auto_delete = true
}

resource "hcloud_firewall" "static_site_firewall" {
    name = "static-site-firewall"
    rule {
      direction  = "in"
      protocol   = "tcp"
      port       = "80"
      source_ips = [ 
          "0.0.0.0/0",
          "::/0"
      ]
      description = "TCP In Port 80"
    }

    rule {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = [ 
          "0.0.0.0/0",
          "::/0"
      ]
      description = "TCP In Port 443"
    }

    rule {
      direction   = "out"
      protocol    = "tcp"
      port        = "53"
      destination_ips = [ 
        "0.0.0.0/0",
        "::/0" 
      ]
      description = "TCP Out Port 53"
    }

    rule {
      direction   = "out"
      protocol    = "udp"
      port        = "53"
      destination_ips = [ 
        "0.0.0.0/0",
        "::/0" 
      ]
      description = "UDP Out Port 53"
    }

    rule {
      direction   = "out"
      protocol    = "tcp"
      port        = "443"
      destination_ips = [ 
        "0.0.0.0/0",
        "::/0"
      ]
      description = "TCP Out Port 443"
    }

    rule {
      direction   = "out"
      protocol    = "tcp"
      port        = "80"
      destination_ips = [ 
        "0.0.0.0/0",
        "::/0" 
      ]
      description = "TCP Out Port 80"
    }
}

resource "hcloud_server" "static_site_server" {
  name        = "static-site-server"
  image       = "ubuntu-24.04"
  server_type = "cx23"
  location    = "nbg1"

  public_net {
    ipv4 = hcloud_primary_ip.static_site_ip.id
  }

  firewall_ids = [ hcloud_firewall.static_site_firewall.id ]
}
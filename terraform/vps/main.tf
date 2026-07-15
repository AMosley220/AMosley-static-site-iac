terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_ssh_key" "static-site-server-ssh-key" {
  name       = "Static Site Server Key"
  public_key = file("./static-site-key.pub")
}

resource "digitalocean_droplet" "static-site-server" {
  image  = "ubuntu-26-04-x64"
  name   = "static-site-server"
  region = "nyc2"
  size   = "s-1vcpu-512mb-10gb"
  ssh_keys = [digitalocean_ssh_key.static-site-server-ssh-key.fingerprint]
}

resource "digitalocean_firewall" "static-site-firewall" {
  name = "static-site-only-22-80-and-443"

  droplet_ids = [digitalocean_droplet.static-site-server.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["24.101.212.75/24", "50.239.166.122/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
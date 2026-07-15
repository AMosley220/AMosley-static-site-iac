output "static-site-ip" {
  value = digitalocean_droplet.static-site-server.ipv4_address
}
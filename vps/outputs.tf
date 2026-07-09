output "static_site_server_ip" {
  value = hcloud_primary_ip.static_site_ip.ip_address
}
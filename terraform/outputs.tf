output "app_ext_ip" {
  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
}

output "app_lb_ip" {
  value = "${google_compute_global_address.applbaddress.address}"
}

resource "google_compute_firewall" "firewall_ssh" {
  name = var.name_fw
  network = var.network_name
  allow {
   protocol = var.fw_allow_protocol
    ports = var.fw_allow_ports
  }
  source_ranges = var.source_ranges

  depends_on = [var.modules_depends_on]
}

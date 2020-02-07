resource "google_compute_instance" "app" {
  count = var.count_app
  name         = "${var.name_app}-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = var.network_name
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
 }

  metadata = {
    ssh-keys = "${var.user_name}:${file(var.public_key_path)}"
  }

  connection {
    type  = var.connection_type
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = var.user_name
    agent = false
    private_key = file(var.private_key_path)
  }

  depends_on = [var.modules_depends_on]

  provisioner "file" {
    content     = templatefile("${path.module}/files/puma.service.tmpl", { database_url = var.database_url })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }

}

resource "google_compute_address" "app_ip" {
  name = var.app_ip_name
}

resource "google_compute_firewall" "firewall_puma" {
  name = var.fw_name
  network = var.network_name
  allow {
    protocol = var.fw_allow_protocol
    ports = var.fw_allow_ports
  }
  source_ranges = var.fw_source_ranges
  target_tags = var.tags
}
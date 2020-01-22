terraform {
  # Версия terraform
  required_version = "0.12.18"
}

provider "google" {
  version = "2.15.0"
  project = var.project
  region  = var.region
}

resource "google_compute_project_metadata" "ssh-keys" {
  project = var.project
  count   = 1
  metadata = {
    ssh-keys = <<EOF
    immon4ik${count.index}:${file(var.public_key_path)}
    immon4ik${count.index + 1}:${file(var.public_key_path)}
    EOF
  }
}

resource "google_compute_instance" "app" {
  name         = "${var.name_app}-${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  count        = var.count_app
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    ssh-keys = "immon4ik:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "immon4ik"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

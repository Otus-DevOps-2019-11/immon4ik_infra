variable count_app {
  type    = string
  default = "1"
}

variable name_app {
  type    = string
  default = "reddit-app"
}

variable machine_type {
  type    = string
  default = "g1-small"
}

variable zone {
  type    = string
  default = "europe-west1-b"
}

variable region {
  type    = string
  default = "europe-west-1"
}

variable tags {
  type    = list(string)
  default = ["reddit-app"]
}

variable app_disk_image {
  default = "reddit-base-app-1586091025"
}

variable label_ansible_group {
  type    = string
  default = "app"
}

variable network_name {
  type    = string
  default = "default"
}

variable user_name {
  type    = string
  default = "immon4ik"
}

variable public_key_path {
  type    = string
  default = ""
}

variable private_key_path {
  type    = string
  default = ""
}

variable connection_type {
  type    = string
  default = "ssh"
}

variable database_url {
  type    = string
  default = "127.0.0.1:27017"
}

variable app_ip_name {
  type    = string
  default = "reddit-app-ip"
}

variable fw_name {
  type    = string
  default = "allow-puma-default"
}

variable fw_allow_protocol {
  type    = string
  default = "tcp"
}

variable fw_allow_ports {
  type    = list(string)
  default = ["9292"]
}

variable fw_source_ranges {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable modules_depends_on {
  type    = any
  default = null
}

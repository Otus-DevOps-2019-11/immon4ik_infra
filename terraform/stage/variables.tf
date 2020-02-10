variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}

variable count_app {
  default = "1"
}

variable name_app {
  default = "reddit-app"
}

variable health_check_port {
  description = "Port for healthcheck backend service."
}

variable instance_group_name_port {
  default = "http"
}

variable instance_group_port {
  default = "9292"
}

variable forwarding_rule_port_range {
  default = "80"
}

variable hc_check_interval_sec {
  default = "1"
}

variable hc_timeout_sec {
  default = "1"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-base-ruby-1580729461"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-base-mongodb-1580729751"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

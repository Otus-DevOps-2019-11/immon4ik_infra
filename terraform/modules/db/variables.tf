variable count_app {
  type    = string
  default = "1"
}

variable name_db {
  type    = string
  default = "reddit-db"
}

variable machine_type {
  type    = string
  default = "g1-small"
}

variable zone {
  type    = string
  default = "europe-west1-b"
}

variable tags {
  type    = list(string)
  default = ["reddit-db"]
}

variable db_disk_image {
  default = "reddit-base-mongodb-1586090782"
}

variable label_ansible_group {
  type    = string
  default = "db"
}

variable label_env {
  type        = string
  description = "dev, stage, prod and etc."
  default     = "dev"
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
  default = ""
}

variable app_ip_name {
  type    = string
  default = "reddit-app-ip"
}

variable fw_name {
  type    = string
  default = "allow-mongo-default"
}

variable fw_allow_protocol {
  type    = string
  default = "tcp"
}

variable fw_allow_ports {
  type    = list(string)
  default = ["27017"]
}

variable fw_target_tags {
  type    = list(string)
  default = ["reddit-db"]
}

variable fw_source_tags {
  type    = list(string)
  default = ["reddit-app"]
}

variable modules_depends_on {
  type    = any
  default = null
}

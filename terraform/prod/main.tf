terraform {
  # Версия terraform
  required_version = "~>0.12.8"
}

provider "google" {
  version = "~>2.15"
  project = var.project
  region  = var.region
}

resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "immon4ik:${file(var.public_key_path)}immon4ik1:${file(var.public_key_path)}"
}

module "app" {
  source           = "d:/ForCICD/Repo/Study/immon4ik_infra/terraform/modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  zone             = var.zone
  app_disk_image   = var.app_disk_image
  modules_depends_on = [
    google_compute_project_metadata_item.ssh-keys,
    module.vpc,
    module.db
  ]
}

module "db" {
  source           = "d:/ForCICD/Repo/Study/immon4ik_infra/terraform/modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  zone             = var.zone
  db_disk_image    = var.db_disk_image
  modules_depends_on = [
    google_compute_project_metadata_item.ssh-keys
  ]
}

module "vpc" {
  source           = "d:/ForCICD/Repo/Study/immon4ik_infra/terraform/modules/vpc"
  source_ranges    = var.source_ranges
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  modules_depends_on = [
    google_compute_project_metadata_item.ssh-keys
  ]
}

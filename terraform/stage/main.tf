terraform {
  # Версия terraform
  required_version = "~>0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "~>2.15"
  project = var.project
  region  = var.region
}

module "app" {
  source = "../modules/app"
  #source           = "E:/_maintenance/ForCICD/Repo/Study/immon4ik_infra/terraform/modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  zone             = var.zone
  region           = var.region
  app_disk_image   = var.app_disk_image
  label_env        = var.label_env
  database_url     = "${module.db.db_internal_ip}:27017"
  modules_depends_on = [
    module.vpc,
    module.db
  ]
}

module "db" {
  source = "../modules/db"
  #source           = "E:/_maintenance/ForCICD/Repo/Study/immon4ik_infra/terraform/modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  zone             = var.zone
  db_disk_image    = var.db_disk_image
  label_env        = var.label_env
}

module "vpc" {
  source = "../modules/vpc"
  #source           = "E:/_maintenance/ForCICD/Repo/Study/immon4ik_infra/terraform/modules/vpc"
  source_ranges    = var.source_ranges
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
}

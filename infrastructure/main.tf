terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true

  //subscription_id   = "66c330d1-bac6-41ca-9de1-095067a89dc6"
  //tenant_id         = "4565bb37-9773-4d2e-80b6-398babdc2a33"
  //client_id         = "<service_principal_appid>"
  //client_secret     = "<service_principal_password>"
}

resource "random_string" "random_suffix" {
  length  = 3
  special = false
  upper   = false
}

locals {
  unique_person_name = "${var.person_name}${random_string.random_suffix.result}"
}

module "storage" {
  source   = "./modules/storage"
  location = var.location
  rg_name  = var.rg_name
  unique_person_name = local.unique_person_name
}

module "apps" {
  source   = "./modules/apps"
  location = var.location
  rg_name  = var.rg_name
  unique_person_name = local.unique_person_name
}

module "database" {
  source   = "./modules/database"
  location = var.location
  rg_name  = var.rg_name
  unique_person_name = local.unique_person_name
  db_username = var.db_username
  db_password = var.db_password
}

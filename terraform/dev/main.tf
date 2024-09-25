locals {
  config = yamldecode(file("../_bauli_commercial.yml"))

  project_id = local.config.project_id_dev
  location   = local.config.location

  landing_bucket_name          = local.config.landing_bucket.name
  landing_bucket_location      = local.config.landing_bucket.location
  landing_bucket_storage_class = local.config.landing_bucket.storage_class

  bigquery_datasets = {
    for dataset in local.config.bigquery :
    dataset.dataset_name => {
      location = dataset.dataset_location
      schemas  = lookup(dataset, "schemas", null)
    }
  }

  # TODO: implementare una lista di sa e i loro permessi?
  sa_private_key_type   = local.config.service_account.private_key_type
  sa_key_algorithm      = local.config.service_account.key_algorithm
  service_account_roles = local.config.service_account.roles

  enabled_apis = local.config.enabled_apis

  terraform_state_bucket_name     = local.config.state_bucket_terraform.name
  terraform_state_bucket_location = local.config.state_bucket_terraform.location
  terraform_state_bucket_class    = local.config.state_bucket_terraform.storage_class

  dataform_repository_name = local.config.dataform.repository_name
  dataform_display_name    = local.config.dataform.display_name
  dataform_region          = local.config.dataform.region

}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "bli-bi-commerciale-test-001-terraform-state-bucket" # This cannot be dynamically computed
    prefix = "terraform/state"
  }
}

provider "google" {
  project = local.project_id
  region  = local.location
}

terraform {
  required_version = ">= 1.6.0"
  required_providers { google = { source = "hashicorp/google", version = "~> 6.0" } }
}
provider "google" {
  project = var.project_id
  region  = var.region
}
module "azure_entra_id" {
  source     = "../../modules/azure_entra_id"
  client_id  = var.entra_client_id
  tenant_id  = var.entra_tenant_id
  issuer_uri = var.entra_issuer_uri
}
module "gcp_workload_id" {
  source                        = "../../modules/gcp_workload_id"
  project_id                    = var.project_id
  pool_id                       = var.pool_id
  provider_id                   = var.provider_id
  service_account_id            = var.service_account_id
  storage_bucket_name           = var.storage_bucket_name
  entra_client_id               = var.entra_client_id
  entra_tenant_id               = var.entra_tenant_id
  entra_subject                 = var.entra_subject
  access_token_lifetime_seconds = var.access_token_lifetime_seconds
}
output "workload_identity_provider_name" { value = module.gcp_workload_id.provider_name }
output "service_account_email" { value = module.gcp_workload_id.service_account_email }

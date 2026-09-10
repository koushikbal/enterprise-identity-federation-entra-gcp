variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "pool_id" { type = string }
variable "provider_id" { type = string }
variable "service_account_id" { type = string }
variable "storage_bucket_name" { type = string }
variable "entra_client_id" { type = string }
variable "entra_tenant_id" { type = string }
variable "entra_subject" { type = string }
variable "entra_issuer_uri" {
  type    = string
  default = "https://login.microsoftonline.com"
}
variable "access_token_lifetime_seconds" {
  type    = number
  default = 900
}

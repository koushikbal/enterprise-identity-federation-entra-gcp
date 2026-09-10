resource "google_iam_workload_identity_pool" "this" {
  workload_identity_pool_id = var.pool_id
  display_name              = "Entra production federation"
  project                   = var.project_id
}
resource "google_iam_workload_identity_pool_provider" "entra" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.this.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "Microsoft Entra OIDC"
  oidc {
    issuer_uri        = "https://login.microsoftonline.com/${var.entra_tenant_id}/v2.0"
    allowed_audiences = [var.entra_client_id]
  }
  attribute_mapping   = { "google.subject" = "assertion.sub", "attribute.aud" = "assertion.aud", "attribute.iss" = "assertion.iss", "attribute.tid" = "assertion.tid" }
  attribute_condition = "assertion.tid == '${var.entra_tenant_id}' && assertion.aud == '${var.entra_client_id}'"
}
resource "google_service_account" "this" {
  account_id   = var.service_account_id
  project      = var.project_id
  display_name = "Keyless Entra storage reader"
}
resource "google_storage_bucket_iam_member" "reader" {
  bucket = var.storage_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.this.email}"
}
resource "google_service_account_iam_member" "federated" {
  service_account_id = google_service_account.this.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.sub/${var.entra_subject}"
}
output "provider_name" { value = google_iam_workload_identity_pool_provider.entra.name }
output "service_account_email" { value = google_service_account.this.email }

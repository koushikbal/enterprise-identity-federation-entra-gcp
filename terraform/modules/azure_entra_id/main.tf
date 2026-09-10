locals { issuer = "${var.issuer_uri}/${var.tenant_id}/v2.0" }
output "client_id" { value = var.client_id }
output "tenant_id" { value = var.tenant_id }
output "issuer" { value = local.issuer }

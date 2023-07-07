output "hvn_id" {
  value       = local.hvn_id
  description = "ID of the HashiCorp Virtual Network (HVN)."
}

output "vault_cluster_id" {
  value       = local.cluster_id
  description = "ID of the HCP Vault cluster."
}

output "vault_private_endpoint_url" {
  value       = hcp_vault_cluster.this.vault_private_endpoint_url
  description = "Private endpoint of the HCP Vault cluster."
}

output "vault_public_endpoint_url" {
  value       = var.public_endpoint ? hcp_vault_cluster.this.vault_public_endpoint_url : null
  description = "Public endpoint of the HCP Vault cluster."
}

output "vault_admin_token" {
  value       = hcp_vault_cluster_admin_token.admin.token
  description = "Admin token for the HCP Vault cluster."
  sensitive   = true
}

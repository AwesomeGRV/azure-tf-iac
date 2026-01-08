output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_tenant_id" {
  description = "Tenant ID of the Key Vault"
  value       = azurerm_key_vault.main.tenant_id
}

output "managed_identity_id" {
  description = "ID of the managed identity"
  value       = azurerm_user_assigned_identity.main.id
}

output "managed_identity_name" {
  description = "Name of the managed identity"
  value       = azurerm_user_assigned_identity.main.name
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity"
  value       = azurerm_user_assigned_identity.main.principal_id
}

output "managed_identity_client_id" {
  description = "Client ID of the managed identity"
  value       = azurerm_user_assigned_identity.main.client_id
}

output "key_vault_secret_id" {
  description = "ID of the example Key Vault secret"
  value       = azurerm_key_vault_secret.example.id
}

output "key_vault_secret_name" {
  description = "Name of the example Key Vault secret"
  value       = azurerm_key_vault_secret.example.name
}

output "key_vault_key_id" {
  description = "ID of the example Key Vault key"
  value       = azurerm_key_vault_key.example.id
}

output "key_vault_key_name" {
  description = "Name of the example Key Vault key"
  value       = azurerm_key_vault_key.example.name
}

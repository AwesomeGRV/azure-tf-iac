output "cognitive_services_account_name" {
  description = "Cognitive Services account name"
  value       = azurerm_cognitive_account.main.name
}

output "cognitive_services_account_id" {
  description = "Cognitive Services account ID"
  value       = azurerm_cognitive_account.main.id
}

output "cognitive_services_endpoint" {
  description = "Cognitive Services endpoint"
  value       = azurerm_cognitive_account.main.endpoint
}

output "cognitive_services_primary_key" {
  description = "Cognitive Services primary key"
  value       = azurerm_cognitive_account.main.primary_access_key
  sensitive   = true
}

output "notification_hub_namespace_name" {
  description = "Notification Hub namespace name"
  value       = azurerm_notification_hub_namespace.main.name
}

output "notification_hub_name" {
  description = "Notification Hub name"
  value       = azurerm_notification_hub.main.name
}

output "notification_hub_connection_string" {
  description = "Notification Hub connection string"
  value       = azurerm_notification_hub.main.primary_connection_string
  sensitive   = true
}

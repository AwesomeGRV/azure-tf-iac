output "data_factory_name" {
  description = "Data Factory name"
  value       = azurerm_data_factory.main.name
}

output "data_factory_id" {
  description = "Data Factory resource ID"
  value       = azurerm_data_factory.main.id
}

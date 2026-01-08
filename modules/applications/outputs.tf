output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_app_service_plan.main.name
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_app_service_plan.main.id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_app_service.main.name
}

output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_app_service.main.id
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_app_service.main.default_hostname
}

output "app_service_outbound_ip_addresses" {
  description = "Outbound IP addresses of the App Service"
  value       = azurerm_app_service.main.outbound_ip_addresses
}

output "app_service_identity_principal_id" {
  description = "Principal ID of the App Service identity"
  value       = azurerm_app_service.main.identity[0].principal_id
}

output "function_app_service_plan_name" {
  description = "Name of the Function App Service Plan"
  value       = azurerm_service_plan.function.name
}

output "function_app_service_plan_id" {
  description = "ID of the Function App Service Plan"
  value       = azurerm_service_plan.function.id
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = azurerm_linux_function_app.main.name
}

output "function_app_id" {
  description = "ID of the Function App"
  value       = azurerm_linux_function_app.main.id
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = azurerm_linux_function_app.main.default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP addresses of the Function App"
  value       = azurerm_linux_function_app.main.outbound_ip_addresses
}

output "function_app_identity_principal_id" {
  description = "Principal ID of the Function App identity"
  value       = azurerm_linux_function_app.main.identity[0].principal_id
}

output "private_endpoint_app_service_id" {
  description = "ID of the App Service private endpoint"
  value       = azurerm_private_endpoint.app_service.id
}

output "private_endpoint_function_app_id" {
  description = "ID of the Function App private endpoint"
  value       = azurerm_private_endpoint.function_app.id
}

output "private_dns_zone_webapps_id" {
  description = "ID of the web apps private DNS zone"
  value       = azurerm_private_dns_zone.webapps.id
}

output "app_service_site_credentials" {
  description = "Site credentials for the App Service"
  value       = azurerm_app_service.main.site_credentials
  sensitive   = true
}

output "function_app_site_credentials" {
  description = "Site credentials for the Function App"
  value       = azurerm_linux_function_app.main.site_credentials
  sensitive   = true
}

output "api_management_name" {
  description = "API Management service name"
  value       = azurerm_api_management.main.name
}

output "api_management_gateway_url" {
  description = "API Management gateway URL"
  value       = azurerm_api_management.main.gateway_url
}

output "api_management_portal_url" {
  description = "API Management developer portal URL"
  value       = azurerm_api_management.main.developer_portal_url
}

output "api_management_id" {
  description = "API Management resource ID"
  value       = azurerm_api_management.main.id
}

output "api_management_identity_principal_id" {
  description = "API Management identity principal ID"
  value       = azurerm_api_management.main.identity[0].principal_id
}

output "apim_private_endpoint_id" {
  description = "API Management private endpoint ID"
  value       = azurerm_private_endpoint.apim.id
}

output "apim_private_dns_zone_id" {
  description = "API Management private DNS zone ID"
  value       = azurerm_private_dns_zone.apim.id
}

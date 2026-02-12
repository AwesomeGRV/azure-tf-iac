# API Management Outputs
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

# CDN Outputs
output "cdn_profile_name" {
  description = "CDN profile name"
  value       = azurerm_cdn_profile.main.name
}

output "cdn_endpoint_name" {
  description = "CDN endpoint name"
  value       = azurerm_cdn_endpoint.main.name
}

output "cdn_endpoint_host_name" {
  description = "CDN endpoint host name"
  value       = azurerm_cdn_endpoint.main.host_name
}

output "cdn_profile_id" {
  description = "CDN profile resource ID"
  value       = azurerm_cdn_profile.main.id
}

# Front Door Outputs
output "front_door_profile_name" {
  description = "Front Door profile name"
  value       = azurerm_cdn_frontdoor_profile.main.name
}

output "front_door_endpoint_name" {
  description = "Front Door endpoint name"
  value       = azurerm_cdn_frontdoor_endpoint.main.name
}

output "front_door_endpoint_host_name" {
  description = "Front Door endpoint host name"
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
}

output "front_door_profile_id" {
  description = "Front Door profile resource ID"
  value       = azurerm_cdn_frontdoor_profile.main.id
}

output "front_door_waf_policy_id" {
  description = "Front Door WAF policy ID"
  value       = var.enable_waf ? azurerm_cdn_frontdoor_firewall_policy.main[0].id : null
}

# Notification Hubs Outputs
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

# Cognitive Services Outputs
output "cognitive_services_account_name" {
  description = "Cognitive Services account name"
  value       = var.enable_cognitive_services ? azurerm_cognitive_account.main[0].name : null
}

output "cognitive_services_account_id" {
  description = "Cognitive Services account ID"
  value       = var.enable_cognitive_services ? azurerm_cognitive_account.main[0].id : null
}

output "cognitive_services_endpoint" {
  description = "Cognitive Services endpoint"
  value       = var.enable_cognitive_services ? azurerm_cognitive_account.main[0].endpoint : null
}

output "cognitive_services_primary_key" {
  description = "Cognitive Services primary key"
  value       = var.enable_cognitive_services ? azurerm_cognitive_account.main[0].primary_access_key : null
  sensitive   = true
}

# Data Factory Outputs
output "data_factory_name" {
  description = "Data Factory name"
  value       = var.enable_data_factory ? azurerm_data_factory.main[0].name : null
}

output "data_factory_id" {
  description = "Data Factory resource ID"
  value       = var.enable_data_factory ? azurerm_data_factory.main[0].id : null
}

# Private Endpoints Outputs
output "apim_private_endpoint_id" {
  description = "API Management private endpoint ID"
  value       = azurerm_private_endpoint.apim.id
}

# DNS Zones Outputs
output "apim_private_dns_zone_id" {
  description = "API Management private DNS zone ID"
  value       = azurerm_private_dns_zone.apim.id
}

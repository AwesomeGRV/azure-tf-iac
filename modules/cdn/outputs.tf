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

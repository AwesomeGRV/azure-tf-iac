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

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
  description = "Site credentials for Function App"
  value       = azurerm_linux_function_app.main.site_credentials
  sensitive   = true
}

output "service_bus_namespace_name" {
  description = "Name of Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.name
}

output "service_bus_namespace_id" {
  description = "ID of Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.id
}

output "service_bus_primary_connection_string" {
  description = "Primary connection string of Service Bus namespace"
  value       = azurerm_servicebus_namespace_authorization_rule.main.primary_connection_string
  sensitive   = true
}

output "service_bus_secondary_connection_string" {
  description = "Secondary connection string of Service Bus namespace"
  value       = azurerm_servicebus_namespace_authorization_rule.main.secondary_connection_string
  sensitive   = true
}

output "service_bus_queue_name" {
  description = "Name of Service Bus queue"
  value       = azurerm_servicebus_queue.main.name
}

output "service_bus_queue_id" {
  description = "ID of Service Bus queue"
  value       = azurerm_servicebus_queue.main.id
}

output "service_bus_topic_name" {
  description = "Name of Service Bus topic"
  value       = azurerm_servicebus_topic.main.name
}

output "service_bus_topic_id" {
  description = "ID of Service Bus topic"
  value       = azurerm_servicebus_topic.main.id
}

output "event_grid_storage_subscription_id" {
  description = "ID of Event Grid storage subscription"
  value       = azurerm_eventgrid_system_topic_event_subscription.storage.id
}

output "event_grid_resource_groups_subscription_id" {
  description = "ID of Event Grid resource groups subscription"
  value       = azurerm_eventgrid_system_topic_event_subscription.resource_groups.id
}

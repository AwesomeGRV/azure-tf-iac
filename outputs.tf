output "resource_group_name" {
  description = "Name of resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = var.location
}

output "vnet_id" {
  description = "ID of virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of virtual network"
  value       = module.networking.vnet_name
}

output "aks_cluster_name" {
  description = "Name of AKS cluster"
  value       = module.compute.aks_cluster_name
}

output "aks_cluster_id" {
  description = "ID of AKS cluster"
  value       = module.compute.aks_cluster_id
}

output "aks_kube_config" {
  description = "Kubeconfig for AKS cluster"
  value       = module.compute.aks_kube_config
  sensitive   = true
}

# Storage Outputs
output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.storage_account_name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.storage_account_id
}

output "storage_account_primary_key" {
  description = "Primary key of the storage account"
  value       = module.storage_account.storage_account_primary_key
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = module.storage_account.storage_account_primary_blob_endpoint
}

# MySQL Outputs
output "mysql_server_name" {
  description = "Name of the MySQL server"
  value       = module.mysql.mysql_server_name
}

output "mysql_server_fqdn" {
  description = "Fully qualified domain name of the MySQL server"
  value       = module.mysql.mysql_server_fqdn
}

output "mysql_administrator_login" {
  description = "MySQL administrator login"
  value       = module.mysql.mysql_administrator_login
}

output "mysql_administrator_password" {
  description = "MySQL administrator password"
  value       = module.mysql.mysql_administrator_password
  sensitive   = true
}

output "mysql_connection_string" {
  description = "MySQL connection string"
  value       = module.mysql.mysql_connection_string
  sensitive   = true
}

# Redis Outputs
output "redis_cache_name" {
  description = "Name of the Redis Cache"
  value       = module.redis.redis_cache_name
}

output "redis_cache_connection_string" {
  description = "Connection string of the Redis Cache"
  value       = module.redis.redis_cache_connection_string
  sensitive   = true
}

output "redis_cache_primary_key" {
  description = "Primary key of the Redis Cache"
  value       = module.redis.redis_cache_primary_key
  sensitive   = true
}

output "redis_cache_hostname" {
  description = "Hostname of the Redis Cache"
  value       = module.redis.redis_cache_hostname
}

# SQL Database Outputs
output "sql_server_name" {
  description = "Name of the SQL server"
  value       = module.sql_database.sql_server_name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL server"
  value       = module.sql_database.sql_server_fqdn
}

output "sql_administrator_login" {
  description = "SQL administrator login"
  value       = module.sql_database.sql_administrator_login
}

output "sql_administrator_password" {
  description = "SQL administrator password"
  value       = module.sql_database.sql_administrator_password
  sensitive   = true
}

output "sql_connection_string" {
  description = "SQL connection string"
  value       = module.sql_database.sql_connection_string
  sensitive   = true
}

# Security Outputs
output "key_vault_name" {
  description = "Name of Key Vault"
  value       = module.security.key_vault_name
}

output "key_vault_id" {
  description = "ID of Key Vault"
  value       = module.security.key_vault_id
}

output "key_vault_uri" {
  description = "URI of Key Vault"
  value       = module.security.key_vault_uri
}

# Application Outputs
output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = module.applications.app_service_plan_name
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = module.applications.app_service_name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = module.applications.app_service_default_hostname
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = module.applications.function_app_name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = module.applications.function_app_default_hostname
}

output "vm_names" {
  description = "Names of the virtual machines"
  value       = module.compute.vm_names
}

output "vm_public_ips" {
  description = "Public IP addresses of the virtual machines"
  value       = module.compute.vm_public_ips
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "ID of Log Analytics workspace"
  value       = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_id : null
}

output "log_analytics_workspace_name" {
  description = "Name of Log Analytics workspace"
  value       = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_name : null
}

output "application_insights_name" {
  description = "Name of Application Insights"
  value       = var.enable_monitoring ? module.monitoring[0].application_insights_name : null
}

output "application_insights_app_id" {
  description = "App ID of Application Insights"
  value       = var.enable_monitoring ? module.monitoring[0].application_insights_app_id : null
}

output "naming_suffix" {
  description = "Generated naming suffix for resources"
  value       = local.naming_suffix
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry"
  value       = module.compute.container_registry_name
}

output "container_registry_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = module.compute.container_registry_login_server
}

output "container_registry_admin_username" {
  description = "Admin username of the Azure Container Registry"
  value       = module.compute.container_registry_admin_username
}

output "container_registry_admin_password" {
  description = "Admin password of the Azure Container Registry"
  value       = module.compute.container_registry_admin_password
  sensitive   = true
}

output "application_gateway_name" {
  description = "Name of Application Gateway"
  value       = module.networking.application_gateway_name
}

output "application_gateway_public_ip" {
  description = "Public IP address of Application Gateway"
  value       = module.networking.application_gateway_public_ip
}

output "service_bus_namespace_name" {
  description = "Name of Service Bus namespace"
  value       = module.applications.service_bus_namespace_name
}

output "service_bus_primary_connection_string" {
  description = "Primary connection string of Service Bus namespace"
  value       = module.applications.service_bus_primary_connection_string
  sensitive   = true
}

output "service_bus_queue_name" {
  description = "Name of Service Bus queue"
  value       = module.applications.service_bus_queue_name
}

output "service_bus_topic_name" {
  description = "Name of Service Bus topic"
  value       = module.applications.service_bus_topic_name
}

output "event_grid_storage_subscription_id" {
  description = "ID of Event Grid storage subscription"
  value       = module.applications.event_grid_storage_subscription_id
}

output "event_grid_resource_groups_subscription_id" {
  description = "ID of Event Grid resource groups subscription"
  value       = module.applications.event_grid_resource_groups_subscription_id
}

# Additional Services Outputs
output "api_management_name" {
  description = "API Management service name"
  value       = module.api_management.api_management_name
}

output "api_management_gateway_url" {
  description = "API Management gateway URL"
  value       = module.api_management.api_management_gateway_url
}

output "api_management_portal_url" {
  description = "API Management developer portal URL"
  value       = module.api_management.api_management_portal_url
}

output "api_management_id" {
  description = "API Management resource ID"
  value       = module.api_management.api_management_id
}

output "cdn_profile_name" {
  description = "CDN profile name"
  value       = module.cdn.cdn_profile_name
}

output "cdn_endpoint_name" {
  description = "CDN endpoint name"
  value       = module.cdn.cdn_endpoint_name
}

output "cdn_endpoint_host_name" {
  description = "CDN endpoint host name"
  value       = module.cdn.cdn_endpoint_host_name
}

output "front_door_profile_name" {
  description = "Front Door profile name"
  value       = module.front_door.front_door_profile_name
}

output "front_door_endpoint_name" {
  description = "Front Door endpoint name"
  value       = module.front_door.front_door_endpoint_name
}

output "front_door_endpoint_host_name" {
  description = "Front Door endpoint host name"
  value       = module.front_door.front_door_endpoint_host_name
}

output "front_door_waf_policy_id" {
  description = "Front Door WAF policy ID"
  value       = module.front_door.front_door_waf_policy_id
}

output "notification_hub_namespace_name" {
  description = "Notification Hub namespace name"
  value       = module.notification_hubs.notification_hub_namespace_name
}

output "notification_hub_name" {
  description = "Notification Hub name"
  value       = module.notification_hubs.notification_hub_name
}

output "notification_hub_connection_string" {
  description = "Notification Hub connection string"
  value       = module.notification_hubs.notification_hub_connection_string
  sensitive   = true
}

output "cognitive_services_account_name" {
  description = "Cognitive Services account name"
  value       = var.enable_cognitive_services ? module.cognitive_services[0].cognitive_services_account_name : null
}

output "cognitive_services_account_id" {
  description = "Cognitive Services account ID"
  value       = var.enable_cognitive_services ? module.cognitive_services[0].cognitive_services_account_id : null
}

output "cognitive_services_endpoint" {
  description = "Cognitive Services endpoint"
  value       = var.enable_cognitive_services ? module.cognitive_services[0].cognitive_services_endpoint : null
}

output "cognitive_services_primary_key" {
  description = "Cognitive Services primary key"
  value       = var.enable_cognitive_services ? module.cognitive_services[0].cognitive_services_primary_key : null
  sensitive   = true
}

output "data_factory_name" {
  description = "Data Factory name"
  value       = var.enable_data_factory ? module.data_factory[0].data_factory_name : null
}

output "data_factory_id" {
  description = "Data Factory resource ID"
  value       = var.enable_data_factory ? module.data_factory[0].data_factory_id : null
}

output "apim_private_endpoint_id" {
  description = "API Management private endpoint ID"
  value       = module.api_management.apim_private_endpoint_id
}

output "apim_private_dns_zone_id" {
  description = "API Management private DNS zone ID"
  value       = module.api_management.apim_private_dns_zone_id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = var.location
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.compute.aks_cluster_name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.compute.aks_cluster_id
}

output "aks_kube_config" {
  description = "Kubeconfig for the AKS cluster"
  value       = module.compute.aks_kube_config
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage.storage_account_id
}

output "storage_account_primary_key" {
  description = "Primary key of the storage account"
  value       = module.storage.storage_account_primary_key
  sensitive   = true
}

output "mysql_server_name" {
  description = "Name of the MySQL server"
  value       = module.storage.mysql_server_name
}

output "mysql_server_fqdn" {
  description = "Fully qualified domain name of the MySQL server"
  value       = module.storage.mysql_server_fqdn
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.security.key_vault_name
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.security.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.security.key_vault_uri
}

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

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_id : null
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_name : null
}

output "application_insights_name" {
  description = "Name of the Application Insights"
  value       = var.enable_monitoring ? module.monitoring[0].application_insights_name : null
}

output "application_insights_app_id" {
  description = "App ID of the Application Insights"
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

output "sql_server_name" {
  description = "Name of the SQL server"
  value       = module.storage.sql_server_name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL server"
  value       = module.storage.sql_server_fqdn
}

output "sql_database_name" {
  description = "Name of the SQL database"
  value       = module.storage.sql_database_name
}

output "sql_administrator_login" {
  description = "SQL administrator login"
  value       = module.storage.sql_administrator_login
}

output "sql_administrator_password" {
  description = "SQL administrator password"
  value       = module.storage.sql_administrator_password
  sensitive   = true
}

output "sql_connection_string" {
  description = "SQL connection string"
  value       = module.storage.sql_connection_string
  sensitive   = true
}

output "redis_cache_name" {
  description = "Name of the Redis Cache"
  value       = module.storage.redis_cache_name
}

output "redis_cache_connection_string" {
  description = "Connection string of the Redis Cache"
  value       = module.storage.redis_cache_connection_string
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

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_secondary_shared_key" {
  description = "Secondary shared key of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.secondary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_customer_id" {
  description = "Customer ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

output "application_insights_name" {
  description = "Name of the Application Insights"
  value       = azurerm_application_insights.main.name
}

output "application_insights_id" {
  description = "ID of the Application Insights"
  value       = azurerm_application_insights.main.id
}

output "application_insights_app_id" {
  description = "App ID of the Application Insights"
  value       = azurerm_application_insights.main.app_id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_api_key" {
  description = "API key of the Application Insights"
  value       = azurerm_application_insights.main.api_key
  sensitive   = true
}

output "action_group_id" {
  description = "ID of the action group"
  value       = azurerm_monitor_action_group.main.id
}

output "action_group_name" {
  description = "Name of the action group"
  value       = azurerm_monitor_action_group.main.name
}

output "metric_alert_ids" {
  description = "IDs of the metric alerts"
  value = {
    cpu_high               = azurerm_monitor_metric_alert.cpu_high.id
    memory_high            = azurerm_monitor_metric_alert.memory_high.id
    disk_high              = azurerm_monitor_metric_alert.disk_high.id
    storage_transactions   = azurerm_monitor_metric_alert.storage_transactions.id
    mysql_connections      = azurerm_monitor_metric_alert.mysql_connections.id
    app_service_response   = azurerm_monitor_metric_alert.app_service_response_time.id
    function_app_execution = azurerm_monitor_metric_alert.function_app_execution_count.id
  }
}

output "activity_log_alert_id" {
  description = "ID of the activity log alert"
  value       = azurerm_monitor_activity_log_alert.resource_group_delete.id
}

output "saved_search_ids" {
  description = "IDs of the saved searches"
  value = {
    error_logs       = azurerm_monitor_log_analytics_saved_search.error_logs.id
    failed_requests  = azurerm_monitor_log_analytics_saved_search.failed_requests.id
    security_events  = azurerm_monitor_log_analytics_saved_search.security_events.id
  }
}

output "autoscale_setting_id" {
  description = "ID of the autoscale setting"
  value       = azurerm_monitor_autoscale_setting.main.id
}

output "log_analytics_workspace_portal_url" {
  description = "Portal URL of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.portal_url
}

output "application_insights_portal_url" {
  description = "Portal URL of the Application Insights"
  value       = azurerm_application_insights.main.portal_url
}

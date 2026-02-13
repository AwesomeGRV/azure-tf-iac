# Azure CDN Profile
resource "azurerm_cdn_profile" "main" {
  name                = "cdn-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.cdn_sku_name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# CDN Endpoint
resource "azurerm_cdn_endpoint" "main" {
  name                = "cdn-endpoint-${var.naming_suffix}"
  profile_name        = azurerm_cdn_profile.main.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  origin {
    name      = "app-service-origin"
    host_name = var.app_service_hostname != "" ? var.app_service_hostname : "app-${var.naming_suffix}.azurewebsites.net"
    http_port = 80
    https_port = 443
  }

  # Optimization settings
  optimization_type = "GeneralWebDelivery"

  # Compression settings
  content_types_to_compress = [
    "application/javascript",
    "application/json",
    "application/xml",
    "text/css",
    "text/html",
    "text/plain",
    "text/xml"
  ]

  is_http_allowed        = true
  is_https_allowed       = true
  query_string_caching_behavior = "IgnoreQueryString"
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "cdn" {
  count                      = var.log_analytics_id != null ? 1 : 0
  name                       = "cdn-diag"
  target_resource_id         = azurerm_cdn_profile.main.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "AzureCDNAccessLog"
  }

  metric {
    category = "AllMetrics"
  }
}

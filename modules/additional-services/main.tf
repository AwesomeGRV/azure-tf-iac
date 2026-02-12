data "azurerm_client_config" "current" {}

# API Management Service
resource "azurerm_api_management" "main" {
  name                = "apim-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku_name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  # Enable API Management gateway
  gateway_url {
    gateway_regions = ["${var.location}"]
  }

  # Enable developer portal
  developer_portal_url {
    developer_portal_regions = ["${var.location}"]
  }

  # Security settings
  secure_by_default = true

  # Policy settings
  policy {
    xml_content = <<XML
<policies>
  <inbound>
    <base />
    <rate-limit-by-key calls="100" renewal-period="60" counter-key="@(context.Request.IpAddress)" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
</policies>
XML
  }

  # Product configuration
  product {
    name             = "Unlimited"
    description      = "Unlimited access to all APIs"
    approval_required = false
    subscription_required = false
    published        = true
  }

  # API configuration
  api {
    name                = "Sample API"
    display_name        = "Sample API"
    description         = "Sample API for demonstration"
    path                = "sample"
    protocols           = ["https"]
    service_url         = "https://example.com/api"
    
    operation {
      name           = "GET-Data"
      display_name   = "Get Data"
      method         = "GET"
      url_template   = "/data"
      description    = "Get sample data"
    }
  }
}

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
    host_name = "app-${var.naming_suffix}.azurewebsites.net"
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

# Azure Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "afd-${var.naming_suffix}"
  resource_group_name = var.resource_group_name
  location            = "Global"
  sku_name            = var.front_door_sku_name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                    = "afd-endpoint-${var.naming_suffix}"
  profile_name            = azurerm_cdn_frontdoor_profile.main.name
  enabled                 = true
}

# Front Door Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                = "afd-origin-group-${var.naming_suffix}"
  profile_name        = azurerm_cdn_frontdoor_profile.main.name
  
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
    additional_latency_threshold_ms = 50
  }

  health_probe {
    interval_in_seconds = 30
    path               = "/health"
    protocol           = "Https"
    request_type       = "HEAD"
  }

  session_affinity_enabled = false
}

# Front Door Origin
resource "azurerm_cdn_frontdoor_origin" "app_service" {
  name                     = "app-service-origin"
  profile_name             = azurerm_cdn_frontdoor_profile.main.name
  origin_group_name        = azurerm_cdn_frontdoor_origin_group.main.name
  enabled                  = true
  host_name                = "app-${var.naming_suffix}.azurewebsites.net"
  http_port                = 80
  https_port               = 443
  origin_host_header       = "app-${var.naming_suffix}.azurewebsites.net"
  priority                 = 1
  weight                   = 1000
}

# Front Door Route
resource "azurerm_cdn_frontdoor_route" "main" {
  name                          = "afd-route-${var.naming_suffix}"
  profile_name                  = azurerm_cdn_frontdoor_profile.main.name
  endpoint_name                 = azurerm_cdn_frontdoor_endpoint.main.name
  origin_group_name             = azurerm_cdn_frontdoor_origin_group.main.name
  origin_names                  = [azurerm_cdn_frontdoor_origin.app_service.name]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = true
  enabled                       = true
}

# Front Door WAF Policy (if enabled)
resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  count               = var.enable_waf ? 1 : 0
  name                = "afd-waf-${var.naming_suffix}"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags

  # Custom rules
  custom_rule {
    name     = "BlockSQLInjection"
    enabled  = true
    priority = 1
    action   = "Block"
    
    match_condition {
      match_variable = "PostArgs"
      operator      = "Contains"
      negation_condition = false
      match_values  = ["'", "--", "/*", "*/", "xp_", "sp_"]
    }

    match_condition {
      match_variable = "QueryString"
      operator      = "Contains"
      negation_condition = false
      match_values  = ["'", "--", "/*", "*/", "xp_", "sp_"]
    }
  }

  custom_rule {
    name     = "RateLimit"
    enabled  = true
    priority = 2
    action   = "Block"
    
    match_condition {
      match_variable = "RemoteAddr"
      operator      = "Any"
      negation_condition = false
    }

    rate_limit_duration_in_minutes = 1
    rate_limit_threshold          = 100
  }

  # Managed rules
  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Block"
    
    override {
      rule_group_name = "SQL_INJECTION"
      
      rule {
        rule_id = "942100"
        enabled_state = "Enabled"
        action = "Block"
      }
    }
  }
}

# Notification Hubs
resource "azurerm_notification_hub_namespace" "main" {
  name                = var.notification_hub_namespace
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.notification_hub_sku
  tags                = var.tags
}

resource "azurerm_notification_hub" "main" {
  name                = "nh-${var.naming_suffix}"
  namespace_name      = azurerm_notification_hub_namespace.main.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Cognitive Services Account (if enabled)
resource "azurerm_cognitive_account" "main" {
  count               = var.enable_cognitive_services ? 1 : 0
  name                = "cog-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.cognitive_services_sku
  kind                = "CognitiveServices"
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  # Enable multiple cognitive services
  custom_subdomain_name = replace("cog-${var.naming_suffix}", "-", "")

  # Network security
  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.private_subnet_id
      action    = "Allow"
    }
  }
}

# Data Factory (if enabled)
resource "azurerm_data_factory" "main" {
  count               = var.enable_data_factory ? 1 : 0
  name                = "adf-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# Private DNS Zones for additional services
resource "azurerm_private_dns_zone" "apim" {
  name                = "privatelink.azure-api.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "apim" {
  name                  = "apim-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.apim.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Private Endpoints for API Management
resource "azurerm_private_endpoint" "apim" {
  name                = "pe-apim-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-apim-${var.naming_suffix}"
    private_connection_resource_id = azurerm_api_management.main.id
    is_manual_connection           = false
    subresource_names              = ["gateway"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.apim.id]
  }
}

# Role Assignments
resource "azurerm_role_assignment" "apim_key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_api_management.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "apim_monitoring_reader" {
  count                = var.log_analytics_id != null ? 1 : 0
  scope                = var.log_analytics_id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_api_management.main.identity[0].principal_id
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "apim" {
  count                      = var.log_analytics_id != null ? 1 : 0
  name                       = "apim-diag"
  target_resource_id         = azurerm_api_management.main.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "GatewayLogs"
  }

  enabled_log {
    category = "ApiManagementGatewayRequests"
  }

  metric {
    category = "AllMetrics"
  }
}

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

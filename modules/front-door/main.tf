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
  host_name                = var.app_service_hostname != "" ? var.app_service_hostname : "app-${var.naming_suffix}.azurewebsites.net"
  http_port                = 80
  https_port               = 443
  origin_host_header       = var.app_service_hostname != "" ? var.app_service_hostname : "app-${var.naming_suffix}.azurewebsites.net"
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

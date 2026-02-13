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

# Private DNS Zones for API Management
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

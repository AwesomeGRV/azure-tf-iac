data "azurerm_client_config" "current" {}

resource "azurerm_app_service_plan" "main" {
  name                = "asp-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku {
    tier = split("-", var.app_service_sku)[0]
    size = split("-", var.app_service_sku)[1]
  }

  reserved = false
  is_xenon = false

  zone_balancing_enabled = true
}

resource "azurerm_app_service" "main" {
  name                = "app-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.main.id
  tags                = var.tags

  site_config {
    always_on                 = true
    app_command_line          = ""
    default_documents         = ["index.html", "index.htm"]
    dotnet_framework_version  = "v4.0"
    ftps_state                = "Disabled"
    http2_enabled             = true
    ip_restriction {
      virtual_network_subnet_id = var.app_service_subnet_id
      action                    = "Allow"
      name                      = "AllowVNet"
      priority                  = 100
    }
    ip_restriction {
      action     = "Deny"
      ip_address = "0.0.0.0/0"
      name       = "DenyAll"
      priority   = 200
    }
    linux_fx_version          = "DOCKER|nginx:latest"
    local_mysql_enabled       = false
    managed_pipeline_mode     = "Integrated"
    min_tls_version           = "1.2"
    remote_debugging_enabled  = false
    scm_type                  = "None"
    use_32_bit_worker_process = false
    websockets_enabled        = false
    windows_fx_version        = ""
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "DOCKER_REGISTRY_SERVER_URL"  = ""
    "DOCKER_REGISTRY_SERVER_USERNAME" = ""
    "DOCKER_REGISTRY_SERVER_PASSWORD" = ""
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  logs {
    detailed_error_messages_enabled = true
    failed_request_tracing_enabled = true
  }

  auth_settings {
    enabled = false
  }

  storage_account {
    name         = "mystorageaccount"
    type         = "AzureBlob"
    account_name = ""
    share_name   = ""
    access_key   = ""
    mount_path   = "/mnt/storage"
  }

  depends_on = [
    azurerm_role_assignment.app_service_key_vault_secrets_user
  ]
}

resource "azurerm_service_plan" "function" {
  name                = "sp-function-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  os_type  = "Linux"
  sku_name = var.function_app_sku

  zone_balancing_enabled = true
}

resource "azurerm_linux_function_app" "main" {
  name                = "func-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function.id
  tags                = var.tags

  site_config {
    always_on                 = true
    app_command_line          = ""
    default_documents         = ["index.html", "index.htm"]
    ftps_state                = "Disabled"
    http2_enabled             = true
    ip_restriction {
      virtual_network_subnet_id = var.app_service_subnet_id
      action                    = "Allow"
      name                      = "AllowVNet"
      priority                  = 100
    }
    ip_restriction {
      action     = "Deny"
      ip_address = "0.0.0.0/0"
      name       = "DenyAll"
      priority   = 200
    }
    linux_fx_version          = "PYTHON|3.9"
    local_mysql_enabled       = false
    managed_pipeline_mode     = "Integrated"
    min_tls_version           = "1.2"
    remote_debugging_enabled  = false
    scm_type                  = "None"
    use_32_bit_worker_process = false
    websockets_enabled        = false
    application_stack {
      python_version = "3.9"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AzureWebJobsStorage"                = ""
    "FUNCTIONS_EXTENSION_VERSION"        = "~4"
    "FUNCTIONS_WORKER_RUNTIME"           = "python"
    "WEBSITE_RUN_FROM_PACKAGE"           = "1"
    "WEBSITE_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  storage_account {
    name         = "functionstorage"
    type         = "AzureBlob"
    account_name = ""
    share_name   = ""
    access_key   = ""
    mount_path   = "/mnt/storage"
  }

  depends_on = [
    azurerm_role_assignment.function_app_key_vault_secrets_user
  ]
}

resource "azurerm_private_dns_zone" "webapps" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "webapps" {
  name                  = "webapps-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.webapps.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "app_service" {
  name                = "pe-app-service-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.app_service_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-app-service-${var.naming_suffix}"
    private_connection_resource_id = azurerm_app_service.main.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapps.id]
  }
}

resource "azurerm_private_endpoint" "function_app" {
  name                = "pe-function-app-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.app_service_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-function-app-${var.naming_suffix}"
    private_connection_resource_id = azurerm_linux_function_app.main.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapps.id]
  }
}

resource "azurerm_role_assignment" "app_service_key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_app_service.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "function_app_key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "app_service_monitoring_reader" {
  count                = var.log_analytics_id != null ? 1 : 0
  scope                = var.log_analytics_id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_app_service.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "function_app_monitoring_reader" {
  count                = var.log_analytics_id != null ? 1 : 0
  scope                = var.log_analytics_id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

resource "azurerm_monitor_diagnostic_setting" "app_service" {
  count                      = var.log_analytics_id != null ? 1 : 0
  name                       = "app-service-diag"
  target_resource_id         = azurerm_app_service.main.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  enabled_log {
    category = "AppServiceAuditLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "function_app" {
  count                      = var.log_analytics_id != null ? 1 : 0
  name                       = "function-app-diag"
  target_resource_id         = azurerm_linux_function_app.main.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

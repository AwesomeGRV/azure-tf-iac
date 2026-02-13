resource "random_password" "mysql_admin" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_+-="
}

resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-${var.naming_suffix}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.mysql_admin_login
  administrator_password = random_password.mysql_admin.result
  version                = "8.0.21"
  sku_name               = var.mysql_sku_name
  zone                   = "1"
  backup_retention_days  = 7
  geo_redundant_backup   = false
  storage_mb             = 32768
  tags                   = var.tags

  delegated_subnet_id    = var.private_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql.id

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  maintenance_window {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mysql_flexible_database" "main" {
  name                = "appdb"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Private DNS Zones for MySQL
resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.flexible.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Private Endpoints for MySQL
resource "azurerm_private_endpoint" "mysql" {
  name                = "pe-mysql-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-mysql-${var.naming_suffix}"
    private_connection_resource_id = azurerm_mysql_flexible_server.main.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysql.id]
  }
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "mysql" {
  count                      = var.log_analytics_id != null ? 1 : 0
  name                       = "mysql-diag"
  target_resource_id         = azurerm_mysql_flexible_server.main.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "MySqlAuditLog"
  }

  enabled_log {
    category = "MySqlSlowQueryLog"
  }

  enabled_log {
    category = "MySqlErrorLog"
  }

  metric {
    category = "AllMetrics"
  }
}

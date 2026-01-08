resource "random_password" "mysql_admin" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_+-="
}

resource "azurerm_storage_account" "main" {
  name                     = replace("st${var.naming_suffix}", "-", "")
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication
  min_tls_version          = "TLS1_2"
  tags                     = var.tags

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  blob_properties {
    versioning_enabled = true
    change_feed_enabled = true
    
    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  queue_properties {
    logging {
      delete  = true
      read    = true
      write   = true
      version = "2.0"
      retention_policy_days = 30
    }

    hour_metrics {
      enabled = true
      version = "1.0"
      include_apis = true
      retention_policy_days = 30
    }

    minute_metrics {
      enabled = true
      version = "1.0"
      include_apis = true
      retention_policy_days = 30
    }
  }

  share_properties {
    retention_policy {
      days = 30
    }
  }

  lifecycle {
    ignore_changes = [
      tags["CreatedAt"]
    ]
  }
}

resource "azurerm_storage_container" "blobs" {
  name                  = "blobs"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "logs" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "files" {
  name                 = "fileshare"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 5120
}

resource "azurerm_storage_table" "main" {
  name                 = "datatable"
  storage_account_name = azurerm_storage_account.main.name
}

resource "azurerm_storage_queue" "main" {
  name                 = "messagequeue"
  storage_account_name = azurerm_storage_account.main.name
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

resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.flexible.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "storage-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-storage-blob-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-storage-blob-${var.naming_suffix}"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }
}

resource "azurerm_private_endpoint" "storage_file" {
  name                = "pe-storage-file-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-storage-file-${var.naming_suffix}"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }
}

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

resource "azurerm_monitor_diagnostic_setting" "storage" {
  count                      = var.log_analytics_id != null ? 1 : 0
  name                       = "storage-diag"
  target_resource_id         = azurerm_storage_account.main.id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
  }
}

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

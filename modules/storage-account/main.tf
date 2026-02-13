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

# Private DNS Zones for Storage
resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
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

# Private Endpoints for Storage
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

# Diagnostic Settings
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

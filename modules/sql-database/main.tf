data "azurerm_client_config" "current" {}

resource "random_password" "sql_admin" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_+-="
}

resource "azurerm_sql_server" "main" {
  name                         = "sql-${var.naming_suffix}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password  = random_password.sql_admin.result
  minimum_tls_version          = "1.2"
  tags                         = var.tags

  identity {
    type = "SystemAssigned"
  }

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id     = data.azurerm_client_config.current.object_id
  }
}

resource "azurerm_sql_database" "main" {
  name                = "appdb"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.main.name
  sku_name            = var.sql_sku_name
  tags                = var.tags

  extended_auditing_policy {
    storage_endpoint                        = var.storage_account_primary_blob_endpoint
    storage_account_access_key              = var.storage_account_primary_key
    storage_account_access_key_is_secondary = false
    retention_in_days                       = 30
  }

  threat_detection_policy {
    state              = "Enabled"
    email_addresses    = []
    retention_days     = 30
  }
}

# Private DNS Zones for SQL
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Private Endpoints for SQL
resource "azurerm_private_endpoint" "sql" {
  name                = "pe-sql-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-sql-${var.naming_suffix}"
    private_connection_resource_id = azurerm_sql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}

resource "azurerm_redis_cache" "main" {
  name                = replace("redis-${var.naming_suffix}", "-", "")
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  tags                = var.tags

  redis_configuration {
    maxmemory_reserved = 2
    maxmemory_policy   = "volatile-lru"
    rdb_backup_enabled = "true"
    rdb_backup_frequency = 60
    rdb_backup_max_snapshot_count = 1
    rdb_connection_string = var.storage_account_connection_string
  }

  identity {
    type = "SystemAssigned"
  }
}

# Private DNS Zones for Redis
resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Private Endpoints for Redis
resource "azurerm_private_endpoint" "redis" {
  name                = "pe-redis-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-redis-${var.naming_suffix}"
    private_connection_resource_id = azurerm_redis_cache.main.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
  }
}

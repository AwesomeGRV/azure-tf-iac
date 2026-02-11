locals {
  naming_suffix = "${var.prefix}-${var.environment}-${random_string.suffix.result}"
  
  common_tags = merge(var.tags, {
    Environment = var.environment
    Location    = var.location
    CreatedBy   = "Terraform"
    CreatedAt   = time_static.created.rfc3339
  })
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "time_static" "created" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.naming_suffix}"
  location = var.location
  tags     = local.common_tags
}

module "monitoring" {
  count               = var.enable_monitoring ? 1 : 0
  source              = "./modules/monitoring"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  naming_suffix       = local.naming_suffix
  tags                = local.common_tags
  log_retention_days  = var.log_retention_days
}

module "networking" {
  source              = "./modules/networking"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  naming_suffix       = local.naming_suffix
  vnet_address_space  = var.vnet_address_space
  app_gateway_sku    = var.app_gateway_sku
  app_gateway_capacity = var.app_gateway_capacity
  tags                = local.common_tags
}

module "security" {
  source              = "./modules/security"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  naming_suffix       = local.naming_suffix
  tags                = local.common_tags
}

module "storage" {
  source                = "./modules/storage"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  naming_suffix         = local.naming_suffix
  tags                  = local.common_tags
  storage_account_tier  = var.storage_account_tier
  storage_replication   = var.storage_account_replication_type
  mysql_admin_login     = var.mysql_administrator_login
  mysql_sku_name        = var.mysql_sku_name
  sql_sku_name          = var.sql_sku_name
  sql_admin_login       = var.sql_admin_login
  redis_sku_name        = var.redis_sku_name
  redis_family          = var.redis_family
  redis_capacity        = var.redis_capacity
  vnet_id               = module.networking.vnet_id
  private_subnet_id     = module.networking.private_endpoints_subnet_id
  log_analytics_id      = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_id : null
}

module "compute" {
  source              = "./modules/compute"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  naming_suffix       = local.naming_suffix
  tags                = local.common_tags
  admin_username      = var.admin_username
  admin_ssh_key       = var.admin_ssh_key
  aks_node_count      = var.aks_node_count
  aks_vm_size         = var.aks_vm_size
  acr_sku             = var.acr_sku
  vnet_id             = module.networking.vnet_id
  aks_subnet_id       = module.networking.aks_subnet_id
  vm_subnet_id        = module.networking.vm_subnet_id
  key_vault_id        = module.security.key_vault_id
  log_analytics_id    = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_id : null
}

module "applications" {
  source              = "./modules/applications"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  naming_suffix       = local.naming_suffix
  tags                = local.common_tags
  app_service_sku     = var.app_service_plan_sku
  function_app_sku    = var.function_app_sku
  service_bus_sku     = var.service_bus_sku
  event_grid_sku       = var.event_grid_sku
  vnet_id             = module.networking.vnet_id
  app_service_subnet_id = module.networking.app_service_subnet_id
  key_vault_id        = module.security.key_vault_id
  log_analytics_id    = var.enable_monitoring ? module.monitoring[0].log_analytics_workspace_id : null
}

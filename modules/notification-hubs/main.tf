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

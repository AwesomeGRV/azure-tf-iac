# Data Factory
resource "azurerm_data_factory" "main" {
  name                = "adf-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

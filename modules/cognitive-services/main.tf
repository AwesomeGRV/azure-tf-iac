data "azurerm_client_config" "current" {}

# Cognitive Services Account
resource "azurerm_cognitive_account" "main" {
  name                = "cog-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.cognitive_services_sku
  kind                = "CognitiveServices"
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  # Enable multiple cognitive services
  custom_subdomain_name = replace("cog-${var.naming_suffix}", "-", "")

  # Network security
  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.private_subnet_id
      action    = "Allow"
    }
  }
}

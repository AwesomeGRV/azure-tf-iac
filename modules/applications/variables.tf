variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "naming_suffix" {
  description = "Naming suffix for resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "app_service_sku" {
  description = "App Service Plan SKU"
  type        = string
}

variable "function_app_sku" {
  description = "Function App SKU"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "log_analytics_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
  default     = null
}

variable "service_bus_sku" {
  description = "SKU for Service Bus namespace"
  type        = string
  default     = "Standard"
}

variable "event_grid_sku" {
  description = "SKU for Event Grid topic"
  type        = string
  default     = "Basic"
}

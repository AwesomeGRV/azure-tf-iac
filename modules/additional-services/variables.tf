variable "location" {
  description = "Azure region for deployment"
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
  default     = {}
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private endpoints subnet ID"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "log_analytics_id" {
  description = "Log Analytics workspace ID"
  type        = string
  default     = null
}

# API Management Variables
variable "apim_sku_name" {
  description = "API Management SKU name"
  type        = string
  default     = "Developer_1"
}

variable "apim_publisher_name" {
  description = "API Management publisher name"
  type        = string
  default     = "API Management Team"
}

variable "apim_publisher_email" {
  description = "API Management publisher email"
  type        = string
  default     = "api-team@example.com"
}

# CDN Variables
variable "cdn_sku_name" {
  description = "CDN profile SKU name"
  type        = string
  default     = "Standard_Microsoft"
}

# Front Door Variables
variable "front_door_sku_name" {
  description = "Front Door SKU name"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "enable_waf" {
  description = "Enable WAF on Front Door"
  type        = bool
  default     = true
}

# Notification Hubs Variables
variable "notification_hub_sku" {
  description = "Notification Hub SKU name"
  type        = string
  default     = "Free"
}

variable "notification_hub_namespace" {
  description = "Notification Hub namespace"
  type        = string
  default     = "notification-namespace"
}

# Cognitive Services Variables
variable "cognitive_services_sku" {
  description = "Cognitive Services SKU name"
  type        = string
  default     = "S0"
}

variable "enable_cognitive_services" {
  description = "Enable Cognitive Services"
  type        = bool
  default     = false
}

# Data Factory Variables
variable "data_factory_sku" {
  description = "Data Factory SKU name"
  type        = string
  default     = "GP"
}

variable "enable_data_factory" {
  description = "Enable Data Factory"
  type        = bool
  default     = false
}

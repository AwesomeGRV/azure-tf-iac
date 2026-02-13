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

variable "log_analytics_id" {
  description = "Log Analytics workspace ID"
  type        = string
  default     = null
}

variable "cdn_sku_name" {
  description = "CDN profile SKU name"
  type        = string
  default     = "Standard_Microsoft"
}

variable "app_service_hostname" {
  description = "App Service hostname for CDN origin"
  type        = string
  default     = ""
}

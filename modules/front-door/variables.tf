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

variable "app_service_hostname" {
  description = "App Service hostname for Front Door origin"
  type        = string
  default     = ""
}

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

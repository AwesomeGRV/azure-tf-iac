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

variable "log_analytics_id" {
  description = "Log Analytics workspace ID"
  type        = string
  default     = null
}

variable "mysql_admin_login" {
  description = "MySQL administrator login"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_sku_name" {
  description = "MySQL SKU name"
  type        = string
  default     = "GP_Gen5_2"
}

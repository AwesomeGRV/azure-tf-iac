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

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
}

variable "storage_replication" {
  description = "Storage account replication type"
  type        = string
}

variable "mysql_admin_login" {
  description = "MySQL administrator login"
  type        = string
}

variable "mysql_sku_name" {
  description = "MySQL SKU name"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private endpoints subnet"
  type        = string
}

variable "log_analytics_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
  default     = null
}

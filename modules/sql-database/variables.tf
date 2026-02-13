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

variable "sql_sku_name" {
  description = "SKU name for Azure SQL Database"
  type        = string
  default     = "S2"
}

variable "sql_admin_login" {
  description = "SQL administrator login"
  type        = string
  default     = "sqladmin"
}

variable "storage_account_primary_blob_endpoint" {
  description = "Storage account primary blob endpoint for SQL auditing"
  type        = string
  default     = ""
}

variable "storage_account_primary_key" {
  description = "Storage account primary key for SQL auditing"
  type        = string
  default     = ""
  sensitive   = true
}

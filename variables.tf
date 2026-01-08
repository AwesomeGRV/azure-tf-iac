variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "azinfra"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    "ManagedBy"     = "Terraform"
    "Environment"   = "production"
    "CostCenter"    = "IT"
    "Compliance"    = "SOC2"
    "DataClassification" = "Confidential"
  }
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureadmin"
}

variable "admin_ssh_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = ""
}

variable "mysql_administrator_login" {
  description = "MySQL administrator login"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_sku_name" {
  description = "MySQL SKU name"
  type        = string
  default     = "GP_Gen5_2"
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Storage account tier must be either Standard or Premium."
  }
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "ZRS"
  
  validation {
    condition = contains([
      "LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"
    ], var.storage_account_replication_type)
    error_message = "Storage account replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "P1v2"
}

variable "function_app_sku" {
  description = "Function App SKU"
  type        = string
  default     = "EP1"
}

variable "enable_monitoring" {
  description = "Enable Azure Monitor and Log Analytics"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 30
}

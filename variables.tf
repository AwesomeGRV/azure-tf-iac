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

variable "acr_sku" {
  description = "SKU tier for Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "redis_sku_name" {
  description = "SKU name for Redis Cache"
  type        = string
  default     = "Standard"
}

variable "redis_family" {
  description = "Redis family"
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "Redis capacity"
  type        = number
  default     = 1
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

variable "app_gateway_sku" {
  description = "SKU for Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "app_gateway_capacity" {
  description = "Capacity for Application Gateway"
  type        = number
  default     = 2
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

# Additional Services Variables
variable "apim_sku_name" {
  description = "API Management SKU name"
  type        = string
  default     = "Developer_1"
  
  validation {
    condition = contains([
      "Developer_1", "Basic_1", "Basic_2", "Standard_1", "Standard_2", "Premium_1"
    ], var.apim_sku_name)
    error_message = "API Management SKU must be one of: Developer_1, Basic_1, Basic_2, Standard_1, Standard_2, Premium_1."
  }
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

variable "cdn_sku_name" {
  description = "CDN profile SKU name"
  type        = string
  default     = "Standard_Microsoft"
  
  validation {
    condition = contains([
      "Standard_Microsoft", "Premium_Microsoft", "Standard_Akamai", "Standard_Verizon", "Premium_Verizon"
    ], var.cdn_sku_name)
    error_message = "CDN SKU must be one of: Standard_Microsoft, Premium_Microsoft, Standard_Akamai, Standard_Verizon, Premium_Verizon."
  }
}

variable "front_door_sku_name" {
  description = "Front Door SKU name"
  type        = string
  default     = "Standard_AzureFrontDoor"
  
  validation {
    condition = contains([
      "Standard_AzureFrontDoor", "Premium_AzureFrontDoor"
    ], var.front_door_sku_name)
    error_message = "Front Door SKU must be one of: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  }
}

variable "enable_waf" {
  description = "Enable WAF on Front Door"
  type        = bool
  default     = true
}

variable "notification_hub_sku" {
  description = "Notification Hub SKU name"
  type        = string
  default     = "Free"
  
  validation {
    condition = contains(["Free", "Basic", "Standard"], var.notification_hub_sku)
    error_message = "Notification Hub SKU must be one of: Free, Basic, Standard."
  }
}

variable "notification_hub_namespace" {
  description = "Notification Hub namespace"
  type        = string
  default     = "notification-namespace"
}

variable "cognitive_services_sku" {
  description = "Cognitive Services SKU name"
  type        = string
  default     = "S0"
  
  validation {
    condition = contains(["F0", "S0", "S1", "S2", "S3", "S4"], var.cognitive_services_sku)
    error_message = "Cognitive Services SKU must be one of: F0, S0, S1, S2, S3, S4."
  }
}

variable "enable_cognitive_services" {
  description = "Enable Cognitive Services"
  type        = bool
  default     = false
}

variable "data_factory_sku" {
  description = "Data Factory SKU name"
  type        = string
  default     = "GP"
  
  validation {
    condition = contains(["GP", "GP_2"], var.data_factory_sku)
    error_message = "Data Factory SKU must be one of: GP, GP_2."
  }
}

variable "enable_data_factory" {
  description = "Enable Data Factory"
  type        = bool
  default     = false
}

# API Management Variables
variable "apim_sku_name" {
  description = "API Management SKU name"
  type        = string
  default     = "Developer_1"
  
  validation {
    condition = contains([
      "Developer_1", "Basic_1", "Basic_2", "Standard_1", "Standard_2", "Premium_1"
    ], var.apim_sku_name)
    error_message = "API Management SKU must be one of: Developer_1, Basic_1, Basic_2, Standard_1, Standard_2, Premium_1."
  }
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
  
  validation {
    condition = contains([
      "Standard_Microsoft", "Premium_Microsoft", "Standard_Akamai", "Standard_Verizon", "Premium_Verizon"
    ], var.cdn_sku_name)
    error_message = "CDN SKU must be one of: Standard_Microsoft, Premium_Microsoft, Standard_Akamai, Standard_Verizon, Premium_Verizon."
  }
}

# Front Door Variables
variable "front_door_sku_name" {
  description = "Front Door SKU name"
  type        = string
  default     = "Standard_AzureFrontDoor"
  
  validation {
    condition = contains([
      "Standard_AzureFrontDoor", "Premium_AzureFrontDoor"
    ], var.front_door_sku_name)
    error_message = "Front Door SKU must be one of: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  }
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
  
  validation {
    condition = contains(["Free", "Basic", "Standard"], var.notification_hub_sku)
    error_message = "Notification Hub SKU must be one of: Free, Basic, Standard."
  }
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
  
  validation {
    condition = contains(["F0", "S0", "S1", "S2", "S3", "S4"], var.cognitive_services_sku)
    error_message = "Cognitive Services SKU must be one of: F0, S0, S1, S2, S3, S4."
  }
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
  
  validation {
    condition = contains(["GP", "GP_2"], var.data_factory_sku)
    error_message = "Data Factory SKU must be one of: GP, GP_2."
  }
}

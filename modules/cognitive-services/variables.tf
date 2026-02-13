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

variable "private_subnet_id" {
  description = "Private endpoints subnet ID"
  type        = string
}

variable "cognitive_services_sku" {
  description = "Cognitive Services SKU name"
  type        = string
  default     = "S0"
}

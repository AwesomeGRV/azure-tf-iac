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

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
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

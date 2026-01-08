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

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
}

variable "admin_ssh_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = ""
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet"
  type        = string
}

variable "vm_subnet_id" {
  description = "ID of the VM subnet"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "log_analytics_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
  default     = null
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "aks_subnet_name" {
  description = "Name of the AKS subnet"
  value       = azurerm_subnet.aks.name
}

output "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  value       = azurerm_subnet.app_service.id
}

output "app_service_subnet_name" {
  description = "Name of the App Service subnet"
  value       = azurerm_subnet.app_service.name
}

output "vm_subnet_id" {
  description = "ID of the VM subnet"
  value       = azurerm_subnet.vm.id
}

output "vm_subnet_name" {
  description = "Name of the VM subnet"
  value       = azurerm_subnet.vm.name
}

output "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "private_endpoints_subnet_name" {
  description = "Name of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.name
}

output "firewall_subnet_id" {
  description = "ID of the firewall subnet"
  value       = azurerm_subnet.firewall.id
}

output "firewall_subnet_name" {
  description = "Name of the firewall subnet"
  value       = azurerm_subnet.firewall.name
}

output "firewall_id" {
  description = "ID of the Azure Firewall"
  value       = azurerm_firewall.main.id
}

output "firewall_name" {
  description = "Name of the Azure Firewall"
  value       = azurerm_firewall.main.name
}

output "firewall_public_ip" {
  description = "Public IP address of the Azure Firewall"
  value       = azurerm_public_ip.firewall.ip_address
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = azurerm_firewall.main.ip_configuration[0].private_ip_address
}

output "network_security_group_aks_id" {
  description = "ID of the AKS network security group"
  value       = azurerm_network_security_group.aks.id
}

output "network_security_group_vm_id" {
  description = "ID of the VM network security group"
  value       = azurerm_network_security_group.vm.id
}

output "network_security_group_private_endpoints_id" {
  description = "ID of the private endpoints network security group"
  value       = azurerm_network_security_group.private_endpoints.id
}

output "route_table_id" {
  description = "ID of the route table"
  value       = azurerm_route_table.main.id
}

output "ddos_protection_plan_id" {
  description = "ID of the DDoS protection plan"
  value       = azurerm_network_ddos_protection_plan.main.id
}

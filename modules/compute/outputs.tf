output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_kube_config" {
  description = "Kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "aks_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "aks_portal_fqdn" {
  description = "Portal FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.portal_fqdn
}

output "aks_identity_principal_id" {
  description = "Principal ID of the AKS cluster identity"
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

output "aks_identity_tenant_id" {
  description = "Tenant ID of the AKS cluster identity"
  value       = azurerm_kubernetes_cluster.main.identity[0].tenant_id
}

output "vm_names" {
  description = "Names of the virtual machines"
  value       = azurerm_linux_virtual_machine.main[*].name
}

output "vm_ids" {
  description = "IDs of the virtual machines"
  value       = azurerm_linux_virtual_machine.main[*].id
}

output "vm_private_ips" {
  description = "Private IP addresses of the virtual machines"
  value       = azurerm_network_interface.vm[*].private_ip_address
}

output "vm_public_ips" {
  description = "Public IP addresses of the virtual machines"
  value       = azurerm_public_ip.vm[*].ip_address
}

output "vm_public_ip_ids" {
  description = "IDs of the public IP addresses"
  value       = azurerm_public_ip.vm[*].id
}

output "availability_set_name" {
  description = "Name of the availability set"
  value       = azurerm_availability_set.main.name
}

output "availability_set_id" {
  description = "ID of the availability set"
  value       = azurerm_availability_set.main.id
}

output "ssh_private_key" {
  description = "SSH private key for VM access"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  description = "SSH public key for VM access"
  value       = tls_private_key.ssh.public_key_openssh
}

output "vm_identity_principal_ids" {
  description = "Principal IDs of the VM identities"
  value       = azurerm_linux_virtual_machine.main[*].identity[0].principal_id
}

output "network_interface_ids" {
  description = "IDs of the network interfaces"
  value       = azurerm_network_interface.vm[*].id
}

output "network_security_group_ids" {
  description = "IDs of the network security groups"
  value       = azurerm_network_security_group.vm[*].id
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}

output "container_registry_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}

output "container_registry_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_admin_username" {
  description = "Admin username of the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_username
}

output "container_registry_admin_password" {
  description = "Admin password of the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

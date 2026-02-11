data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.naming_suffix}"
  tags                = var.tags

  default_node_pool {
    name           = "default"
    node_count     = var.aks_node_count
    vm_size        = var.aks_vm_size
    vnet_subnet_id = var.aks_subnet_id
    zones          = ["1", "2", "3"]
    
    upgrade_settings {
      max_surge = "33%"
    }

    node_labels = {
      "nodepool" = "default"
      "environment" = "production"
    }

    taints = {
      "workload" = "general:NoSchedule"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    load_balancer_sku  = "standard"
    service_cidr       = "10.1.0.0/16"
    dns_service_ip     = "10.1.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  addon_profile {
    oms_agent {
      enabled                    = var.log_analytics_id != null
      log_analytics_workspace_id = var.log_analytics_id
    }

    azure_policy {
      enabled = true
    }

    ingress_application_gateway {
      enabled    = false
      gateway_id = null
    }

    http_application_routing {
      enabled = false
    }
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      admin_group_object_ids = [data.azurerm_client_config.current.object_id]
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = true
    expander                         = "least-waste"
    max_graceful_termination_sec     = 600
    max_node_provisioning_time       = "10m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_unneeded_time         = "10m"
    scale_down_unready_time          = "10m"
    scale_down_utilization_threshold = 0.5
    skip_nodes_with_local_storage    = true
    skip_nodes_with_system_pods      = true
  }

  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_id
  }

  azure_policy_enabled = true

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_acrpull" {
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

resource "azurerm_public_ip" "vm" {
  count               = 2
  name                = "pip-vm-${count.index}-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                = "Standard"
  zones              = ["1", "2", "3"]
  tags               = var.tags
}

resource "azurerm_network_interface" "vm" {
  count               = 2
  name                = "nic-vm-${count.index}-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm[count.index].id
  }
}

resource "azurerm_network_security_group" "vm" {
  count               = 2
  name                = "nsg-vm-${count.index}-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_rdp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.vm[count.index].id
  network_security_group_id = azurerm_network_security_group.vm[count.index].id
}

resource "azurerm_availability_set" "main" {
  name                         = "as-${var.naming_suffix}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 5
  managed                      = true
  tags                         = var.tags
}

resource "azurerm_linux_virtual_machine" "main" {
  count               = 2
  name                = "vm-${count.index}-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  availability_set_id = azurerm_availability_set.main.id
  zones              = ["1", "2", "3"]
  tags               = var.tags

  network_interface_ids = [
    azurerm_network_interface.vm[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key != "" ? var.admin_ssh_key : tls_private_key.ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_role_assignment" "vm_key_vault_secrets_user" {
  count                = 2
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine.main[count.index].identity[0].principal_id
}

resource "azurerm_role_assignment" "vm_monitoring_reader" {
  count                = var.log_analytics_id != null ? 2 : 0
  scope                = var.log_analytics_id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_linux_virtual_machine.main[count.index].identity[0].principal_id
}

resource "azurerm_virtual_machine_extension" "monitor" {
  count                = var.log_analytics_id != null ? 2 : 0
  name                 = "AzureMonitorLinuxAgent"
  virtual_machine_id   = azurerm_linux_virtual_machine.main[count.index].id
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorLinuxAgent"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    workspaceId = var.log_analytics_id
  })

  protected_settings = jsonencode({
    workspaceKey = data.azurerm_log_analytics_workspace.primary.shared_keys[0].primary_shared_key
  })

  depends_on = [
    azurerm_role_assignment.vm_monitoring_reader
  ]
}

data "azurerm_log_analytics_workspace" "primary" {
  count               = var.log_analytics_id != null ? 1 : 0
  name                = split("/", var.log_analytics_id)[8]
  resource_group_name = split("/", var.log_analytics_id)[4]
}

resource "azurerm_container_registry" "main" {
  name                = replace("acr${var.naming_suffix}", "-", "")
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = var.tags

  network_rule_set {
    default_action = "Deny"
    ip_rule       = []
    virtual_network {
      action = "Allow"
      subnet_id = var.aks_subnet_id
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

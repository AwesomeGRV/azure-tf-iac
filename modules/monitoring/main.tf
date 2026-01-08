resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = "ai-${var.naming_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.naming_suffix}"
  resource_group_name = var.resource_group_name
  short_name          = "ag${replace(var.naming_suffix, "-", "")}"
  tags                = var.tags

  email_receiver {
    name          = "default-email"
    email_address = "admin@company.com"
  }

  sms_receiver {
    name         = "default-sms"
    country_code = "1"
    phone_number = "1234567890"
  }

  push_receiver {
    name          = "default-push"
    email_address = "admin@company.com"
  }
}

resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "cpu-high-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when CPU usage is high"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation       = "Average"
    operator          = "GreaterThan"
    threshold         = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "memory_high" {
  name                = "memory-high-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when memory usage is high"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Space"
    aggregation       = "Average"
    operator          = "LessThan"
    threshold         = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "disk_high" {
  name                = "disk-high-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when disk usage is high"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Disk Space Used"
    aggregation       = "Average"
    operator          = "GreaterThan"
    threshold         = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "storage_transactions" {
  name                = "storage-transactions-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when storage transactions are high"
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation       = "Total"
    operator          = "GreaterThan"
    threshold         = 1000
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "mysql_connections" {
  name                = "mysql-connections-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when MySQL connections are high"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.DBforMySQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation       = "Average"
    operator          = "GreaterThan"
    threshold         = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "app_service_response_time" {
  name                = "app-service-response-time-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when App Service response time is high"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation       = "Average"
    operator          = "GreaterThan"
    threshold         = 5000
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "function_app_execution_count" {
  name                = "function-app-execution-count-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when Function App execution count is high"
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "FunctionExecutionCount"
    aggregation       = "Total"
    operator          = "GreaterThan"
    threshold         = 1000
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_activity_log_alert" "resource_group_delete" {
  name                = "resource-group-delete-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Action will be triggered when a resource group is deleted"
  criteria {
    category = "ResourceHealth"
    operation_name = "ResourceDelete"
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_log_analytics_saved_search" "error_logs" {
  name                = "error-logs-search"
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  category            = "Security"
  display_name        = "Error Logs"
  query               = "union * | where Level == \"Error\" | summarize count() by bin(TimeGenerated, 1h), Type"
  tags                = var.tags
}

resource "azurerm_monitor_log_analytics_saved_search" "failed_requests" {
  name                = "failed-requests-search"
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  category            = "Performance"
  display_name        = "Failed Requests"
  query               = "union * | where ResultType != \"Success\" | summarize count() by bin(TimeGenerated, 1h), Type"
  tags                = var.tags
}

resource "azurerm_monitor_log_analytics_saved_search" "security_events" {
  name                = "security-events-search"
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  category            = "Security"
  display_name        = "Security Events"
  query               = "union * | where Type == \"SecurityEvent\" | summarize count() by bin(TimeGenerated, 1h), OperationName"
  tags                = var.tags
}

resource "azurerm_monitor_autoscale_setting" "main" {
  name                = "autoscale-${var.naming_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_log_analytics_workspace.main.id
  tags                = var.tags

  profile {
    name = "default"
    
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_log_analytics_workspace.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_log_analytics_workspace.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 20
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_primary_key" {
  description = "Primary key of the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "storage_account_secondary_key" {
  description = "Secondary key of the storage account"
  value       = azurerm_storage_account.main.secondary_access_key
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string of the storage account"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Secondary connection string of the storage account"
  value       = azurerm_storage_account.main.secondary_connection_string
  sensitive   = true
}

output "storage_blob_container_ids" {
  description = "IDs of the blob containers"
  value       = {
    blobs   = azurerm_storage_container.blobs.id
    logs    = azurerm_storage_container.logs.id
    backups = azurerm_storage_container.backups.id
  }
}

output "storage_file_share_id" {
  description = "ID of the file share"
  value       = azurerm_storage_share.files.id
}

output "storage_table_id" {
  description = "ID of the storage table"
  value       = azurerm_storage_table.main.id
}

output "storage_queue_id" {
  description = "ID of the storage queue"
  value       = azurerm_storage_queue.main.id
}

output "mysql_server_name" {
  description = "Name of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.name
}

output "mysql_server_id" {
  description = "ID of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.id
}

output "mysql_server_fqdn" {
  description = "Fully qualified domain name of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_database_name" {
  description = "Name of the MySQL database"
  value       = azurerm_mysql_flexible_database.main.name
}

output "mysql_database_id" {
  description = "ID of the MySQL database"
  value       = azurerm_mysql_flexible_database.main.id
}

output "mysql_administrator_login" {
  description = "MySQL administrator login"
  value       = azurerm_mysql_flexible_server.main.administrator_login
}

output "mysql_administrator_password" {
  description = "MySQL administrator password"
  value       = random_password.mysql_admin.result
  sensitive   = true
}

output "mysql_connection_string" {
  description = "MySQL connection string"
  value       = "Server=${azurerm_mysql_flexible_server.main.fqdn};Database=${azurerm_mysql_flexible_database.main.name};User ID=${azurerm_mysql_flexible_server.main.administrator_login};Password=${random_password.mysql_admin.result};SslMode=Required;"
  sensitive   = true
}

output "private_endpoint_storage_blob_id" {
  description = "ID of the storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_blob.id
}

output "private_endpoint_storage_file_id" {
  description = "ID of the storage file private endpoint"
  value       = azurerm_private_endpoint.storage_file.id
}

output "private_endpoint_mysql_id" {
  description = "ID of the MySQL private endpoint"
  value       = azurerm_private_endpoint.mysql.id
}

output "private_dns_zone_storage_id" {
  description = "ID of the storage private DNS zone"
  value       = azurerm_private_dns_zone.storage.id
}

output "private_dns_zone_mysql_id" {
  description = "ID of the MySQL private DNS zone"
  value       = azurerm_private_dns_zone.mysql.id
}

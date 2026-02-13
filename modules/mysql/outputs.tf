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

output "mysql_administrator_login" {
  description = "MySQL administrator login"
  value       = azurerm_mysql_flexible_server.main.administrator_login
}

output "mysql_administrator_password" {
  description = "MySQL administrator password"
  value       = random_password.mysql_admin.result
  sensitive   = true
}

output "mysql_database_name" {
  description = "Name of the MySQL database"
  value       = azurerm_mysql_flexible_database.main.name
}

output "mysql_connection_string" {
  description = "MySQL connection string"
  value       = "Server=${azurerm_mysql_flexible_server.main.fqdn};Database=${azurerm_mysql_flexible_database.main.name};User ID=${azurerm_mysql_flexible_server.main.administrator_login};Password=${random_password.mysql_admin.result};"
  sensitive   = true
}

output "mysql_private_endpoint_id" {
  description = "ID of the MySQL private endpoint"
  value       = azurerm_private_endpoint.mysql.id
}

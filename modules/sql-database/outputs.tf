output "sql_server_name" {
  description = "Name of the SQL server"
  value       = azurerm_sql_server.main.name
}

output "sql_server_id" {
  description = "ID of the SQL server"
  value       = azurerm_sql_server.main.id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL server"
  value       = azurerm_sql_server.main.fully_qualified_domain_name
}

output "sql_administrator_login" {
  description = "SQL administrator login"
  value       = azurerm_sql_server.main.administrator_login
}

output "sql_administrator_password" {
  description = "SQL administrator password"
  value       = random_password.sql_admin.result
  sensitive   = true
}

output "sql_database_name" {
  description = "Name of the SQL database"
  value       = azurerm_sql_database.main.name
}

output "sql_connection_string" {
  description = "SQL connection string"
  value       = "Server=tcp:${azurerm_sql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.main.name};User ID=${azurerm_sql_server.main.administrator_login};Password=${random_password.sql_admin.result};Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
  sensitive   = true
}

output "sql_private_endpoint_id" {
  description = "ID of the SQL private endpoint"
  value       = azurerm_private_endpoint.sql.id
}

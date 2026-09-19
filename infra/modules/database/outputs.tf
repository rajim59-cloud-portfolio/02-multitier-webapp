output "server_id" {
  description = "PostgreSQL Flexible Server resource ID"
  value       = azurerm_postgresql_flexible_server.this.id
}

output "server_name" {
  description = "PostgreSQL server name"
  value       = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  description = "PostgreSQL FQDN (resolves to private IP via DNS zone)"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  description = "Application database name"
  value       = azurerm_postgresql_flexible_server_database.this.name
}

output "admin_username" {
  description = "Administrator login"
  value       = var.admin_username
}

output "admin_password" {
  description = "Administrator password (sensitive)"
  value       = random_password.admin.result
  sensitive   = true
}

output "private_endpoint_id" {
  description = "Private Endpoint resource ID"
  value       = azurerm_private_endpoint.postgres.id
}

output "private_endpoint_ip" {
  description = "Private IP assigned to the PE"
  value       = azurerm_private_endpoint.postgres.private_service_connection[0].private_ip_address
}
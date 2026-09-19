output "app_id" {
  description = "App Service resource ID"
  value       = azurerm_linux_web_app.this.id
}

output "app_name" {
  description = "App Service name"
  value       = azurerm_linux_web_app.this.name
}

output "app_url" {
  description = "Default HTTPS URL of the app"
  value       = "https://${azurerm_linux_web_app.this.default_hostname}"
}

output "default_hostname" {
  description = "Default hostname (no scheme)"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "principal_id" {
  description = "Managed Identity principal ID (for RBAC assignments)"
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}

output "outbound_ip_addresses" {
  description = "App Service outbound IPs (for Access Restrictions on other apps)"
  value       = azurerm_linux_web_app.this.outbound_ip_addresses
}
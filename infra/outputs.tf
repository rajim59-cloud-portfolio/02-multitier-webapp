# ================================================================
# Frontend
# ================================================================
output "frontend_url" {
  description = "Public URL of the frontend app"
  value       = module.frontend_app.app_url
}

output "frontend_hostname" {
  description = "Frontend hostname (for DNS or docs)"
  value       = module.frontend_app.default_hostname
}

output "frontend_principal_id" {
  description = "Frontend Managed Identity principal ID"
  value       = module.frontend_app.principal_id
}

# ================================================================
# Shared infrastructure
# ================================================================
output "app_service_plan_id" {
  description = "Shared App Service Plan ID"
  value       = azurerm_service_plan.main.id
}

output "app_service_plan_name" {
  description = "Shared App Service Plan name"
  value       = azurerm_service_plan.main.name
}
# ================================================================
# Backend
# ================================================================
output "backend_url" {
  description = "Backend app URL (private — reachable only via frontend)"
  value       = module.backend_app.app_url
}

output "backend_hostname" {
  description = "Backend default hostname"
  value       = module.backend_app.default_hostname
}

output "backend_principal_id" {
  description = "Backend Managed Identity principal ID"
  value       = module.backend_app.principal_id
}

# ================================================================
# Database
# ================================================================
output "database_fqdn" {
  description = "PostgreSQL FQDN"
  value       = module.database.fqdn
}

output "database_name" {
  description = "Application database name"
  value       = module.database.database_name
}

output "database_private_ip" {
  description = "Private IP of the database endpoint"
  value       = module.database.private_endpoint_ip
}

# ⚠️ Do NOT add admin_password as output — sensitive
# Use `terraform output -raw -state=...` inside the module if needed
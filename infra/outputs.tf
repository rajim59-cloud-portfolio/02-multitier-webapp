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
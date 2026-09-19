# ================================================================
# App Service Plan — shared by frontend and backend
# ================================================================
resource "azurerm_service_plan" "main" {
  name                = "asp-${local.prefix}-${var.tags.Env}"
  resource_group_name = local.spoke_app_rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

# ================================================================
# Frontend App (React)
# ================================================================
module "frontend_app" {
  source = "./modules/app-service"

  name                = "frontend"
  prefix              = local.prefix
  location            = var.location
  resource_group_name = local.spoke_app_rg_name
  tags                = var.tags

  app_service_plan_id = azurerm_service_plan.main.id
  node_version        = var.node_version

  # ─── VNet Integration — required so frontend can reach backend ─
  subnet_id = local.app_subnet_id

  # ─── Public access: YES (this is the entry point) ────────────
  public_network_access_enabled = true

  # ─── App settings ─────────────────────────────────────────────
  app_settings = {
    NODE_ENV = "production"
    # Backend URL will be added in Day 3 when backend exists
  }
}
# ================================================================
# Database — PostgreSQL Flexible Server
# ================================================================
module "database" {
  source = "./modules/database"

  name                = "main"
  prefix              = local.prefix
  location            = var.location
  resource_group_name = local.spoke_data_rg_name
  tags                = var.tags

  # ─── Network — from LZ remote state ───────────────────────────
  private_endpoint_subnet_id = local.pe_subnet_id
  private_dns_zone_id        = local.private_dns_zone_ids["privatelink.postgres.database.azure.com"]

  # ─── Config ───────────────────────────────────────────────────
  admin_username        = var.db_admin_username
  sku_name              = var.db_sku_name
  storage_mb            = var.db_storage_mb
  postgres_version      = var.db_version
  database_name         = "appdb"
  backup_retention_days = 7
}

# ================================================================
# Backend App (Node.js API) — private, no public access
# ================================================================
module "backend_app" {
  source = "./modules/app-service"

  name                = "backend"
  prefix              = local.prefix
  location            = var.location
  resource_group_name = local.spoke_app_rg_name
  tags                = var.tags

  app_service_plan_id = azurerm_service_plan.main.id
  node_version        = var.node_version

  # ─── VNet Integration — same App subnet as frontend ──────────
  subnet_id = local.app_subnet_id

  # ─── PUBLIC ACCESS DISABLED — only frontend can reach it ─────
  public_network_access_enabled = false

  # ─── App settings — DB connection pieces ─────────────────────
  # NOTE: This is temporary. Day 4 moves these to Key Vault.
  app_settings = {
    NODE_ENV    = "production"
    DB_HOST     = module.database.fqdn
    DB_PORT     = "5432"
    DB_NAME     = module.database.database_name
    DB_USER     = module.database.admin_username
    DB_PASSWORD = module.database.admin_password
    DB_SSL      = "true"
  }
}
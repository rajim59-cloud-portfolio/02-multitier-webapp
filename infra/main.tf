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
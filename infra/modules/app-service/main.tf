# ================================================================
# Linux Web App (Node.js 18)
# ================================================================
resource "azurerm_linux_web_app" "this" {
  name                = "app-${var.prefix}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id
  tags                = var.tags

  # ─── Public access toggle ─────────────────────────────────────
  public_network_access_enabled = var.public_network_access_enabled

  # ─── HTTPS only ───────────────────────────────────────────────
  https_only = true

  # ─── Managed Identity (used later for Key Vault) ──────────────
  identity {
    type = "SystemAssigned"
  }

  # ─── Site config ──────────────────────────────────────────────
  site_config {
    always_on           = true
    http2_enabled       = true
    minimum_tls_version = "1.2"

    application_stack {
      node_version = var.node_version
    }

    # ─── Health check endpoint ────────────────────────────────
    health_check_path = "/health"

    # ─── IP restrictions for backend ──────────────────────────
    # If public access is disabled, only allow specific sources.
    # We'll add rules from main.tf when needed.
  }

  # ─── App Settings (env vars) ──────────────────────────────────
  app_settings = merge(
    {
      WEBSITE_NODE_DEFAULT_VERSION   = "~18"
      WEBSITE_RUN_FROM_PACKAGE       = "1"
      SCM_DO_BUILD_DURING_DEPLOYMENT = "false"
    },
    var.application_insights_connection_string != "" ? {
      APPLICATIONINSIGHTS_CONNECTION_STRING      = var.application_insights_connection_string
      ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    } : {},
    var.app_settings
  )

  # ─── Logs to filesystem (short-term) ──────────────────────────
  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}

# ================================================================
# VNet Integration (outbound traffic via the LZ spoke subnet)
# ================================================================
resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_linux_web_app.this.id
  subnet_id      = var.subnet_id
}
# ================================================================
# Random admin password (never hardcoded, never in Git)
# ================================================================
resource "random_password" "admin" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 3
  min_lower        = 3
  min_numeric      = 3
  min_special      = 3
}

# ================================================================
# PostgreSQL Flexible Server
# ================================================================
resource "azurerm_postgresql_flexible_server" "this" {
  name                = "psql-${var.prefix}-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.postgres_version
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb

  administrator_login    = var.admin_username
  administrator_password = random_password.admin.result

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # ─── NO PUBLIC ACCESS — accessible only via Private Endpoint ──
  public_network_access_enabled = false

  tags = var.tags

  # ─── High Availability off (cost saving for demo) ────────────
  # Production would use ZoneRedundant

  lifecycle {
    # Azure assigns a zone automatically — ignore changes
    ignore_changes = [zone]
  }
}

# ================================================================
# Application Database inside the server
# ================================================================
resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# ================================================================
# Private Endpoint (connects DB to LZ spoke-data 'pe' subnet)
# ================================================================
resource "azurerm_private_endpoint" "postgres" {
  name                = "pe-${var.prefix}-pg-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-pg-${var.name}"
    private_connection_resource_id = azurerm_postgresql_flexible_server.this.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  # ─── Auto-register the private IP in LZ's Private DNS zone ────
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

# ================================================================
# Firewall Rule — Allow Azure Services (for internal management)
# ================================================================
# Even with public access disabled, Azure needs a rule for internal
# service operations (e.g., automated maintenance).
# NOTE: 0.0.0.0/0 with "Azure Services" special case is blocked when
# public_network_access_enabled = false. We rely on the PE entirely.
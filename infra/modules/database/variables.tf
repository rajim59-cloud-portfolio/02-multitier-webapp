# ─── Identity & Naming ────────────────────────────────────────────
variable "name" {
  description = "Database instance suffix (e.g. 'main')"
  type        = string
  default     = "main"
}

variable "prefix" {
  description = "Naming prefix (e.g. 'mta')"
  type        = string
}

# ─── Common ───────────────────────────────────────────────────────
variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where PostgreSQL will be deployed"
  type        = string
}

variable "tags" {
  description = "Resource tags (enforced by LZ Policy)"
  type        = map(string)
}

# ─── Database Configuration ───────────────────────────────────────
variable "admin_username" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "pgadmin"
}

variable "sku_name" {
  description = "PostgreSQL SKU (B_Standard_B1ms = cheapest Burstable tier)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Storage in MB (minimum 32768 = 32 GB)"
  type        = number
  default     = 32768
}

variable "postgres_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "15"
}

variable "database_name" {
  description = "Name of the application database inside the server"
  type        = string
  default     = "appdb"
}

# ─── Backup ───────────────────────────────────────────────────────
variable "backup_retention_days" {
  description = "Backup retention (7-35 days)"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "Backup retention must be between 7 and 35 days."
  }
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backups (extra cost)"
  type        = bool
  default     = false
}

# ─── Networking ───────────────────────────────────────────────────
variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the Private Endpoint (from LZ spoke-data 'pe' subnet)"
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for privatelink.postgres.database.azure.com (from LZ)"
  type        = string
}
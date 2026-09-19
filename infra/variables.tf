# ─── Subscription & Location ──────────────────────────────────────
variable "subscription_id" {
  description = "Azure subscription ID (must match Project 1's subscription)"
  type        = string
}

variable "location" {
  description = "Azure region (must match Project 1 — Policy will DENY other regions)"
  type        = string
  default     = "malaysiawest"

  validation {
    condition     = contains(["malaysiawest", "southeastasia"], var.location)
    error_message = "Location must be malaysiawest or southeastasia (enforced by LZ Policy)."
  }
}

# ─── Tags (enforced by LZ Policy: require-tags) ───────────────────
variable "tags" {
  description = "Required tags — enforced by Azure Policy from Project 1"
  type = object({
    CostCenter = string
    Env        = string
    Owner      = string
    Project    = string
  })
  default = {
    CostCenter = "portfolio-02"
    Env        = "dev"
    Owner      = "rajim"
    Project    = "multitier-webapp"
  }
}

# ─── App Service ──────────────────────────────────────────────────
variable "app_service_sku" {
  description = "App Service Plan SKU (B1 = cheapest with VNet integration)"
  type        = string
  default     = "B1"
}

variable "node_version" {
  description = "Node.js runtime version for App Service"
  type        = string
  default     = "18-lts"
}

# ─── Database ─────────────────────────────────────────────────────
variable "db_admin_username" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "pgadmin"
}

variable "db_sku_name" {
  description = "PostgreSQL Flexible Server SKU (Burstable B1ms = cheapest)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "db_storage_mb" {
  description = "PostgreSQL storage in MB (minimum 32768)"
  type        = number
  default     = 32768
}

variable "db_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "15"
}

# ─── Alerts ───────────────────────────────────────────────────────
variable "alert_email" {
  description = "Email for budget and application alerts"
  type        = string
}
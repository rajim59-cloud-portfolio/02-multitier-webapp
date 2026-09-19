# ─── Identity ─────────────────────────────────────────────────────
variable "name" {
  description = "App name suffix (e.g. 'frontend', 'backend')"
  type        = string
}

variable "prefix" {
  description = "Naming prefix for resources (e.g. 'mta')"
  type        = string
}

# ─── Common ───────────────────────────────────────────────────────
variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the app will be deployed"
  type        = string
}

variable "tags" {
  description = "Resource tags (enforced by LZ Policy)"
  type        = map(string)
}

# ─── Compute ──────────────────────────────────────────────────────
variable "app_service_plan_id" {
  description = "ID of the shared App Service Plan"
  type        = string
}

variable "node_version" {
  description = "Node.js runtime version"
  type        = string
  default     = "18-lts"
}

# ─── Networking ───────────────────────────────────────────────────
variable "subnet_id" {
  description = "Subnet ID for VNet Integration (outbound traffic)"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable public HTTPS access (true for frontend, false for backend)"
  type        = bool
  default     = true
}

# ─── App Settings ─────────────────────────────────────────────────
variable "app_settings" {
  description = "Additional app settings (env vars)"
  type        = map(string)
  default     = {}
}

# ─── Monitoring ───────────────────────────────────────────────────
variable "application_insights_connection_string" {
  description = "App Insights connection string (empty = skip)"
  type        = string
  default     = ""
  sensitive   = true
}
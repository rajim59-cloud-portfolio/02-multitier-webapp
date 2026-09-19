# Module: app-service

Provisions a Linux Web App (Node.js 18) with VNet Integration and Managed Identity. Reusable — call once per app (frontend, backend).

## What it creates

| Resource | Naming | Purpose |
|----------|--------|---------|
| Linux Web App | `app-<prefix>-<name>` | Node.js 18 runtime |
| VNet Integration | (attached to the app) | Outbound traffic through LZ spoke subnet |
| Managed Identity | (system-assigned) | Key Vault access without passwords |

> The **App Service Plan is created in the root module**, not here — because frontend and backend share one plan (cost optimization).

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | — | `frontend` or `backend` |
| `prefix` | string | — | Resource naming prefix (e.g. `mta`) |
| `location` | string | — | Azure region |
| `resource_group_name` | string | — | Target resource group |
| `tags` | map(string) | — | Resource tags |
| `app_service_plan_id` | string | — | Shared plan ID |
| `node_version` | string | `18-lts` | Node.js version |
| `subnet_id` | string | — | LZ spoke subnet for VNet Integration |
| `public_network_access_enabled` | bool | `true` | Set `false` for backend |
| `app_settings` | map(string) | `{}` | Extra env vars |
| `application_insights_connection_string` | string (sensitive) | `""` | App Insights connection |

## Outputs

| Name | Description |
|------|-------------|
| `app_id` | Resource ID |
| `app_name` | App name |
| `app_url` | Full HTTPS URL |
| `default_hostname` | Hostname (no scheme) |
| `principal_id` | Managed Identity principal ID |
| `outbound_ip_addresses` | Outbound IPs (for Access Restrictions) |

## Security notes

- HTTPS-only enforced
- TLS 1.2 minimum
- System-assigned Managed Identity (no stored credentials)
- VNet Integration for private outbound traffic
- Logs retained for 7 days
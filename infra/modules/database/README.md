# Module: database

Provisions a PostgreSQL Flexible Server (Burstable tier) with no public access, reachable only through a Private Endpoint in the LZ spoke-data 'pe' subnet.

## What it creates

| Resource | Naming | Purpose |
|----------|--------|---------|
| Flexible Server | `psql-<prefix>-<name>` | PostgreSQL 15 Burstable B1ms |
| Database | `<database_name>` | Application database (`appdb`) |
| Private Endpoint | `pe-<prefix>-pg-<name>` | Private IP in LZ `pe` subnet |
| DNS Zone Group | (attached to PE) | Auto-registers IP in LZ private DNS |

## Design decisions

### Why Private Endpoint (not VNet Integration)?

- **No Project 1 changes** — DataSubnet stays clean
- **PE subnet already exists** in LZ
- **No public IP created** — satisfies LZ `deny-public-ip` Policy
- **Standard enterprise pattern** for PaaS services

### Why Burstable B1ms?

- **~$15/month** (vs ~$60 for General Purpose)
- **Sufficient for demo** (1 vCPU, 2 GB RAM, 32 GB storage)
- **Easily scaled up** in production with a `sku_name` change

### Why no firewall rules?

`public_network_access_enabled = false` blocks **all** public connections. Only the Private Endpoint provides access.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | `main` | Instance suffix |
| `prefix` | string | — | Naming prefix |
| `location` | string | — | Azure region |
| `resource_group_name` | string | — | Target RG |
| `tags` | map(string) | — | Resource tags |
| `admin_username` | string | `pgadmin` | Admin login |
| `sku_name` | string | `B_Standard_B1ms` | SKU |
| `storage_mb` | number | `32768` | Storage (32 GB min) |
| `postgres_version` | string | `15` | PG version |
| `database_name` | string | `appdb` | App DB name |
| `backup_retention_days` | number | `7` | 7–35 days |
| `geo_redundant_backup_enabled` | bool | `false` | Geo backup |
| `private_endpoint_subnet_id` | string | — | LZ `pe` subnet |
| `private_dns_zone_id` | string | — | LZ private DNS zone |

## Outputs

| Name | Sensitive | Description |
|------|-----------|-------------|
| `server_id` | | Resource ID |
| `server_name` | | Server name |
| `fqdn` | | FQDN (resolves privately) |
| `database_name` | | App database name |
| `admin_username` | | Admin login |
| `admin_password` | ✅ | Admin password |
| `private_endpoint_id` | | PE resource ID |
| `private_endpoint_ip` | | PE private IP |

## Security

- 🔒 No public access (`public_network_access_enabled = false`)
- 🔒 Password generated, never hardcoded (`random_password`)
- 🔒 TLS enforced by Azure (PG 15 default)
- 🔒 Accessible only from LZ spoke via Private Endpoint
- 🔒 Backup 7 days (minimum)
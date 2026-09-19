# Azure Services Used in Project 02

This document lists every Microsoft Azure service used in this project, its
purpose, and the approximate cost. It serves as both a portfolio record and
a quick reference for anyone reviewing the project.

---

## Services Inventory

| # | Azure Service | Tier / SKU | Purpose in This Project | Est. Monthly Cost (USD) |
|---|--------------|-----------|------------------------|-------------------------|
| 1 | **Azure App Service (Linux)** × 2 | B1 | Hosts Frontend (React) and Backend (Node.js) | ~$26 |
| 2 | **App Service VNet Integration** | Standard | Allows Backend to reach the database over private network | (included) |
| 3 | **App Service Access Restrictions** | Standard | Restricts Backend inbound to Frontend only | (included) |
| 4 | **Azure Database for PostgreSQL — Flexible Server** | Burstable B1ms | Application database | ~$15 |
| 5 | **Azure Private Endpoint** | Standard | Private inbound access to PostgreSQL | ~$7 |
| 6 | **Azure Private DNS Zone** | — | Resolves PostgreSQL FQDN to private IP (provided by LZ) | (in LZ) |
| 7 | **Azure Key Vault** | Standard | Stores DB connection string & API keys securely | ~$1 |
| 8 | **Azure Managed Identity (System-Assigned)** | — | Lets Backend read secrets from Key Vault without passwords | Free |
| 9 | **Azure RBAC** | — | Grants the Managed Identity "Key Vault Secrets User" role | Free |
| 10 | **Application Insights** | Pay-as-you-go | APM — traces, exceptions, dependencies, live metrics | ~$3 |
| 11 | **Azure Log Analytics Workspace** | Per-GB | Central log store (shared with Landing Zone) | ~$3 |
| 12 | **Azure Monitor Diagnostic Settings** | — | Routes logs from App Service, PostgreSQL, Key Vault to LAW | Free |
| 13 | **Azure Monitor Alert Rules** | — | Fires on HTTP 5xx and slow response time | Free |
| 14 | **Azure Monitor Action Group** | — | Sends alerts via email | Free |
| 15 | **Azure Resource Group** × 2 | — | Containers for workload (workload + data) | Free |
| 16 | **Azure Policy** (inherited from LZ) | — | Enforces region, tags, no public IP | Free |
| | **Total (when running)** | | | **~$55/month** |
| | **Total (after `terraform destroy`)** | | | **~$0/month** |

---

## Services Inherited from the Landing Zone (Project 01)

The following services are NOT deployed by this project — they are provided
by the landing zone and consumed via `terraform_remote_state`:

| Service | Purpose |
|---------|---------|
| Azure Firewall (Basic) | Inspects all spoke egress |
| Azure Bastion (Basic) | Secure SSH access to VMs (for testing) |
| Hub VNet + Peering | Network connectivity |
| Azure Policy (3 rules) | Governance (region, tags, public IP) |
| Log Analytics Workspace | Central log destination |
| Private DNS Zones | Private endpoint resolution |

---

## Why Each Service Was Chosen

| Service | Alternative Considered | Reason for Choice |
|---------|----------------------|-------------------|
| App Service (Linux) | AKS, Container Apps | Simpler for junior portfolio; AKS is overkill |
| PostgreSQL Flexible | MySQL, Azure SQL | Cheapest Burstable tier, modern, open-source |
| Private Endpoint | Service Endpoint | Private Endpoint gives true private IP |
| Key Vault + Managed Identity | App Settings secrets | No secrets in code or config |
| Application Insights | Third-party APM | Native Azure integration, free tier |
| VNet Integration | Public DB access | Security requirement — no public DB |

---

## Cost Optimization Strategy

- **Daily destroy:** `./scripts/destroy.ps1` after work → ~$15/month effective
- **B1 SKU** instead of P1v3 — saves ~$120/month
- **Burstable B1ms** PostgreSQL — sufficient for demo, ~$15 vs ~$60 for GP tier
- **Log Analytics daily cap 1 GB** — prevents ingestion spikes

---

## Region

All resources deployed to **`malaysiawest`** (or `southeastasia` as fallback),
enforced by the landing zone's `allowed-locations` Policy.
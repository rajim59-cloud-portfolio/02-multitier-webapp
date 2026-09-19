# Multi-Tier Production Web App

> A production-grade 3-tier web application deployed on Azure — built on top of a governed landing zone, with private networking, secret management, and end-to-end observability.

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-7B42BC?logo=terraform)](https://www.terraform.io)
[![Azure](https://img.shields.io/badge/Azure-App%20Service-0078D4?logo=microsoftazure)](https://azure.microsoft.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🎯 Problem Statement

A typical junior cloud project deploys an app and stops there. But enterprises ask:

- Is the database reachable from the public internet? → **It must NOT be.**
- Where are the secrets stored? → **Not in code.**
- What happens when the app fails? → **Alerts must fire.**
- How does the app talk to the database securely? → **Over a private network.**

This project answers all four, using a real **3-tier architecture** deployed into a governed Azure landing zone.

---

## 🏗️ Architecture

```
                    [User / Browser]
                           │ HTTPS (443)
                           ▼
              ┌─────────────────────────┐
              │   Azure App Service     │
              │   (Frontend · React)    │
              │   Linux B1 · Public     │
              │   + VNet Integration    │
              └───────────┬─────────────┘
                          │ HTTPS
                          ▼
              ┌─────────────────────────┐
              │   Azure App Service     │
              │   (Backend · Node.js)   │
              │   Linux B1 · Restricted │
              │   + VNet Integration    │
              │   + Managed Identity    │
              └───────────┬─────────────┘
                          │ Private Endpoint
                          ▼
              ┌─────────────────────────┐
              │  PostgreSQL Flexible    │
              │  Server (Burstable)     │
              │  No Public Access       │
              └─────────────────────────┘

   [Key Vault]  ←Managed Identity←  [Backend API]
   [App Insights] ←Telemetry← [Frontend + Backend]
   [Log Analytics] ←Diagnostics← [All resources]
```

> Full diagram & data flow: [docs/architecture.md](docs/architecture.md)

---

## 🔗 How It Connects to the Landing Zone

This project **consumes** outputs from [Project 01 — Landing Zone Foundation](https://github.com/rajim59-cloud-portfolio/01-landing-zone-foundation) via `terraform_remote_state`.

**What the landing zone provides:**

| Output | Purpose |
|--------|---------|
| `spoke_app_app_subnet_id` | Frontend & Backend VNet integration |
| `spoke_data_data_subnet_id` | PostgreSQL deployment |
| `spoke_data_pe_subnet_id` | Private Endpoint |
| `log_analytics_workspace_id` | Central log destination |
| `private_dns_zone_ids` | Private DNS resolution |

**What the landing zone enforces (Policy):**

- ✅ Only `malaysiawest` or `southeastasia` regions allowed
- ✅ `CostCenter`, `Env`, `Owner` tags are mandatory
- ✅ Public IP creation blocked (unless `Env=shared`)

> See [HANDOVER.md](https://github.com/rajim59-cloud-portfolio/01-landing-zone-foundation/blob/main/HANDOVER.md) for the full contract.

---

## 📦 What Gets Deployed

- **Frontend** — Azure App Service (Linux B1), React app, public HTTPS
- **Backend** — Azure App Service (Linux B1), Node.js REST API, restricted inbound
- **Database** — PostgreSQL Flexible Server (Burstable B1ms), Private Endpoint only
- **Secrets** — Azure Key Vault, accessed via Managed Identity
- **Networking** — VNet Integration (outbound), Access Restrictions (inbound)
- **Monitoring** — Application Insights + Log Analytics + Alerts
- **CI/CD** — GitHub Actions (build → test → deploy)

---

## 🚀 Quick Start

### Prerequisites

- Azure subscription with the landing zone deployed
- Terraform >= 1.6
- Azure CLI authenticated (`az login`)
- Node.js 18+ (for local development)

### Deploy

```powershell
# 1. Copy the variables file
cd infra
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — fill in subscription_id, alert_email

# 2. Initialize and deploy
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Destroy (to zero cost)

```powershell
.\scripts\destroy.ps1
```

---

## 📚 Documentation

| File | What's inside |
|------|---------------|
| [docs/architecture.md](docs/architecture.md) | 3-tier diagram, data flow, network path |
| [docs/decisions.md](docs/decisions.md) | Why PostgreSQL, why B1, why VNet Integration |
| [docs/security.md](docs/security.md) | Key Vault, Managed Identity, NSG, Private Endpoint |
| [docs/cost.md](docs/cost.md) | Monthly cost breakdown + optimization |
| [docs/testing.md](docs/testing.md) | 4-level test strategy + results |
| [docs/deployment.md](docs/deployment.md) | Step-by-step deployment guide |
| [AZURE-SERVICES.md](AZURE-SERVICES.md) | All Azure services used + cost |

---

## 💰 Cost

| Resource | SKU | Est. Monthly |
|----------|-----|--------------|
| App Service Plan (Frontend + Backend) | B1 Linux | ~$26 |
| PostgreSQL Flexible Server | Burstable B1ms | ~$15 |
| Key Vault | Standard | ~$1 |
| Private Endpoint | 1 endpoint | ~$7 |
| Application Insights | Pay-as-you-go | ~$3 |
| Log Analytics ingestion | ~1 GB/day | ~$3 |
| **Total (running)** | | **~$55/month** |
| **Total (daily destroy)** | | **~$15/month** |

> See [docs/cost.md](docs/cost.md) for details.

---

## 🔒 Security Highlights

- **No public database access** — Private Endpoint only
- **No secrets in code** — Key Vault + Managed Identity
- **No public backend** — Access Restrictions to frontend only
- **API Key authentication** on all backend routes
- **Diagnostic logs** flowing to central Log Analytics
- **Alerts** on HTTP 5xx and slow response times

---

## 🧪 Testing Strategy

This project uses a **4-level test pyramid**:

1. **Static Analysis** — `terraform fmt`, `validate`, `tflint`, `checkov`
2. **Unit Tests** — Jest (frontend), Mocha/Chai (backend)
3. **Integration Tests** — Postman/Newman + live DB connection
4. **End-to-End Tests** — Playwright user-flow simulation

> See [docs/testing.md](docs/testing.md) for the full strategy and results.

---

## 📄 License

[MIT](LICENSE)
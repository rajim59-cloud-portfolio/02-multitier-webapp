02-multitier-webapp/
│
├── README.md                              # প্রজেক্টের প্রথম ইমপ্রেশন — সমস্যা, আর্কিটেকচার, সেটআপ, ডেমো
├── LICENSE                                # MIT License
├── .gitignore                             # tfstate, tfvars, secrets, node_modules
├── AZURE-SERVICES.md                      # Project-এ ব্যবহৃত সব Azure সার্ভিসের তালিকা + খরচ
│
├── .github/                               # GitHub-নির্দিষ্ট কনফিগ
│   ├── workflows/
│   │   ├── ci-build-test.yml              # PR-এ unit + integration টেস্ট
│   │   ├── cd-deploy.yml                  # main-এ deploy (staging → prod gate)
│   │   └── security-scan.yml              # Checkov/tfsec স্ক্যান
│   └── PULL_REQUEST_TEMPLATE.md           # PR চেকলিস্ট (ট্যাগ, রিজিয়ন, সিকিউরিটি)
│
├── infra/                                 # সব Terraform কোড
│   ├── versions.tf                        # Terraform ও provider ভার্সন পিন
│   ├── providers.tf                       # azurerm provider কনফিগ
│   ├── backend.tf                         # Remote state (Azure Storage)
│   ├── data.tf                            # Project 1-এর remote state পড়া
│   ├── main.tf                            # রুট মডিউল — সব module কল
│   ├── variables.tf                       # ইনপুট ভেরিয়েবল
│   ├── outputs.tf                         # আউটপুট (app URL, DB FQDN)
│   ├── terraform.tfvars.example           # ভেরিয়েবলের উদাহরণ
│   │
│   └── modules/                           # রিইউজেবল মডিউল
│       ├── app-service/                   # Frontend + Backend Web App
│       │   ├── main.tf                    # App Service Plan, Linux Web App ×2
│       │   ├── variables.tf               # SKU, location, subnet_id
│       │   ├── outputs.tf                 # app URLs, principal_id
│       │   └── README.md                  # মডিউলের ডকুমেন্ট
│       │
│       ├── database/                      # PostgreSQL Flexible Server
│       │   ├── main.tf                    # Server, Database, Private Endpoint
│       │   ├── variables.tf               # admin user, sku, subnet
│       │   ├── outputs.tf                 # FQDN, connection info
│       │   └── README.md
│       │
│       ├── keyvault/                      # Key Vault + Managed Identity
│       │   ├── main.tf                    # Key Vault, Secrets, RBAC
│       │   ├── variables.tf
│       │   ├── outputs.tf                 # vault_uri, secret_ids
│       │   └── README.md
│       │
│       └── monitoring/                    # App Insights + Alerts
│           ├── main.tf                    # App Insights, Diagnostic Settings, Alerts
│           ├── variables.tf
│           ├── outputs.tf                 # appi_connection_string, id
│           ├── queries/                   # KQL ফাইল
│           │   ├── http-5xx-trend.kql     # HTTP 5xx ট্রেন্ড
│           │   └── slow-api-calls.kql     # স্লো API কুয়েরি
│           └── README.md
│
├── src/                                   # অ্যাপ্লিকেশন কোড
│   ├── frontend/                          # React Frontend
│   │   ├── package.json                   # ডিপেন্ডেন্সি
│   │   ├── Dockerfile                     # কন্টেইনার (ঐচ্ছিক)
│   │   ├── .env.example                   # API URL example
│   │   ├── public/
│   │   │   └── index.html
│   │   └── src/
│   │       ├── App.js                     # মূল কম্পোনেন্ট
│   │       ├── App.css
│   │       ├── index.js
│   │       ├── api/
│   │       │   └── apiClient.js           # Backend API কল
│   │       └── components/
│   │           ├── StudentList.js         # উদাহরণ: স্টুডেন্ট লিস্ট
│   │           └── StudentForm.js         # স্টুডেন্ট অ্যাড ফর্ম
│   │
│   └── backend/                           # Node.js API
│       ├── package.json
│       ├── .env.example
│       ├── server.js                      # Express server bootstrap
│       ├── routes/
│       │   ├── health.js                  # /health endpoint
│       │   └── students.js                # /api/students CRUD
│       ├── controllers/
│       │   └── studentController.js
│       ├── models/
│       │   └── studentModel.js            # PostgreSQL queries
│       ├── middleware/
│       │   ├── auth.js                    # API Key check
│       │   └── errorHandler.js
│       └── db/
│           ├── connection.js              # PostgreSQL connection pool
│           └── migrate.js                 # Migration রান
│
├── tests/                                 # সব টেস্ট
│   ├── unit/
│   │   ├── frontend/
│   │   │   └── App.test.js                # Jest
│   │   └── backend/
│   │       └── studentController.test.js  # Mocha/Chai
│   │
│   ├── integration/
│   │   ├── api-tests/
│   │   │   ├── students.postman_collection.json
│   │   │   └── run-tests.sh               # Newman রানার
│   │   └── db-tests/
│   │       └── connection.test.js         # DB connection টেস্ট
│   │
│   ├── e2e/
│   │   └── user-flow.spec.js              # Playwright/Selenium
│   │
│   └── test-cases.md                      # ১২টি টেস্ট কেস ডকুমেন্টেড
│
├── scripts/                               # Windows PowerShell স্ক্রিপ্ট
│   ├── bootstrap.ps1                      # Backend storage সেটআপ
│   ├── destroy.ps1                        # Cleanup
│   ├── validate-tags.ps1                  # ট্যাগ ভ্যালিডেশন
│   └── run-tests.ps1                      # সব টেস্ট একসাথে চালানো
│
└── docs/                                  # সব ডকুমেন্টেশন
    ├── architecture.md                    # 3-টিয়ার ডায়াগ্রাম, ডেটা ফ্লো
    ├── decisions.md                       # ADR: কেন PostgreSQL, কেন B1
    ├── security.md                        # Key Vault, Managed Identity, NSG
    ├── cost.md                            # মাসিক খরচ, অপ্টিমাইজেশন
    ├── testing.md                         # ৪ স্তরের টেস্ট রেজাল্ট
    ├── deployment.md                      # ডিপ্লয় গাইড
    └── screenshots/
        ├── app-live.png
        ├── api-swagger.png
        ├── db-private-endpoint.png
        ├── keyvault-secrets.png
        ├── appinsights-dashboard.png
        └── alert-triggered.png
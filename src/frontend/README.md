# Frontend — Multi-Tier Web App

React + Vite frontend for the Student Management demo.

## Prerequisites

- Node.js 18+
- npm 9+

## Local development

```bash
# Install dependencies
npm install

# Copy env file
Copy-Item .env.example .env.local     # PowerShell
# cp .env.example .env.local          # Bash

# Run dev server (http://localhost:3000)
npm run dev
```

The dev server proxies `/api/*` calls to `VITE_API_URL` (default: `http://localhost:5000`).

## Build for production

```bash
npm run build
```

Produces a `dist/` folder. This is what gets deployed to Azure App Service.

## Lint

```bash
npm run lint
```

## Project structure

```
src/
├── main.jsx              # React entry
├── App.jsx               # Root component
├── App.css               # App styles
├── index.css             # Global styles
└── (future) api/         # API client (Day 3)
└── (future) components/  # UI components (Day 3)
```

## Environment variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `VITE_API_URL` | Backend base URL | `http://localhost:5000` |

Only variables prefixed with `VITE_` are exposed to the browser.
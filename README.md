# Twenty CRM — $0 Demo (UPT)

Self-hosted [Twenty CRM](https://github.com/twentyhq/twenty) demo for UPT. **Total cost: $0** on free tiers.

| Component | Provider | Cost |
|-----------|----------|------|
| App (server + worker) | [Render](https://render.com) Free | $0 (750 hrs/mo, cold start after 15 min idle) |
| PostgreSQL | [Supabase](https://supabase.com) Free | $0 (500 MB) |
| Redis | [Upstash](https://upstash.com) Free | $0 (10k cmds/day) |
| Code | [GitHub](https://github.com/sakshisardeupt/twentycrm) | $0 |

> **Why not Vercel?** Twenty needs a long-running server + worker + Redis. Vercel is serverless and cannot run this stack. Render Free is the closest $0 alternative with GitHub auto-deploy.

## Auth setup (run these in PowerShell)

### 1. GitHub — `sakshisardeupt`

```powershell
gh auth login
gh auth switch --user sakshisardeupt
gh auth status
```

### 2. Supabase — free Postgres

```powershell
supabase login
supabase projects create twentycrm-demo --org YOUR_ORG_ID --region ap-south-1 --db-password "PickAStrongPassword123"
```

Then copy **Project Settings → Database → Connection string (URI)**. Use **Session pooler** (port 5432) or **Direct**. Append `?sslmode=require` if not present.

### 3. Upstash — free Redis (~1 min, browser)

1. [console.upstash.com](https://console.upstash.com) → sign up (free)
2. **Create database** → copy **Redis URL** (`rediss://...`)

### 4. Render — free hosting (~2 min, browser)

1. [dashboard.render.com/register](https://dashboard.render.com/register) → sign up with GitHub **`sakshisardeupt`**
2. After repo is pushed: **New → Blueprint** → select `sakshisardeupt/twentycrm`
3. Paste env vars when prompted (see below)

No credit card required on Render until you exceed free limits.

## Environment variables (Render)

| Variable | Value |
|----------|--------|
| `PG_DATABASE_URL` | Supabase connection URI |
| `REDIS_URL` | Upstash Redis URL |
| `ENCRYPTION_KEY` | Run `.\scripts\generate-secrets.ps1` |
| `SERVER_URL` | `https://twenty-demo.onrender.com` (your Render URL — update after first deploy) |

## Deploy

After auth, tell the agent **"ready"** — it will push the repo and guide Render setup.

Or manually:

```powershell
git add .
git commit -m "Twenty CRM $0 demo on Render + Supabase + Upstash"
git push -u origin main
```

Then connect the repo as a Render Blueprint.

## First visit

1. Open your Render URL (first load may take ~1 min if the service was asleep).
2. Sign up — first user becomes admin.
3. Demo only: uploads are lost on redeploy (no persistent disk on Free).

## Local test (optional)

```powershell
copy .env.example .env
# fill PG_DATABASE_URL, REDIS_URL, ENCRYPTION_KEY
docker compose -f docker-compose.external.yml up
```

Open http://localhost:3000

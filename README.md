# Twenty CRM — $0 Demo (UPT)

Self-hosted [Twenty CRM](https://github.com/twentyhq/twenty) demo for UPT. **Total cost: $0** on free tiers.

| Component | Provider | Cost |
|-----------|----------|------|
| App (server + worker) | [Render](https://render.com) Free | $0 (750 hrs/mo, cold start after 15 min idle) |
| PostgreSQL | [Supabase](https://supabase.com) Free | $0 (500 MB) |
| Redis | [Upstash](https://upstash.com) Free | $0 (10k cmds/day) |
| Code | [GitHub](https://github.com/sakshisardeupt/twentycrm) | $0 |

> **Why not Vercel?** Twenty needs a long-running server + worker + Redis. Vercel is serverless and cannot run this stack. Render Free is the closest $0 alternative with GitHub auto-deploy.

## Environment variables (Render)

| Variable | Value |
|----------|--------|
| `PG_DATABASE_URL` | Supabase connection URI |
| `REDIS_URL` | Upstash Redis URL |
| `ENCRYPTION_KEY` | Run `.\scripts\generate-secrets.ps1` |
| `SERVER_URL` | Your Render web service URL |

## First visit

1. Open your Render URL (first load may take ~1 min if the service was asleep).
2. Sign up — first user becomes admin.
3. Demo only: uploads are lost on redeploy (no persistent disk on Free).

## Local test (optional)

```powershell
copy .env.example .env
docker compose -f docker-compose.external.yml up
```

Open http://localhost:3000

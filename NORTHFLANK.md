# Twenty CRM — $0 demo hosting (Northflank)

**Render Free (512MB) cannot run Twenty** — the server OOMs on startup even with migrations disabled.

Use **Northflank Developer Sandbox** (free, ~1GB+ RAM selectable, always-on):

## Setup (~10 min)

1. Sign up: [northflank.com](https://northflank.com) → GitHub → `sakshisardeupt`
2. **Create project** → **Add service** → **External image**
3. Image: `twentycrm/twenty:latest`
4. **Build** tab → use repo Dockerfile OR override start command: `sh /app/start-demo.sh`
5. **Resources**: set **1 GB RAM** minimum (Sandbox free allowance)
6. **Port**: 3000, public HTTP
7. **Environment variables**:

| Variable | Value |
|----------|--------|
| `PG_DATABASE_URL` | Session pooler URL (for app runtime) |
| `PG_SSL_ALLOW_SELF_SIGNED` | `true` |
| `REDIS_URL` | Upstash URL |
| `ENCRYPTION_KEY` | your key |
| `SERVER_URL` | Northflank service URL |
| `DISABLE_DB_MIGRATIONS` | `true` |
| `DISABLE_CRON_JOBS_REGISTRATION` | `true` |
| `NODE_OPTIONS` | `--max-old-space-size=768` |

8. Deploy → open URL → sign up

## Database

Migrations already run via GitHub Actions. App uses **session pooler** URL:

```
postgresql://postgres.zqaiuqnynmchvmmfqunx:PASSWORD@aws-0-ap-northeast-2.pooler.supabase.com:5432/postgres
```

(No `?sslmode=` — use `PG_SSL_ALLOW_SELF_SIGNED=true`)

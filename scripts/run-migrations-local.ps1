# Run Twenty DB migrations from your PC (more RAM than Render Free 512MB).
# Usage:
#   .\scripts\run-migrations-local.ps1 -PgDatabaseUrl "postgresql://postgres.ref:pass@aws-0-ap-northeast-2.pooler.supabase.com:5432/postgres"
#   .\scripts\run-migrations-local.ps1 -PgDatabaseUrl "..." -RedisUrl "rediss://..."

param(
    [Parameter(Mandatory = $true)]
    [string]$PgDatabaseUrl,

    [Parameter(Mandatory = $true)]
    [string]$RedisUrl,

    [string]$EncryptionKey = "TzoI14A3N7f3CpyPSxSv0os2J8iduGxvcpQmvQyABg8="
)

Write-Host "Running migrations locally (this may take 5-10 minutes)..." -ForegroundColor Cyan

docker run --rm `
    -e PG_DATABASE_URL=$PgDatabaseUrl `
    -e PG_SSL_ALLOW_SELF_SIGNED=true `
    -e REDIS_URL=$RedisUrl `
    -e ENCRYPTION_KEY=$EncryptionKey `
    -e SERVER_URL=http://localhost:3000 `
    -e NODE_OPTIONS="--max-old-space-size=4096" `
    twentycrm/twenty:latest `
    sh -c "echo Migrations finished"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done. Set DISABLE_DB_MIGRATIONS=true on Render and redeploy." -ForegroundColor Green
} else {
    Write-Host "Migration failed. Check output above." -ForegroundColor Red
    exit 1
}

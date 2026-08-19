#!/bin/sh
set -e

# Background worker — migrations/cron registration run on the main server process
DISABLE_DB_MIGRATIONS=true DISABLE_CRON_JOBS_REGISTRATION=true yarn worker:prod &

exec node dist/main

#!/bin/sh
set -e

# Render Free = 512MB RAM. Skip worker to leave memory for the server.
# Background jobs won't run; CRM UI works fine for demo.
# DISABLE_DB_MIGRATIONS=true DISABLE_CRON_JOBS_REGISTRATION=true yarn worker:prod &

exec node dist/main

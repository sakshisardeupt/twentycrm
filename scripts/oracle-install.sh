#!/bin/bash
# Twenty CRM — Oracle Cloud Always Free VM installer
# Run as ubuntu user on a fresh Ubuntu 22.04/24.04 ARM instance:
#
#   curl -fsSL https://raw.githubusercontent.com/sakshisardeupt/twentycrm/main/scripts/oracle-install.sh | bash
#
# Or with env vars (recommended):
#   PG_DATABASE_URL='postgresql://...' \
#   REDIS_URL='rediss://...' \
#   ENCRYPTION_KEY='...' \
#   SERVER_URL='http://YOUR_PUBLIC_IP:3000' \
#   bash oracle-install.sh

set -euo pipefail

REPO_DIR="${HOME}/twentycrm"
REPO_URL="https://github.com/sakshisardeupt/twentycrm.git"

echo "==> Installing Docker..."
sudo apt-get update -qq
sudo apt-get install -y -qq ca-certificates curl git
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -qq
sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker "$USER" || true

echo "==> Cloning deployment repo..."
if [ -d "$REPO_DIR" ]; then
  cd "$REPO_DIR" && git pull
else
  git clone "$REPO_URL" "$REPO_DIR"
  cd "$REPO_DIR"
fi

PUBLIC_IP=$(curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/opc/v1/instance/metadata/publicIp 2>/dev/null || curl -s ifconfig.me || echo "localhost")

: "${PG_DATABASE_URL:?Set PG_DATABASE_URL}"
: "${REDIS_URL:?Set REDIS_URL}"
: "${ENCRYPTION_KEY:?Set ENCRYPTION_KEY}"
: "${SERVER_URL:=http://${PUBLIC_IP}:3000}"

cat > .env <<EOF
TAG=latest
SERVER_URL=${SERVER_URL}
PG_DATABASE_URL=${PG_DATABASE_URL}
PG_SSL_ALLOW_SELF_SIGNED=true
REDIS_URL=${REDIS_URL}
ENCRYPTION_KEY=${ENCRYPTION_KEY}
STORAGE_TYPE=local
EOF

echo "==> Starting Twenty CRM (server + worker)..."
sudo docker compose -f docker-compose.external.yml up -d

echo ""
echo "==> Done! Open: ${SERVER_URL}"
echo "    First visit: create your admin account."
echo ""
echo "    Ensure Oracle Security List allows TCP port 3000 inbound."

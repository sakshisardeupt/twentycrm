# Twenty CRM on Oracle Cloud Always Free ($0)

Oracle gives a **free ARM VM with up to 24GB RAM** — enough for Twenty + Docker.

I **cannot control your browser** for signup or VM creation. You do **Part 1** (~15 min); then paste your **public IP** and I run **Part 2** over SSH from the terminal.

---

## Part 1 — You do in browser (one time)

### 1. Create Oracle Cloud account

1. [cloud.oracle.com/free](https://www.oracle.com/cloud/free/) → **Start for free**
2. Complete signup (email + phone verification; card for verification, Always Free resources stay $0)

### 2. Create a VM

1. Menu → **Compute** → **Instances** → **Create instance**
2. Settings:
   - **Name:** `twenty-crm`
   - **Image:** Ubuntu 24.04 (aarch64)
   - **Shape:** **Ampere** → `VM.Standard.A1.Flex` → **1 OCPU, 6 GB RAM** (still free tier)
   - **Boot volume:** 50 GB default is fine
   - **Networking:** assign **public IPv4**
   - **SSH keys:** **Generate a key pair** → download private key (`twenty-crm.key`)
3. **Create**

### 3. Open firewall port 3000

1. Instance page → **Subnet** link → **Default Security List**
2. **Add Ingress Rules:**
   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: TCP
   - Destination port: `3000`
   - Description: `Twenty CRM`
3. Save

### 4. Copy your public IP

On the instance page, copy **Public IP address** (e.g. `129.146.xxx.xxx`).

### 5. Reply here with:

```
PUBLIC_IP=129.146.xxx.xxx
```

And place the SSH key at: `E:\upt\twentycrm\twenty-crm.key`  
(or tell me the path). **Do not paste the key in chat** — save the file locally.

---

## Part 2 — I run via SSH (after you send IP + key file)

From your machine I will:

1. SSH into the VM
2. Run the install script (Docker + Twenty + worker)
3. Point `SERVER_URL` at `http://YOUR_IP:3000`
4. Confirm health check and send you the live URL

---

## One-liner (if you prefer to SSH yourself)

```bash
ssh -i twenty-crm.key ubuntu@YOUR_PUBLIC_IP
```

Then on the VM:

```bash
PG_DATABASE_URL='postgresql://postgres.zqaiuqnynmchvmmfqunx:PASSWORD@aws-0-ap-northeast-2.pooler.supabase.com:5432/postgres' \
REDIS_URL='rediss://default:PASSWORD@grateful-penguin-149221.upstash.io:6379' \
ENCRYPTION_KEY='TzoI14A3N7f3CpyPSxSv0os2J8iduGxvcpQmvQyABg8=' \
SERVER_URL='http://YOUR_PUBLIC_IP:3000' \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sakshisardeupt/twentycrm/main/scripts/oracle-install.sh)"
```

Replace `PASSWORD` / `YOUR_PUBLIC_IP` with your values.

---

## HTTPS (optional later)

For a proper domain + SSL, add Caddy or Nginx + Let’s Encrypt after the demo works on `:3000`.

---

## Before deploy: fix database migrations

The last GitHub migration run **failed**. We need a green migration before the app starts. I’ll re-run that once Oracle VM is ready, or migrations will run on first boot if the DB is empty (VM has enough RAM).

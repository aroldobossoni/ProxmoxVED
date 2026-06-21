# Testing Alpine-OpenSpeedTest on Proxmox

## Install (fork branch)

```bash
COMMUNITY_SCRIPTS_URL=https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest/ct/alpine-openspeedtest.sh)"
```

`COMMUNITY_SCRIPTS_URL` is required while testing from a fork branch so `build.func` loads `install/alpine-openspeedtest-install.sh` from your fork.

## Verify

1. Open `http://<LXC_IP>:3000` — speed test UI loads.
2. Run a download/upload test.
3. Optional: `https://<LXC_IP>:3001` — self-signed HTTPS.

## Update

```bash
COMMUNITY_SCRIPTS_URL=https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest/ct/alpine-openspeedtest.sh)"
```

Select update when prompted, or use `/usr/bin/update` inside the container after promotion to ProxmoxVE.

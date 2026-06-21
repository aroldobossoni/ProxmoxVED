# Testing Alpine-OpenSpeedTest on Proxmox

## Install (fork branch)

```bash
# Limpe job suspenso (Ctrl+Z) se existir: kill %1

var_ns=8.8.8.8 \
COMMUNITY_SCRIPTS_URL=https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest/ct/alpine-openspeedtest.sh)"
```

`COMMUNITY_SCRIPTS_URL` must point to your fork branch so `build.func` (with Alpine DNS fix) and `install/alpine-openspeedtest-install.sh` load from the same place.

## Verify

1. Open `http://<LXC_IP>:3000` — speed test UI loads.
2. Run a download/upload test.
3. Optional: `https://<LXC_IP>:3001` — self-signed HTTPS.

## Update

Run the CT script again and choose an option from the menu:

- **Update Alpine Packages**
- **Update OpenSpeedTest Application**
- **Renew Self-signed Certificate**

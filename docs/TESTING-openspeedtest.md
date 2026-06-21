# Testing OpenSpeedTest on Proxmox

## Prerequisites

1. Fork [ProxmoxVED](https://github.com/community-scripts/ProxmoxVED) on GitHub.
2. Push branch `feat/openspeedtest` to your fork.
3. Run `bash docs/contribution/setup-fork.sh --full` on the fork **once** before testing (on Linux/Proxmox).

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/ProxmoxVED/feat/openspeedtest/ct/openspeedtest.sh)"
```

## Verify

1. Open `http://<LXC_IP>:3000` — speed test UI loads.
2. Run a download/upload test — results should appear without CORS or 405 errors.
3. Optional: `https://<LXC_IP>:3001` — accept self-signed certificate warning.

## Update

Inside the LXC or from Proxmox host update flow:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/ProxmoxVED/feat/openspeedtest/ct/openspeedtest.sh)"
```

Select update when prompted, or use the container `/usr/bin/update` helper after promotion to ProxmoxVE.

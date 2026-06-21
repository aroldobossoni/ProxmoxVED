# Testing OpenSpeedTest on Proxmox

## Prerequisites

1. Fork [ProxmoxVED](https://github.com/community-scripts/ProxmoxVED) on GitHub.
2. Push branch `feat/openspeedtest` to your fork.
3. Run `bash docs/contribution/setup-fork.sh --full` on the fork **once** before testing (on Linux/Proxmox).

## Install

```bash
COMMUNITY_SCRIPTS_URL=https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest/ct/openspeedtest.sh)"
```

`COMMUNITY_SCRIPTS_URL` is required while testing from a fork branch so `build.func` loads `install/openspeedtest-install.sh` from your fork, not from upstream `main`.

## Verify

1. Open `http://<LXC_IP>:3000` — speed test UI loads.
2. Run a download/upload test — results should appear without CORS or 405 errors.
3. Optional: `https://<LXC_IP>:3001` — accept self-signed certificate warning.

## Update

Inside the LXC or from Proxmox host update flow:

```bash
COMMUNITY_SCRIPTS_URL=https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/aroldobossoni/ProxmoxVED/feat/openspeedtest/ct/openspeedtest.sh)"
```

`COMMUNITY_SCRIPTS_URL` is required while testing from a fork branch so `build.func` loads `install/openspeedtest-install.sh` from your fork, not from upstream `main`.

Select update when prompted, or use the container `/usr/bin/update` helper after promotion to ProxmoxVE.

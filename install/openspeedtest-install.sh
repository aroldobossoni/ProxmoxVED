#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: aroldobossoni (aroldobossoni)
# License: MIT | https://github.com/community-scripts/ProxmoxVED/raw/main/LICENSE
# Source: https://openspeedtest.com/selfhosted-speedtest | https://github.com/openspeedtest/Docker-Image

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apk add --no-cache nginx
msg_ok "Installed Dependencies"

fetch_and_deploy_gh_release "openspeedtest" "openspeedtest/Docker-Image" "tarball" "latest" "/opt/openspeedtest"

msg_info "Setting up OpenSpeedTest"
mkdir -p /opt/openspeedtest/www /etc/ssl
cp -a /opt/openspeedtest/files/www/. /opt/openspeedtest/www/
cp /opt/openspeedtest/files/nginx.crt /opt/openspeedtest/files/nginx.key /etc/ssl/
chmod 755 /opt/openspeedtest/www/downloading /opt/openspeedtest/www/upload 2>/dev/null || true
chown -R nginx:nginx /opt/openspeedtest/www
rm -f /etc/nginx/http.d/default.conf
sed \
  -e 's|root /usr/share/nginx/html/|root /opt/openspeedtest/www/|g' \
  /opt/openspeedtest/files/OpenSpeedTest-Server.conf >/etc/nginx/http.d/openspeedtest.conf
$STD rc-update add nginx default
$STD rc-service nginx start
msg_ok "Set up OpenSpeedTest"

motd_ssh
customize

msg_info "Cleaning up"
$STD apk cache clean
msg_ok "Cleaned"

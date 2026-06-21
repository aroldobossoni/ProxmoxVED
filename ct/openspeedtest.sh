#!/usr/bin/env bash
source <(curl -fsSL "${COMMUNITY_SCRIPTS_URL:-https://raw.githubusercontent.com/community-scripts/ProxmoxVED/main}/misc/build.func")
# Copyright (c) 2021-2026 community-scripts ORG
# Author: aroldobossoni (aroldobossoni)
# License: MIT | https://github.com/community-scripts/ProxmoxVED/raw/main/LICENSE
# Source: https://openspeedtest.com/selfhosted-speedtest | https://github.com/openspeedtest/Docker-Image

APP="OpenSpeedTest"
var_tags="${var_tags:-network;speedtest}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-2}"
var_os="${var_os:-alpine}"
var_version="${var_version:-3.21}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function configure_openspeedtest() {
  mkdir -p /opt/openspeedtest/www /etc/ssl
  rm -rf /opt/openspeedtest/www/*
  cp -a /opt/openspeedtest/files/www/. /opt/openspeedtest/www/
  cp /opt/openspeedtest/files/nginx.crt /opt/openspeedtest/files/nginx.key /etc/ssl/
  chmod 755 /opt/openspeedtest/www/downloading /opt/openspeedtest/www/upload 2>/dev/null || true
  chown -R nginx:nginx /opt/openspeedtest/www
  rm -f /etc/nginx/http.d/default.conf
  sed \
    -e 's|root /usr/share/nginx/html/|root /opt/openspeedtest/www/|g' \
    /opt/openspeedtest/files/OpenSpeedTest-Server.conf >/etc/nginx/http.d/openspeedtest.conf
}

function update_script() {
  header_info
  check_container_resources

  if [[ ! -d /opt/openspeedtest/files ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  if check_for_gh_release "openspeedtest" "openspeedtest/Docker-Image"; then
    msg_info "Stopping Service"
    $STD rc-service nginx stop
    msg_ok "Stopped Service"

    CLEAN_INSTALL=1 fetch_and_deploy_gh_release "openspeedtest" "openspeedtest/Docker-Image" "tarball" "latest" "/opt/openspeedtest"

    msg_info "Configuring ${APP}"
    configure_openspeedtest
    msg_ok "Configured ${APP}"

    msg_info "Starting Service"
    $STD rc-service nginx start
    msg_ok "Started Service"
    msg_ok "Updated successfully!"
  fi
  exit 0
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URLs:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"
echo -e "${TAB}${GATEWAY}${BGN}https://${IP}:3001${CL} ${YW}(self-signed certificate)${CL}"

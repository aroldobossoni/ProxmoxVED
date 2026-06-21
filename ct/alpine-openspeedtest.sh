#!/usr/bin/env bash
source <(curl -fsSL "${COMMUNITY_SCRIPTS_URL:-https://raw.githubusercontent.com/community-scripts/ProxmoxVED/main}/misc/build.func")
# Copyright (c) 2021-2026 community-scripts ORG
# Author: aroldobossoni (aroldobossoni)
# License: MIT | https://github.com/community-scripts/ProxmoxVED/raw/main/LICENSE
# Source: https://openspeedtest.com/selfhosted-speedtest | https://github.com/openspeedtest/Docker-Image

APP="Alpine-OpenSpeedTest"
var_tags="${var_tags:-alpine;network}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-2}"
var_os="${var_os:-alpine}"
var_version="${var_version:-3.23}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  if [[ ! -d /opt/openspeedtest/files ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  CHOICE=$(msg_menu "OpenSpeedTest Options" \
    "1" "Update Alpine Packages" \
    "2" "Update OpenSpeedTest Application" \
    "3" "Renew Self-signed Certificate")

  case $CHOICE in
  1)
    msg_info "Updating Alpine Packages"
    $STD apk -U upgrade
    msg_ok "Updated Alpine Packages"
    msg_ok "Updated successfully!"
    exit
    ;;
  2)
    if check_for_gh_release "openspeedtest" "openspeedtest/Docker-Image"; then
      msg_info "Stopping Service"
      $STD rc-service nginx stop
      msg_ok "Stopped Service"

      CLEAN_INSTALL=1 fetch_and_deploy_gh_release "openspeedtest" "openspeedtest/Docker-Image" "tarball" "latest" "/opt/openspeedtest"

      msg_info "Configuring ${APP}"
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
      msg_ok "Configured ${APP}"

      msg_info "Starting Service"
      $STD rc-service nginx start
      msg_ok "Started Service"
      msg_ok "Updated successfully!"
    fi
    exit
    ;;
  3)
    cp /opt/openspeedtest/files/nginx.crt /opt/openspeedtest/files/nginx.key /etc/ssl/
    $STD rc-service nginx restart
    msg_ok "Renewed self-signed certificate"
    exit
    ;;
  esac
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${APP} should be reachable by going to the following URLs.
         ${BL}http://${IP}:3000${CL}
         ${BL}https://${IP}:3001${CL} (self-signed)\n"

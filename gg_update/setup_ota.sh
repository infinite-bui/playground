#!/bin/bash

function check_root_user() {
  if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo/root permissions"
    exit
  fi
}

function copy_scripts() {
  mkdir /greengrass/usr/
  cp -r scripts/ /greengrass/usr/
  chmod +x /greengrass/usr/scripts/*
}

function update_config() {
  apt install -y jq
  jq '.managedRespawn = $newVal' --arg newVal 'true' /greengrass/config/config.json > /tmp/tmp.json && mv /tmp/tmp.json /greengrass/config/config.json
}

echo "====COPYING SCRIPTS===="
check_root_user
copy_scripts
echo "====UPDATING CONFIG===="
update_config

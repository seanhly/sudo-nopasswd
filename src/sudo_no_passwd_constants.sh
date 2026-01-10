#!/bin/bash
ETC_FILE="/etc/sudo-nopasswd"
SUDOERS_FILE="/etc/sudoers"
SUDOERS_BAK="/etc/sudoers.bak"
BEFORE_COMMANDS="/tmp/sudo-nopasswd-before"
AFTER_COMMANDS="/tmp/sudo-nopasswd-after"
SCRIPT_NAME="update-sudo-nopasswd"

# Installation paths
BIN_DIR="/usr/bin"
SERVICE_FILE="sudo-nopasswd.service"
INIT_FILE="sudo-nopasswd.init"
SYSTEMD_DIR="/etc/systemd/system"
INITD_DIR="/etc/init.d"

UPDATE_COMMAND="update-sudo-nopasswd"
WATCH_COMMAND="watch-sudo-nopasswd"

SHARE_DIR="/usr/share/sudo-nopasswd"
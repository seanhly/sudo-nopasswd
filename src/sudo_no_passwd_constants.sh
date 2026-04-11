#!/bin/bash
if [ ! "$INSTANCE" ]; then
	INSTANCE="$(head -c10 /dev/urandom | base32)"
fi
ETC_FILE="/etc/sudo-nopasswd"
SUDOERS_FILE="/etc/sudoers"
SUDOERS_BAK="/etc/sudoers.bak_$INSTANCE"
BEFORE_COMMANDS="/tmp/sudo-nopasswd-before-$INSTANCE"
AFTER_COMMANDS="/tmp/sudo-nopasswd-after-$INSTANCE"
SCRIPT_NAME="update-sudo-nopasswd"

# Installation paths
BIN_DIR="/usr/bin"
SERVICE_FILE="sudo-nopasswd.service"
INIT_FILE="sudo-nopasswd.init"
SYSTEMD_DIR="/etc/systemd/system"
INITD_DIR="/etc/init.d"

UPDATE_COMMAND="update-sudo-nopasswd"
WATCH_COMMAND="watch-sudo-nopasswd"

#!/bin/bash
set -e
[ "$EUID" -eq 0 ] || { echo "Please run as root"; exit 1; }
SHARE_DIR="/usr/share/sudo-nopasswd"
CONSTANTS="sudo_no_passwd_constants.sh"
source "$SHARE_DIR/$CONSTANTS"
[ -f "$ETC_FILE" ] || touch "$ETC_FILE"
if command -v systemctl >/dev/null 2>&1; then
    systemctl enable "$SERVICE_FILE"
    if [ -d /run/systemd/system ]; then
        systemctl daemon-reload
        systemctl start "$SERVICE_FILE"
    fi
elif command -v rc-update >/dev/null 2>&1; then
    chmod +x "$INITD_DIR/$INIT_FILE"
    rc-update add "$INIT_FILE" default
    rc-service "$INIT_FILE" start
else
    echo "Unsupported init system."
fi
#!/bin/bash
set -e
SHARE_DIR="/usr/share/sudo-nopasswd"
[ -e "$SHARE_DIR" ] || { echo "sudo-nopasswd is not installed."; exit 1; }
source "$SHARE_DIR/sudo_no_passwd_constants.sh"
[ "$EUID" -eq 0 ] || { sudo "$0" "$@"; exit $?; }
if command -v systemctl >/dev/null 2>&1; then
    systemctl stop "$SERVICE_FILE" 2>/dev/null || true
    systemctl disable "$SERVICE_FILE" 2>/dev/null || true
    rm -f "$SYSTEMD_DIR/$SERVICE_FILE"
    systemctl daemon-reload
elif command -v rc-update >/dev/null 2>&1; then
    rc-service "$INIT_FILE" stop 2>/dev/null || true
    rc-update del "$INIT_FILE" 2>/dev/null || true
    rm -f "$INITD_DIR/$INIT_FILE"
else
    echo "Unsupported init system."
fi
rm -f "$BIN_DIR/$UPDATE_COMMAND"
rm -f "$BIN_DIR/$WATCH_COMMAND"
rm -rf "$SHARE_DIR"
if [ -f "$ETC_FILE" ] && [ ! -s "$ETC_FILE" ]; then
    rm -f "$ETC_FILE"
fi
echo "Uninstallation complete."
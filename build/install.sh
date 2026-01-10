#!/bin/bash
set -e
[ "$EUID" -eq 0 ] || { sudo "$0" "$@"; exit $?; }
CONSTANTS="sudo_no_passwd_constants.sh"
SRC="$(dirname "$0")/../src"
source "$SRC/$CONSTANTS"
mkdir -p "$SHARE_DIR"
cp "$SRC/$CONSTANTS" "$SHARE_DIR/"
cp "$SRC/$UPDATE_COMMAND" "$BIN_DIR/"
cp "$SRC/$WATCH_COMMAND" "$BIN_DIR/"
chmod +x "$BIN_DIR/$UPDATE_COMMAND" "$BIN_DIR/$WATCH_COMMAND"
if command -v systemctl >/dev/null 2>&1; then
    cp "$SRC/$SERVICE_FILE" "$SYSTEMD_DIR/"
elif command -v rc-update >/dev/null 2>&1; then
    cp "$SRC/$INIT_FILE" "$INITD_DIR/"
else
    echo "Unsupported init system."
fi
"$(dirname "$0")/post_install.sh"
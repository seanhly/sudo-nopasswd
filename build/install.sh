#!/bin/bash
set -e
[ "$EUID" -eq 0 ] || { sudo "$0" "$@"; exit $?; }
CONSTANTS="sudo_no_passwd_constants.sh"
SRC="$(dirname "$0")/../src"
echo source "$SRC/$CONSTANTS"
source "$SRC/$CONSTANTS"
echo mkdir -p "$SHARE_DIR"
mkdir -p "$SHARE_DIR"
echo cp "$SRC/$CONSTANTS" "$SHARE_DIR/"
cp "$SRC/$CONSTANTS" "$SHARE_DIR/"
echo cp "$SRC/$UPDATE_COMMAND" "$BIN_DIR/"
cp "$SRC/$UPDATE_COMMAND" "$BIN_DIR/"
echo cp "$SRC/$WATCH_COMMAND" "$BIN_DIR/"
cp "$SRC/$WATCH_COMMAND" "$BIN_DIR/"
echo chmod +x "$BIN_DIR/$UPDATE_COMMAND" "$BIN_DIR/$WATCH_COMMAND"
cp "$SRC/$EDIT_COMMAND" "$BIN_DIR/"
chmod +x "$BIN_DIR/$UPDATE_COMMAND" "$BIN_DIR/$WATCH_COMMAND"
if command -v systemctl >/dev/null 2>&1; then
    cp "$SRC/$SERVICE_FILE" "$SYSTEMD_DIR/"
elif command -v rc-update >/dev/null 2>&1; then
    cp "$SRC/$INIT_FILE" "$INITD_DIR/"
else
    echo "Unsupported init system."
fi
"$(dirname "$0")/post_install.sh"

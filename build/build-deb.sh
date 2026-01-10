#!/bin/bash
set -e
mkdir -p debian
BUILD_DIR="$(dirname "$0")"
DEBIAN_DIR="$BUILD_DIR/../debian"
DIST_DIR="$BUILD_DIR/../dist"
UNINSTALL="$BUILD_DIR/uninstall.sh"
POST_INSTALL="$BUILD_DIR/post_install.sh"
echo "$(cat "$UNINSTALL")" > "$DEBIAN_DIR/prerm"
echo "#DEBHELPER#" >> "$DEBIAN_DIR/prerm"
echo "$(cat "$POST_INSTALL")" > "$DEBIAN_DIR/postinst"
echo "#DEBHELPER#" >> "$DEBIAN_DIR/postinst"
if [ ! -f "$DEBIAN_DIR/control" ]; then
    echo "Error: $DEBIAN_DIR/control not found."
    exit 1
fi
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker not found. Please install Docker."
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "Starting Docker daemon..."
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl start docker
    elif command -v rc-service >/dev/null 2>&1; then
        sudo rc-service docker start
    else
        echo "Error: Unable to determine init system. Please start Docker manually."
        exit 1
    fi
    sleep 2
fi
docker run --rm -v "$(pwd)":/src -v "$DIST_DIR":/dist -w /src debian:latest bash -c "
    apt update && apt install -y debhelper devscripts &&
    dpkg-buildpackage -us -uc &&
	mv /*.deb /dist/
"
echo "Package built: $(ls "$DIST_DIR"/sudo-nopasswd_*.deb | head -n 1)"
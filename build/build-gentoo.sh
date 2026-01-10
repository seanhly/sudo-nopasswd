#!/bin/bash
# Script to build and install the sudo-nopasswd package on Gentoo
set -e
# Check if we're in the project directory
if [ ! -f "gentoo/app-admin/sudo-nopasswd/sudo-nopasswd-1.0.ebuild" ]; then
    echo "Error: ebuild not found. Run this script from the project root."
    exit 1
fi
# Check for emerge command
if ! command -v emerge >/dev/null 2>&1; then
    echo "Error: emerge command not found. Ensure portage is installed."
    exit 1
fi
# Set up local repository
echo "Setting up local repository..."
sudo mkdir -p /etc/portage/repos.conf
sudo tee /etc/portage/repos.conf/local.conf > /dev/null <<EOF
[local]
location = /home/sean/sudo-nopasswd/gentoo
masters = gentoo
EOF
# Regenerate cache
sudo emerge --regen
echo "Building and installing package..."
sudo emerge =app-admin/sudo-nopasswd-1.0
echo "Package installed successfully."
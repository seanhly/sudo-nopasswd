# sudo-nopasswd

![Logo](./docs/icons/512x512/sudo-nopasswd.png)

Manage a curated list of commands that members of the `sudo` group can run without a password prompt.

This project keeps command policy in `/etc/sudo-nopasswd`, then automatically syncs it into `/etc/sudoers` as a single `NOPASSWD` rule.

## What It Does

- Edits command policy in `/etc/sudo-nopasswd`
- Resolves command names to full paths using `command -v`
- Escapes `sudoers` special characters for safety
- Updates or removes the `%sudo ... NOPASSWD:` line in `/etc/sudoers`
- Validates syntax with `visudo -c`
- Reverts from backup if validation fails
- Watches policy changes and reapplies updates automatically via service

## Components

- `src/sudo-nopasswd`: interactive editor helper for `/etc/sudo-nopasswd`
- `src/update-sudo-nopasswd`: applies policy to `/etc/sudoers`
- `src/watch-sudo-nopasswd`: watches for file changes and triggers updates
- `src/sudo-nopasswd.service`: systemd unit
- `src/sudo-nopasswd.init`: OpenRC init script
- `build/install.sh`: installs binaries/service files and enables service
- `build/uninstall.sh`: removes service, binaries, and shared files

## Requirements

Runtime requirements:

- `bash`
- `sudo`
- `visudo` (normally from the `sudggo` package)
- `inotifywait` (from `inotify-tools`)
- Init system:
  - `systemd` (`systemctl`), or
  - `OpenRC` (`rc-update`, `rc-service`)

Build/package helper requirements:

- For Debian package helper scripts: `docker`
- For Gentoo helper script: `emerge`

## Quick Start

1. Install from source:

```bash
cd /path/to/sudo-nopasswd
./build/install.sh
```

2. Add commands:

```bash
sudo-nopasswd
```

3. Save and exit your editor. The tool runs `update-sudo-nopasswd` immediately, and the background watcher keeps changes in sync.

4. Verify:

```bash
sudo -k
sudo <command-you-added>
```

If configured correctly, the command should run without a password prompt.

## Policy File Format

Policy file: `/etc/sudo-nopasswd`

- One command per line (preferred)
- First token is resolved with `command -v`
- Extra arguments on the line are kept

Example:

```text
systemctl restart nginx
apt update
/usr/bin/journalctl -xe
```

Notes:

- If command resolution fails, the resulting entry may be empty or invalid for your intent. Use fully qualified paths for strict control.
- Keep this file root-owned and writable only by trusted admins.

## Service Behavior

On install, the project:

- Creates `/etc/sudo-nopasswd` if missing
- Installs binaries to `/usr/bin`
- Installs shared constants in `/usr/share/sudo-nopasswd`
- Installs and enables either:
  - `sudo-nopasswd.service` (systemd), or
  - `sudo-nopasswd.init` (OpenRC)

The watcher listens for `close_write` events on `/etc/sudo-nopasswd` and runs `update-sudo-nopasswd` after each save.

## Manual Operations

Run update once:

```bash
sudo update-sudo-nopasswd
```

Start/enable service manually (systemd):

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now sudo-nopasswd.service
```

Start/enable service manually (OpenRC):

```bash
sudo rc-update add sudo-nopasswd.init default
sudo rc-service sudo-nopasswd.init start
```

## Uninstall

```bash
cd /path/to/sudo-nopasswd
./build/uninstall.sh
```

This stops/disables the service, removes installed files, and removes `/etc/sudo-nopasswd` if it is empty.

## Packaging Helpers

### Debian helper

```bash
./build/build-deb.sh
```

This script builds in a Debian Docker container and places `.deb` artifacts in `dist/`.

### Gentoo helper

```bash
./build/build-gentoo.sh
```

This script configures a local overlay and emerges `app-admin/sudo-nopasswd-1.0`.

## Security Considerations

- `NOPASSWD` reduces friction but increases risk if command scope is too broad.
- Prefer exact binary paths and minimal argument patterns.
- Review `/etc/sudo-nopasswd` regularly and keep it under change control.
- Test changes in a non-production environment first.

## Troubleshooting

- `No editor found`: set `EDITOR` (for example `EDITOR=vim sudo-nopasswd`).
- `Unsupported init system`: install/run on a host with systemd or OpenRC.
- Update fails with syntax issues: the tool restores `/etc/sudoers` from backup automatically.
- Watcher does not react: ensure `inotifywait` is installed and the service is running.

## Repository Layout

```text
build/      install, uninstall, and packaging scripts
debian/     Debian packaging metadata/helpers
gentoo/     Gentoo ebuild and metadata
src/        core scripts and service definitions
docs/       project assets/icons
```

## License

GPL-3. See `debian/copyright` for packaging license metadata.

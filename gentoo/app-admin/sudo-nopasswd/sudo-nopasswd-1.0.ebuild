EAPI=8

DESCRIPTION="A tool for managing sudo commands without password prompts"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-admin/sudo
	sys-process/inotify-tools"
DEPEND="${RDEPEND}"

src_install() {
	dobin src/update-sudo-nopasswd
	dobin src/watch-sudo-nopasswd

	insinto /usr/share/sudo-nopasswd
	doins src/sudo_no_passwd_constants.sh
	newinitd "${FILESDIR}"/watch-sudo-nopasswd.init watch-sudo-nopasswd
	systemd_dounit src/watch-sudo-nopasswd.service
}

pkg_postinst() {
	if [ ! -f "${ROOT}/etc/sudo-nopasswd" ]; then
		touch "${ROOT}/etc/sudo-nopasswd"
		elog "Created empty ${ROOT}/etc/sudo-nopasswd"
	fi

	elog "To enable the service:"
	elog "  systemctl enable watch-sudo-nopasswd (systemd)"
	elog "  rc-update add watch-sudo-nopasswd default (OpenRC)"
}

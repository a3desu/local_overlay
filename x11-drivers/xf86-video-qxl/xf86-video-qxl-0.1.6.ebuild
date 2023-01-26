# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools python-single-r1 xorg-3

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/driver/xf86-video-qxl.git"
	EGIT_CLONE_TYPE="single"
	EGIT_CHECKOUT_DIR="${WORKDIR}"
else
	SRC_URI="https://www.x.org/releases/individual/driver/${P}.tar.xz"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="QEMU QXL paravirt video driver"

KEYWORDS="amd64 x86"
IUSE="xspice"
REQUIRED_USE="xspice? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	xspice? (
		app-emulation/spice
		${PYTHON_DEPS}
	)
	x11-base/xorg-server[-minimal]
	>=x11-libs/libdrm-2.4.46"
DEPEND="
	${RDEPEND}
	>=app-emulation/spice-protocol-0.12.0
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	use xspice && python-single-r1_pkg_setup
	xorg-3_pkg_setup
}

src_prepare() {
	xorg-3_src_prepare
	eautoreconf

	use xspice && python_fix_shebang scripts
}

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable xspice)
	)
	xorg-3_src_configure
}

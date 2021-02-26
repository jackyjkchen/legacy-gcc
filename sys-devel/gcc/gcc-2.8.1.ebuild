# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CBUILD='i686-legacy-linux-gnu'
CHOST=${CBUILD}
CHOST_x86=${CBUILD}
ABI='x86'
DEFAULT_ABI='x86'
ABI_X86='32'
AS="${CHOST}-as"
LD="${CHOST}-ld"
AR="${CHOST}-ar"
RANLIB="${CHOST}-ranlib"
CFLAGS_x86=""

inherit toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="amd64 x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:3.4.6
	legacy-gcc/linux-headers:i686-legacy
	legacy-gcc/glibc-headers:i686-legacy
	legacy-gcc/binutils-wrapper:i686-legacy"

case ${ARCH} in
	amd64)
		CC="gcc-3.4.6 -m32"
		CXX="g++-3.4.6 -m32"
		;;
	x86)
		CC="gcc-3.4.6"
		CXX="g++-3.4.6"
		;;
esac

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}-workaround-for-new-glibc.patch
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
}

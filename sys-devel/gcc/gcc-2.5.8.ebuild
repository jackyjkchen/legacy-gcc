# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CHOST=${CHOST_x86}
ABI='x86'
DEFAULT_ABI='x86'
ABI_X86='32'
AS="${CHOST_x86}-as"
LD="${CHOST_x86}-ld"
AR="${CHOST_x86}-ar"
RANLIB="${CHOST_x86}-ranlib"
CFLAGS_x86=""

inherit toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="amd64 x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:2.95.3
	amd64? (
		legacy-gcc/i686-pc-linux-gnu-binutils
	)"

CC="gcc-2.95.3"
CXX="g++-2.95.3"

src_unpack() {
	toolchain_src_unpack
}

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/2.5.8/00_gcc-2.5.8.patch
	eapply "${FILESDIR}"/2.5.8/01_gcc-2.5.8-gentoo-install-path.patch
	eapply "${FILESDIR}"/2.5.8/02_gcc-2.5.8-workaround-for-new-glibc.patch
	rm -rf ${WORKDIR}/${P}/cp
}

src_install() {
	toolchain_src_install
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CC="gcc-2.95.3"
CXX="g++-2.95.3"
case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		CHOST_x86="${TOOL_SLOT}-linux-gnu"
		ABI='x86'
		DEFAULT_ABI='x86'
		ABI_X86='32'
		CFLAGS_x86=""
		;;
	*)
		;;
esac

CBUILD="${TOOL_SLOT}-linux-gnu"
CHOST=${CBUILD}
AS="${CHOST}-as"
LD="${CHOST}-ld"
AR="${CHOST}-ar"
RANLIB="${CHOST}-ranlib"

EXTRA_ECONF="--gxx-include-dir=/usr/lib/gcc-lib/${CHOST}/${PV}/include/g++"

inherit toolchain

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:2.95.3
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}-gentoo-install-path.patch
	eapply "${FILESDIR}"/${PV}/02_gcc-${PV}-workaround-for-new-glibc.patch
	toolchain_src_prepare
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CC="gcc-2.95.3"
CXX="g++-2.95.3"
case ${ARCH} in
	amd64|x86)
		TOOL_PREFIX="i686-legacy"
		CHOST_x86="${TOOL_PREFIX}-linux-gnu"
		ABI='x86'
		DEFAULT_ABI='x86'
		ABI_X86='32'
		CFLAGS_x86=""
		;;
	m68k)
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	*)
		;;
esac

CBUILD="${TOOL_PREFIX}-linux-gnu"
CHOST=${CBUILD}
AS="${CHOST}-as"
LD="${CHOST}-ld"
AR="${CHOST}-ar"
RANLIB="${CHOST}-ranlib"

inherit toolchain

KEYWORDS="amd64 m68k x86"

RDEPEND=""
DEPEND="${RDEPEND}
	legacy-gcc/linux-headers
	legacy-gcc/glibc-headers
	legacy-gcc/binutils-wrapper"
BDEPEND="sys-devel/gcc:2.95.3"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}-gentoo-install-path.patch
	eapply "${FILESDIR}"/${PV}/02_gcc-${PV}-workaround-for-new-glibc.patch
	toolchain_src_prepare
}

src_install() {
	toolchain_src_install
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/14-${CHOST}-gcc-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/${GCC_CONFIG_VER}
_EOF_
}

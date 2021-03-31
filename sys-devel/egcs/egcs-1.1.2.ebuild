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
	ppc)
		TOOL_SLOT="powerpc-legacy"
		;;
	sparc)
		TOOL_SLOT="sparc-legacy"
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

inherit toolchain

KEYWORDS="amd64 ppc sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:2.95.3
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_egcs-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_workaround-for-new-glibc.patch
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/08-${CHOST}-egcs-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/2.91.66
_EOF_
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

CC="gcc-2.95.3"
CXX="g++-2.95.3"
case $(tc-arch) in
	amd64|x86)
		TOOL_PREFIX="i686-legacy"
		CHOST_x86="${TOOL_PREFIX}-linux-gnu"
		ABI='x86'
		DEFAULT_ABI='x86'
		ABI_X86='32'
		CFLAGS_x86=""
		;;
	alpha|m68k)
		TOOL_PREFIX="$(tc-arch)-legacy"
		;;
	ppc)
		TOOL_PREFIX="powerpc-legacy"
		;;
	sparc)
		TOOL_PREFIX="sparc-legacy"
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

ENABLE_WERROR="yes"

inherit toolchain

KEYWORDS="alpha amd64 m68k ppc sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	legacy-gcc/linux-headers
	legacy-gcc/glibc-headers
	legacy-gcc/binutils-wrapper"
BDEPEND="sys-devel/gcc:2.95.3"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_egcs-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_workaround-for-new-glibc.patch
	toolchain_src_prepare
	if ! _tc_use_if_iuse cxx; then
		rm -r libstdc++ libio gcc/cp || die
	fi
	if ! _tc_use_if_iuse objc; then
		rm -r gcc/objc || die
	fi
	if ! _tc_use_if_iuse f77; then
		rm -r libf2c gcc/f || die
	fi
	touch -r gcc/README gcc/configure.in || die
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/12-${CHOST}-egcs-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/2.91.66
_EOF_
}

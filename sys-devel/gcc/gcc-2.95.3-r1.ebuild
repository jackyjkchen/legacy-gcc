# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PATCH_VER="1.4"

CC="gcc-3.4.6"
CXX="g++-3.4.6"
case ${ARCH} in
	amd64|x86)
		CC="${CC} ${CFLAGS_x86}"
		CXX="${CXX} ${CFLAGS_x86}"
		TOOL_SLOT="i686-legacy"
		CHOST_x86="${TOOL_SLOT}-linux-gnu"
		ABI='x86'
		DEFAULT_ABI='x86'
		ABI_X86='32'
		CFLAGS_x86=""
		;;
	alpha)
		CFLAGS="${CFLAGS} -Wl,-no-relax"
		CXXFLAGS="${CFLAGS} -Wl,-no-relax"
		TOOL_SLOT="${ARCH}-legacy"
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

KEYWORDS="alpha amd64 ppc sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:3.4.6
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"

src_prepare() {
	EPATCH_EXCLUDE+=" 10_alpha_new-atexit.patch"
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/02_fix-patchset.patch
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
}

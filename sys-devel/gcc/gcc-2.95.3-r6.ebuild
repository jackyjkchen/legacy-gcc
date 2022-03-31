# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CC="gcc-3.4.6"
CXX="g++-3.4.6"
case ${ARCH} in
	amd64|x86)
		CC="${CC} ${CFLAGS_x86}"
		CXX="${CXX} ${CFLAGS_x86}"
		TOOL_PREFIX="i686-legacy"
		CHOST_x86="${TOOL_PREFIX}-linux-gnu"
		ABI='x86'
		DEFAULT_ABI='x86'
		ABI_X86='32'
		CFLAGS_x86=""
		;;
	alpha)
		CFLAGS="${CFLAGS} -Wl,-no-relax"
		CXXFLAGS="${CFLAGS} -Wl,-no-relax"
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	m68k)
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	mips)
		CC="${CC} ${CFLAGS_o32}"
		CXX="${CXX} ${CFLAGS_o32}"
		TOOL_PREFIX="${PROFILE_ARCH/64/}-legacy"
		;;
	ppc)
		TOOL_PREFIX="powerpc-legacy"
		;;
	sparc)
		CC="${CC} ${CFLAGS_sparc32}"
		CXX="${CXX} ${CFLAGS_sparc32}"
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

inherit toolchain

KEYWORDS="alpha amd64 m68k mips ppc sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	legacy-gcc/linux-headers
	legacy-gcc/glibc-headers
	legacy-gcc/binutils-wrapper"
BDEPEND="sys-devel/gcc:3.4.6"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	[[ ${ARCH} == "m68k" ]] && eapply "${FILESDIR}"/${PV}/02_m68k-debian.patch
	[[ ${TOOL_PREFIX} == "sparc64-legacy" ]] && eapply "${FILESDIR}"/${PV}/03_workaround-for-sparc64.patch
	[[ ${ARCH} == "avr" ]] && "${FILESDIR}"/${PV}/04_support-avr.patch
	touch -r gcc/README gcc/configure.in || die
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/11-${CHOST}-gcc-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
}

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
	m68k)
		TOOL_SLOT="${ARCH}-legacy"
		;;
	mips)
		CC="${CC} ${CFLAGS_o32}"
		CXX="${CXX} ${CFLAGS_o32}"
		TOOL_SLOT="${PROFILE_ARCH/64/}-legacy"
		;;
	ppc)
		TOOL_SLOT="powerpc-legacy"
		;;
	sparc)
		CC="${CC} ${CFLAGS_sparc32}"
		CXX="${CXX} ${CFLAGS_sparc32}"
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

KEYWORDS="alpha amd64 m68k mips ppc s390 sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:3.4.6
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"

src_prepare() {
	EPATCH_EXCLUDE+=" 10_alpha_new-atexit.patch"
	[[ ${ARCH} != "m68k" ]] && EPATCH_EXCLUDE+=" 42_all_debian-m68k-md.patch 42_all_debian-gcc-m68k-pic.patch 42_all_debian-m68k-reload.patch"
	[[ ${ARCH} != "avr" ]] && EPATCH_EXCLUDE+=" 41_all_debian-gcc-core-2.95.2-avr-1.1.patch"
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/02_fix-patchset.patch
	[[ ${TOOL_SLOT} == "sparc64-legacy" ]] && eapply "${FILESDIR}"/${PV}/03_workaround-for-sparc64.patch
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

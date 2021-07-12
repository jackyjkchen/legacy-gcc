# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	alpha|m68k)
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
	s390)
		TOOL_SLOT="s390x-legacy"
		;;
	sparc)
		CC="${CC} ${CFLAGS_sparc32}"
		CXX="${CXX} ${CFLAGS_sparc32}"
		TOOL_SLOT="sparc-legacy"
		;;
	*)
		TOOL_SLOT="host"
		;;
esac

if [[ ${TOOL_SLOT} != "host" ]]; then
	CBUILD="${TOOL_SLOT}-linux-gnu"
	CHOST=${CBUILD}
	AS="${CHOST}-as"
	LD="${CHOST}-ld"
	AR="${CHOST}-ar"
	RANLIB="${CHOST}-ranlib"
	LEGACY_DEPEND="
		legacy-gcc/linux-headers:${TOOL_SLOT}
		legacy-gcc/glibc-headers:${TOOL_SLOT}
		legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
fi

inherit toolchain

KEYWORDS="alpha amd64 m68k mips ppc s390 sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:3.4.6
	${LEGACY_DEPEND}"

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	[[ ${TOOL_SLOT} != "host" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
}

src_install() {
	toolchain_src_install
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/10-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
}

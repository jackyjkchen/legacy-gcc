# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CC="gcc-3.4.6"
CXX="g++-3.4.6"
case ${ARCH} in
	mips)
		CC="${CC} ${CFLAGS_o32}"
		CXX="${CXX} ${CFLAGS_o32}"
		TOOL_SLOT="${PROFILE_ARCH/64/}-legacy"
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

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="alpha amd64 m68k mips ppc ppc64 s390 sparc x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=">=sys-devel/binutils-2.14.90.0.6-r1"
DEPEND="${RDEPEND}
	sys-devel/gcc:3.4.6
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )
	${LEGACY_DEPEND}"

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	[[ ${TOOL_SLOT} != "host" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
}

src_install() {
	toolchain_src_install
	if [[ ${TOOL_SLOT} != "host" ]]; then
		mkdir -p ${ED}/etc/ld.so.conf.d/ || die
		cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/09-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
	fi
}

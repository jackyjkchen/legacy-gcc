# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

CC="gcc-3.4.6"
CXX="g++-3.4.6"
case $(tc-arch) in
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
alpha|m68k)
	TOOL_PREFIX="$(tc-arch)-legacy"
	;;
mips)
	CC="${CC} ${CFLAGS_o32}"
	CXX="${CXX} ${CFLAGS_o32}"
	TOOL_PREFIX="${PROFILE_ARCH/64/}-legacy"
	;;
ppc)
	TOOL_PREFIX="powerpc-legacy"
	;;
s390)
	TOOL_PREFIX="s390x-legacy"
	;;
sparc)
	CC="${CC} ${CFLAGS_sparc32}"
	CXX="${CXX} ${CFLAGS_sparc32}"
	TOOL_PREFIX="sparc-legacy"
	;;
*)
	TOOL_PREFIX=""
	;;
esac

if [[ ${TOOL_PREFIX} != "" ]]; then
	CBUILD="${TOOL_PREFIX}-linux-gnu"
	CHOST=${CBUILD}
	AS="${CHOST}-as"
	LD="${CHOST}-ld"
	AR="${CHOST}-ar"
	RANLIB="${CHOST}-ranlib"
	LEGACY_DEPEND="
		legacy-gcc/linux-headers
		legacy-gcc/glibc-headers
		legacy-gcc/binutils-wrapper"
fi

inherit toolchain

KEYWORDS="alpha amd64 m68k mips ppc s390 sparc x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:3.0.4"
	CC="gcc-3.0.4"
	CXX="g++-3.0.4"
else
	DEPEND="${DEPEND} ${LEGACY_DEPEND}"
	BDEPEND="sys-devel/gcc:3.4.6"
	CC=${CC-"gcc-3.4.6"}
	CXX=${CXX-"g++-3.4.6"}
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain_src_prepare

	[[ ${TOOL_PREFIX} != "" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	[[ $(tc-arch) == "alpha" ]] && eapply "${FILESDIR}"/${PV}/02_alpha-debian.patch
	[[ $(tc-arch) == "m68k" ]] && eapply "${FILESDIR}"/${PV}/03_m68k-debian.patch
	[[ $(tc-arch) == "sparc" ]] && eapply "${FILESDIR}"/${PV}/04_sparc-debian.patch
	[[ $(tc-arch) == "sparc" ]] && eapply "${FILESDIR}"/${PV}/05_sparc-build-hang.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch

	eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
}

src_install() {
	toolchain_src_install
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/10-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
}
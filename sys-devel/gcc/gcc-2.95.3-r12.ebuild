# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

CC="gcc-3.4.6"
CXX="g++-3.4.6"
if [[ ${CATEGORY} != cross-* ]] ; then
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
	alpha)
		TOOL_PREFIX="$(tc-arch)-legacy"
		;;
	m68k)
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
	sparc)
		CC="${CC} ${CFLAGS_sparc32}"
		CXX="${CXX} ${CFLAGS_sparc32}"
		TOOL_PREFIX="sparc-legacy"
		;;
	*)
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
fi

inherit toolchain

KEYWORDS="alpha amd64 m68k mips ppc sparc x86"

RDEPEND="${CATEGORY}/binutils"
if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:2.95.3"
	CC="gcc-2.95.3"
	CXX="g++-2.95.3"
else
	DEPEND="${DEPEND} ${LEGACY_DEPEND}"
	BDEPEND="sys-devel/gcc:3.4.6"
	CC=${CC-"gcc-3.4.6"}
	CXX=${CXX-"g++-3.4.6"}
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-2.95.4-without-change-version.patch
	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}.patch
	toolchain_src_prepare

	[[ ${TOOL_PREFIX} != "" ]] && eapply "${FILESDIR}"/${PV}/02_workaround-for-legacy-glibc-in-non-system-dir.patch
	[[ $(tc-arch) == "m68k" ]] && eapply "${FILESDIR}"/${PV}/03_m68k-debian.patch
	[[ ${TOOL_PREFIX} == "sparc64-legacy" ]] && eapply "${FILESDIR}"/${PV}/04_workaround-for-sparc64.patch
	eapply "${FILESDIR}"/${PV}/05_fix-crash-00204.patch
	eapply "${FILESDIR}"/${PV}/06_sjlj-exception-default.patch
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

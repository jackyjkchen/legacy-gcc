# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${CATEGORY} != cross-* ]] ; then
	case $(tc-arch) in
	amd64)
		TOOL_PREFIX="x86_64-legacy"
		;;
	x86)
		TOOL_PREFIX="i686-legacy"
		;;
	alpha|m68k)
		TOOL_PREFIX="$(tc-arch)-legacy"
		;;
	hppa)
		TOOL_PREFIX="hppa1.1-legacy"
		;;
	mips)
		CC="gcc-3.4.6 ${CFLAGS_o32}"
		CXX="g++-3.4.6 ${CFLAGS_o32}"
		TOOL_PREFIX="${PROFILE_ARCH}-legacy"
		;;
	ppc)
		TOOL_PREFIX="powerpc-legacy"
		;;
	ppc64)
		TOOL_PREFIX="powerpc64-legacy"
		;;
	s390)
		TOOL_PREFIX="s390x-legacy"
		;;
	sh)
		TOOL_PREFIX="sh4-legacy"
		;;
	sparc)
		TOOL_PREFIX="${PROFILE_ARCH}-legacy"
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
fi

inherit toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="alpha amd64 hppa m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:3.3.6"
	CC="gcc-3.3.6"
	CXX="g++-3.3.6"
else
	DEPEND="${DEPEND} ${LEGACY_DEPEND}"
	BDEPEND="sys-devel/gcc:3.4.6"
	CC=${CC-"gcc-3.4.6"}
	CXX=${CXX-"g++-3.4.6"}
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ ${TOOL_PREFIX} != "" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	[[ $(tc-arch) == "mips" ]] && eapply "${FILESDIR}"/${PV}/02_support-mips64.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/03_fix-for-sh4.patch
	[[ $(tc-arch) == "ppc64" || $(tc-arch) == "ppc" ]] && eapply "${FILESDIR}"/${PV}/04_workaround-for-ppc64-ppc.patch

	if use objc ; then
		[[ $(tc-arch) != "mips" ]] && eapply "${FILESDIR}"/${PV}/05_libffi-without-libgcj.patch
	fi
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/06_hppa-fix-build.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr24580.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr25572.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr26729.patch
}

src_install() {
	toolchain_src_install
	if [[ ${TOOL_PREFIX} != "" ]]; then
		mkdir -p ${ED}/etc/ld.so.conf.d/ || die
		case ${TOOL_PREFIX} in
			x86_64-legacy|sparc64-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
/usr/lib/gcc-lib/${CHOST}/${PV}/32
_EOF_
				;;
			mips64*-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
/usr/lib/gcc-lib/${CHOST}/${PV}/32
/usr/lib/gcc-lib/${CHOST}/${PV}/n32
_EOF_
				;;
			*)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
				;;
		esac
	fi
}
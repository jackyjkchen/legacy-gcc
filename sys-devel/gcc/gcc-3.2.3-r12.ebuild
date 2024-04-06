# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
KEYWORDS="alpha amd64 hppa m68k mips ppc ppc64 s390 sparc x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:3.2.3"
	CC="gcc-3.2.3"
	CXX="g++-3.2.3"
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
	case $(tc-arch) in
		mips)
			eapply "${FILESDIR}"/${PV}/02_support-mips64.patch
			# coredump on n64 and more testcase fail on n32
			# [[ ${DEFAULT_ABI} == "n64" || ${DEFAULT_ABI} == "n32" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n32-abi.patch
			;;
		hppa)
			eapply "${FILESDIR}"/${PV}/04_hppa-fix-build.patch
			;;
	esac

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr25572.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	is_crosscompile || rm -rf libstdc++-v3/testsuite/27_io/{filebuf_members.cc,filebuf_virtuals.cc,ostream_inserter_arith.cc,streambuf_members.cc,stringbuf_virtuals.cc}
}

src_install() {
	toolchain_src_install
	if [[ ${TOOL_PREFIX} != "" ]]; then
		mkdir -p ${ED}/etc/ld.so.conf.d/ || die
		case ${TOOL_PREFIX} in
			x86_64-legacy|sparc64-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/08-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
/usr/lib/gcc-lib/${CHOST}/${PV}/32
_EOF_
				;;
			mips64*-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/08-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}/32
/usr/lib/gcc-lib/${CHOST}/${PV}/n32
_EOF_
				;;
			*)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/08-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
				;;
		esac
	fi
}

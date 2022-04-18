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
KEYWORDS="alpha amd64 m68k mips ppc ppc64 s390 sh sparc x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=">=${CATEGORY}/binutils-2.14.90.0.6-r1"
DEPEND="${RDEPEND}
	amd64? ( >=${CATEGORY}/binutils-2.15.90.0.1.1-r1 )"

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

	[[ $(tc-arch) == "mips" ]] && eapply "${FILESDIR}"/${PV}/01_support-mips64.patch
	[[ ${CATEGORY} == "cross-i686-legacy-mingw32" ]] && eapply "${FILESDIR}"/${PV}/02_support-mingw.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/03_fix-for-sh4-install.patch
	[[ $(tc-arch) == "ppc64" || $(tc-arch) == "ppc" ]] && eapply "${FILESDIR}"/${PV}/04_workaround-for-ppc64-ppc.patch

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		[[ $(tc-arch) != "mips" ]] && eapply "${FILESDIR}"/${PV}/05_libffi-without-libgcj.patch
	fi

	[[ ${TOOL_PREFIX} != "" ]] && eapply "${FILESDIR}"/${PV}/06_workaround-for-legacy-glibc-in-non-system-dir.patch
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

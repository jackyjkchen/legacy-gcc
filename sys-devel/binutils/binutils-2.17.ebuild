# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CC="gcc-4.4.7"
CXX="g++-4.4.7"
BDEPEND="sys-devel/gcc:4.4.7"

inherit toolchain-funcs

if [[ ${CATEGORY} != cross-* ]] ; then
	case ${CATEGORY} in
	dev-libc5)
		TOOL_SUFFIX="linux-gnulibc1"
		case $(tc-arch) in
		amd64|x86)
			TOOL_PREFIX="i586-legacy"
			;;
		*)
			;;
		esac
		;;
	*)
		;;
	esac

	if [[ ${TOOL_PREFIX} != "" ]]; then
		CBUILD="${TOOL_PREFIX}-${TOOL_SUFFIX}"
		CHOST=${CBUILD}
		CTARGET=${CHOST}
	fi
fi

inherit toolchain-binutils

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch

	toolchain-binutils_src_prepare
}

src_configure() {
	downgrade_arch_flags 4.4.7
	toolchain-binutils_src_configure
}

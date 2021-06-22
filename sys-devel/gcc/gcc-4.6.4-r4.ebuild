# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PATCH_VER="2"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:4.9.4
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=sys-devel/binutils-2.18"
CC="gcc-4.9.4"
CXX="g++-4.9.4"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_prepare() {
	if has_version '<sys-libs/glibc-2.12' ; then
		ewarn "Your host glibc is too old; disabling automatic fortify."
		ewarn "Please rebuild gcc after upgrading to >=glibc-2.12 #362315"
		EPATCH_EXCLUDE+=" 10_all_default-fortify-source.patch"
	fi

	toolchain_src_prepare

	use vanilla && return 0

	eapply "${FILESDIR}"/4.6.4/00_support-armhf.patch

	[[ ${ARCH} == "mips" ]] && [[ ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/4.6.4/01_mips64el_default_n64_abi.patch
}

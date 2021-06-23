# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PATCH_VER="2"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:4.4.7
	ppc? ( >=sys-devel/binutils-2.17 )
	ppc64? ( >=sys-devel/binutils-2.17 )
	>=sys-devel/binutils-2.15.94"
CC="gcc-4.4.7"
CXX="g++-4.4.7"

src_prepare() {
	EPATCH_EXCLUDE+=" 91_all_mips-ip28_cache_barriers-v4.patch"
	toolchain_src_prepare

	use vanilla && return 0

	[[ ${ARCH} == "mips" ]] && [[ ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/00_mips64_default_n64_abi.patch
}

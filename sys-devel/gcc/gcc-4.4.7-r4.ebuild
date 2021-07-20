# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PATCH_VER="2"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	ppc? ( >=sys-devel/binutils-2.17 )
	ppc64? ( >=sys-devel/binutils-2.17 )
	>=sys-devel/binutils-2.15.94"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
	DEPEND="${DEPEND} sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
else
	DEPEND="${DEPEND} sys-devel/gcc:4.4.7"
	CC="gcc-4.4.7"
	CXX="g++-4.4.7"
fi

src_prepare() {
	EPATCH_EXCLUDE+=" 30_all_gcc-4.4_arm_armv4-no-thumb-fix-link.patch 41_all_4.4.5-msabi.patch 93_all_gcc-4.4-cloog-dl.patch 96_all_arm-pr43440.patch"
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_support-armhf.patch

	[[ ${ARCH} == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64_default_n64_abi.patch

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200
}

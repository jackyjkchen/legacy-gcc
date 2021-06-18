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
	ppc? ( >=sys-devel/binutils-2.17 )
	ppc64? ( >=sys-devel/binutils-2.17 )
	>=sys-devel/binutils-2.15.94"
CC="gcc-4.9.4"
CXX="g++-4.9.4"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0

	eapply "${FILESDIR}"/4.5.4/00_support-armhf.patch

	[[ ${ARCH} == "mips" ]] && eapply "${FILESDIR}"/4.5.4/01_mips64el_default_n64_abi.patch

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200
}

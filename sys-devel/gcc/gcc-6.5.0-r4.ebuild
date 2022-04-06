# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="6"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
	BDEPEND="sys-devel/gcc:8.5.0"
	CC="gcc-8.5.0"
	CXX="g++-8.5.0"
else
	BDEPEND="sys-devel/gcc:6.5.0"
	CC="gcc-6.5.0"
	CXX="g++-6.5.0"
fi

src_prepare() {
	toolchain_src_prepare

	[[ ${CATEGORY} == "cross-i686-legacy-mingw32" ]] && eapply "${FILESDIR}"/${PV}/00_mingw-enable-c99-in-cpp.patch
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="3"

# Hardened gcc 4 stuff
PIE_VER="1"
SPECS_VER="0.2.0"
SPECS_GCC_VER="4.4.3"
# arch/libc configurations known to be stable with {PIE,SSP}-by-default
PIE_GLIBC_STABLE="x86 amd64 mips ppc ppc64 arm ia64"
SSP_STABLE="amd64 x86 mips ppc ppc64 arm"
#end Hardened stuff

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
	BDEPEND="sys-devel/gcc:8.5.0"
	CC="gcc-8.5.0"
	CXX="g++-8.5.0"
else
	BDEPEND="sys-devel/gcc:5.5.0"
	CC="gcc-5.5.0"
	CXX="g++-5.5.0"
fi

src_prepare() {
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/00_fix-building-on-ppc64.patch
	[[ ${ARCH} == "sh" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-bootstrap-for-sh4.patch
	eapply "${FILESDIR}"/${PV}/02_fix-libgo-for-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/03_fix-sanitizer-for-new-kernel.patch
}
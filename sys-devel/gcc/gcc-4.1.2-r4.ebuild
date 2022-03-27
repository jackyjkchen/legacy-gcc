# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=sys-devel/binutils-2.17 )
	ppc64? ( >=sys-devel/binutils-2.17 )
	>=sys-devel/binutils-2.15.94"

if is_crosscompile ; then
	DEPEND="${DEPEND} sys-devel/gcc:4.1.2"
	CC="gcc-4.1.2"
	CXX="g++-4.1.2"
else
	DEPEND="${DEPEND} sys-devel/gcc:4.4.7"
	CC="gcc-4.4.7"
	CXX="g++-4.4.7"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	eapply "${FILESDIR}"/${PV}/01_compat-new-mpfr.patch
	[[ ${ARCH} == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
	[[ ${ARCH} == "sh" ]] && eapply "${FILESDIR}"/${PV}/03_sh4-fix-build.patch
}

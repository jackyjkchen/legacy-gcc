# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PATCH_VER="2"
UCLIBC_VER="1.0"
D_VER="0.24"

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

	# Fix cross-compiling
	epatch "${FILESDIR}"/${PV}/gcc-4.1.0-cross-compile.patch

	epatch "${FILESDIR}"/${PV}/gcc-4.1.0-fast-math-i386-Os-workaround.patch

	eapply "${FILESDIR}"/${PV}/00_compat_new_mpfr.patch

	[[ ${ARCH} == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64_default_n64_abi.patch
	[[ ${ARCH} == "sh" ]] && eapply "${FILESDIR}"/${PV}/02_sh4_fix_build_by_gcc42_and_up.patch
}

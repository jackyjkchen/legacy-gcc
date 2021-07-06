# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PATCH_VER="2"
UCLIBC_VER="1.0"

case ${ARCH} in
	sh)
		CC="gcc-4.1.2"
		CXX="g++-4.1.2"
		STAGE1_GCC="sys-devel/gcc:4.1.2"
		;;
	*)
		CC="gcc-4.4.7"
		CXX="g++-4.4.7"
		STAGE1_GCC="sys-devel/gcc:4.4.7"
		;;
esac

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${STAGE1_GCC}
	sys-devel/gcc:4.4.7
	>=sys-devel/binutils-2.15.94"

src_prepare() {
	toolchain_src_prepare

	use vanilla && return 0

	[[ ${ARCH} == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/00_mips64_default_n64_abi.patch
	[[ ${ARCH} == "sh" ]] && eapply "${FILESDIR}"/${PV}/01_sh4_workaround_fixproto_core.patch
}

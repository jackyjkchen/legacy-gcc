# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain

KEYWORDS="alpha amd64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.15.94"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:4.0.4"
	CC="gcc-4.0.4"
	CXX="g++-4.0.4"
else
	case $(tc-arch) in
	sh)
		CC="gcc-4.1.2"
		CXX="g++-4.1.2"
		BDEPEND="sys-devel/gcc:4.1.2"
		;;
	*)
		CC="gcc-4.4.7"
		CXX="g++-4.4.7"
		BDEPEND="sys-devel/gcc:4.4.7"
		;;
	esac
fi

src_prepare() {
	! use vanilla && eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/02_sh4-workaround-fixproto-core.patch
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/03_hppa-fix-build.patch
}

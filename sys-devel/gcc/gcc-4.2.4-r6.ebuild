# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:4.2.4"
	CC="gcc-4.2.4"
	CXX="g++-4.2.4"
else
	BDEPEND="sys-devel/gcc:4.4.7"
	CC="gcc-4.4.7"
	CXX="g++-4.4.7"
fi

src_prepare() {
	! use vanilla && eapply "${FILESDIR}"/${PV}/00_gcc-4.2.5-without-change-version.patch
	! use vanilla && eapply "${FILESDIR}"/${PV}/01_gentoo-patchset.patch
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr33619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr35202.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr36300.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr34947.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr36742.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr35616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr46010.patch
}

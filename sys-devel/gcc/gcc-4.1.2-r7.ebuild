# Copyright 1999-2020 Gentoo Authors
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
	BDEPEND="sys-devel/gcc:4.1.2"
	CC="gcc-4.1.2"
	CXX="g++-4.1.2"
else
	BDEPEND="sys-devel/gcc:4.4.7"
	CC="gcc-4.4.7"
	CXX="g++-4.4.7"
fi

src_prepare() {
	! use vanilla && eapply "${FILESDIR}"/${PV}/00_gcc-4.1.3-without-change-version.patch
	! use vanilla && eapply "${FILESDIR}"/${PV}/01_gentoo-patchset.patch
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/02_compat-new-mpfr.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/03_sh4-fix-build.patch
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/04_hppa-fix-build.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/05_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/06_backport-static-libstdc++-option.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr33619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr36013.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr34768.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr31196.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr36300.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr29877.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr32298.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr35616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr46010.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr31915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr34154.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr31210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr33288.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr31211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr36093.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr31295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr31203.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr28230.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr25243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr38030.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr31309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr44555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr39855.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr31725.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr38852.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr35685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr32244.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr31001.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}

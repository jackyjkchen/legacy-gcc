# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	[[ ${CTARGET} == arm*-*-*eabihf* ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/04_backport-static-libstdc++-option.patch
	use test && [[ ${CTARGET} == arm*-*-*eabi ]] && eapply "${FILESDIR}"/${PV}/05_workaround-abi-warning-in-test.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr39120.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr46779.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr56015.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr45694.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr42240.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr44996.patch
	[[ ${CTARGET} == arm*-*-*eabihf* ]] || eapply "${FILESDIR}"/${PV}/postrelease/20_pr43323.patch
	[[ ${CTARGET} == arm*-*-*eabihf* ]] || eapply "${FILESDIR}"/${PV}/postrelease/21_pr42321.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr39633.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr45777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr36399.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr43886.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr31827.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	fi
}

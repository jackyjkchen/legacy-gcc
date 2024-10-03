# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_remove-combine.patch
	eapply "${FILESDIR}"/${PV}/04_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr78185.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr53922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr40850.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr47844.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr46083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr49897-49898.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr44696.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr44290.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr56539.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr38392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr46162-46170.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr54208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr23200.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr47789.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr51825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr45236.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr45401.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr49134.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
	fi
}

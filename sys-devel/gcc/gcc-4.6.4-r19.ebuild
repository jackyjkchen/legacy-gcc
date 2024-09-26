# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_remove-struct-matrix-reorg.patch
	eapply "${FILESDIR}"/${PV}/04_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr56899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr60485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr53922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr57785.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr56712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr54524.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr58941.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr51308.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr60361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr51825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr53841.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr35255.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-arm-test-fail.patch
	fi
}

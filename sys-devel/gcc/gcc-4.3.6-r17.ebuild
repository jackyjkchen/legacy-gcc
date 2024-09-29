# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/03_backport-static-libstdc++-option.patch
	eapply "${FILESDIR}"/${PV}/04_support-__builtin_isinf_sign.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr50109.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr35202.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr46010.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr44942.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr35685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr56015.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr45312.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr42240.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr43419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr35729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr44996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr48837.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr39633.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr39365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr43841.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr43228.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr40962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr45777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr32000.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr54208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr42655.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr40629.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr39987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr45401.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr35297.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr28274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr39028.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr37971.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr24449.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail-x86.patch
		[[ $(tc-arch) == "arm" ]] && rm -rf gcc/testsuite/obj-c++.dg/try-catch-11.mm
	fi
}

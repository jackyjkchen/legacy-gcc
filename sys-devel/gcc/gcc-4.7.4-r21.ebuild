# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "alpha" ]] && eapply "${FILESDIR}"/${PV}/02_fix-alpha-bootstrap.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_remove-matrix-reorg.patch
	eapply "${FILESDIR}"/${PV}/04_fix-cpp98-break.patch
	eapply "${FILESDIR}"/${PV}/05_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr58943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr70931-71452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr81977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr67770.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr60766.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr11750.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr52448.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr53636.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr51447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr77933.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr60392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr58574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr60454.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr62031-63379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr60276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr56899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr60485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr58653.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr48814.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr77812.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr60894.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr64970.patch
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr61683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/61_pr49132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/62_pr60361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/63_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/64_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/65_pr56609.patch
	eapply "${FILESDIR}"/${PV}/postrelease/66_pr53017-59211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/67_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/68_pr53648.patch
	eapply "${FILESDIR}"/${PV}/postrelease/69_pr55972.patch
	eapply "${FILESDIR}"/${PV}/postrelease/70_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/71_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/72_pr24449.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-arm-test-fail.patch
	fi
}

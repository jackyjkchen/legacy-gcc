# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	use graphite && eapply "${FILESDIR}"/${PV}/01_compat-new-isl.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr80693-81019-81020.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr88563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr89679.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr68823.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr90328.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr94412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr103908.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr80533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr86334-88906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr79622.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr89794.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr89009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr91136.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr66695-77746-79485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr91126-91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr69487.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr65782.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr85593.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr80983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr86669.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr83860.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr94947.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr108365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr87597.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr89434-89506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr61504.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr60702.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr79388-79450.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr80306.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr83316.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr71488.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr74563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr81740.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr93402.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr81423.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr51333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr85118.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/61_pr101087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/62_pr81740-89392-89725-90006.patch
	eapply "${FILESDIR}"/${PV}/postrelease/63_pr67054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/64_pr82294-87436.patch
	eapply "${FILESDIR}"/${PV}/postrelease/65_pr84988.patch
	eapply "${FILESDIR}"/${PV}/postrelease/66_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/67_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/68_pr91308.patch
	eapply "${FILESDIR}"/${PV}/postrelease/69_pr90951.patch
	eapply "${FILESDIR}"/${PV}/postrelease/70_pr77585.patch
	eapply "${FILESDIR}"/${PV}/postrelease/71_pr88103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/72_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/73_pr87366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/74_pr84463.patch
	eapply "${FILESDIR}"/${PV}/postrelease/75_pr87734.patch
	eapply "${FILESDIR}"/${PV}/postrelease/76_pr66575.patch
	eapply "${FILESDIR}"/${PV}/postrelease/77_pr81589.patch
	eapply "${FILESDIR}"/${PV}/postrelease/78_pr49070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/79_pr82307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/80_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/81_pr79960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/82_pr80227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/83_pr64095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/84_pr71965.patch
	eapply "${FILESDIR}"/${PV}/postrelease/85_pr72813.patch
	eapply "${FILESDIR}"/${PV}/postrelease/86_pr66443.patch
	eapply "${FILESDIR}"/${PV}/postrelease/87_pr70229.patch
	eapply "${FILESDIR}"/${PV}/postrelease/88_pr66360.patch
	eapply "${FILESDIR}"/${PV}/postrelease/89_pr105774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/90_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/91_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/92_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/93_pr88754.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-arm-test-fail.patch
	fi
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86 ppc-macos"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr94460.patch
	[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/01_pr94383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr80693-81019-81020.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr81331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr94130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr94809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr81311-83937.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr86274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr81863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr68823.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr84858.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr93246.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr79622.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr80778-84305.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr86617.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr94412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr103908.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr66623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr80533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr71351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr81613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr91966.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr65211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr65782.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr80983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr83860.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr57448-67458-78778-80640-81316.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr94947.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr108365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr80306.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr93402.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr93262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr81423.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr85805.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr94361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr97285.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr97063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr89434-89506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr71598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr88936.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr106032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr103630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr90313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr84543.patch
	eapply "${FILESDIR}"/${PV}/postrelease/61_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/62_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/63_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/64_pr90348.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/92_fix-arm-test-fail.patch
	fi
}

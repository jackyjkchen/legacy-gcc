# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 loong m68k mips ppc ppc64 riscv s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch
	is_djgpp || eapply "${FILESDIR}"/${PV}/02_fix-ia32-sanitizer-malloc.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr100934.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr101173.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr103181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr100672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr94616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr94206.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr65211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr83860.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr108365.patch
	[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/18_pr94383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr93262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr71598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr88936.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr86853.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr106032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr103630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr105502.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr90796.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr89434-89506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr85960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr101698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr90664.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr100227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr96657.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr84543.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr90348.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/92_fix-arm-test-fail.patch
		[[ $(tc-arch) == "loong" ]] && eapply "${FILESDIR}"/${PV}/postrelease/93_fix-loong-test-fail.patch
	fi
}

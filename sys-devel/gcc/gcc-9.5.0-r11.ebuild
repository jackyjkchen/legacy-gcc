# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 loong m68k mips ppc ppc64 riscv s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr107107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr53932.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr108365.patch
	[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/07_pr94383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr93262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr106032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr97474.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr108636.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr87103-93473-95687.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr89925.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr89563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr101156.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/92_fix-arm-test-fail.patch
		[[ $(tc-arch) == "loong" ]] && eapply "${FILESDIR}"/${PV}/postrelease/93_fix-loong-test-fail.patch
	fi
}

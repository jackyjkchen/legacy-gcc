# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_GCC_VER="10.5.0"
PATCH_VER="6"
MUSL_GCC_VER="10.5.0"
MUSL_VER="2"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86"

src_prepare() {
	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch" || die
	fi

	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr92815.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr89583.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr108076.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr109263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr95620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr110914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr89925.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr111764.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr90348.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr93444-107833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr97219.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr100394.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr100061-105142.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr99531-100623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr53164-105848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr101260.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr101419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr101839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr101885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr104996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr105980.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr96383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr85620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr97952.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr93762-100651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr107372.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr104447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr101555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr100393.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr102804.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr105809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr108242.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr102651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr105481.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr104474.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr98614-104802.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr88580.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr102163.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr67048.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr94799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr86430.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr97134.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr109761.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr114147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr102338.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr59238.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr90107.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-arm-test-fail.patch
	fi
}

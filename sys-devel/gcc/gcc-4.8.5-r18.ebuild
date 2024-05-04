# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77450-77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr77943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr70022-70484-70931-71452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr61068.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr68963.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr62258.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr68814-69166-69239-69252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr58943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr69195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr71083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr67770.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr67736.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr71086.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr65235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr69891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr70809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr69307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr77933.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr70235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr64905.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr63347.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr60392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr65358.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr23827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr63408.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr61741.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr60718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr58579.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr65734.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr3698-86208.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-arm-test-fail.patch
		# gcc-4.8.5 on aarch64, pch case random build crash
		[[ $(tc-arch) == "arm64" ]] && rm -rf gcc/testsuite/gcc.dg/pch gcc/testsuite/g++.dg/pch gcc/testsuite/objc.dg/pch
	fi
}

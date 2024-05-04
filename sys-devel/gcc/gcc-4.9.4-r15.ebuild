# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	case $(tc-arch) in
		sh)
			eapply "${FILESDIR}"/${PV}/01_remove-gtoggle-stage2.patch
			;;
	esac
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77450-77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr64172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr68390.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr68814-69003-69166-69239-69252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr67037.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr71086.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr77943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr63373.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr57566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr69838.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr71216.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr83687.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr66695-77746-79485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr69307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr68963.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr71083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr77933.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr64905.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr67736.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr36043-58744-65408.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr71795.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr65358.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr56956.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr23827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr63148.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr60718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr65734.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr60651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr65077.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr71976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr3698-86208.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-arm-test-fail.patch
	fi
}

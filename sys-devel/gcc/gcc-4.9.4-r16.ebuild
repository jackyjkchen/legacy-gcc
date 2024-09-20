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
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr54223-84276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/61_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/62_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/63_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/64_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/65_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/66_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/67_pr87704.patch
	eapply "${FILESDIR}"/${PV}/postrelease/68_pr66575.patch
	eapply "${FILESDIR}"/${PV}/postrelease/69_pr69131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/70_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/71_pr67054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/72_pr77585.patch
	eapply "${FILESDIR}"/${PV}/postrelease/73_pr80227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/74_pr64095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/75_pr57063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/76_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/77_pr60894.patch
	eapply "${FILESDIR}"/${PV}/postrelease/78_pr60943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/79_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/80_pr64970.patch
	eapply "${FILESDIR}"/${PV}/postrelease/81_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/82_pr61683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/83_pr54427-57198-58845.patch
	eapply "${FILESDIR}"/${PV}/postrelease/84_pr77812.patch
	eapply "${FILESDIR}"/${PV}/postrelease/85_pr54891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/86_pr49132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/87_pr90107.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-arm-test-fail.patch
	fi
}

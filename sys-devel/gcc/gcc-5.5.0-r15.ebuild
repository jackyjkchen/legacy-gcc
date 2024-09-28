# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	case $(tc-arch) in
		mips|sh)
			eapply "${FILESDIR}"/${PV}/01_remove-gtoggle-stage2.patch
			;;
	esac
	use go && eapply "${FILESDIR}"/${PV}/02_fix-libgo-for-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/03_fix-building-on-ppc64.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/04_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr85257.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr89009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr84873.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr85859.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr86334-88906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr80533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr84033.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr89794.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr86292.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr84506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr91136.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr83687.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr66695-77746-79485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr68217.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr91126-91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr86505-87024.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr65358.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr66334.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr69487.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr65782.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr85593.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr82621.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr80983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr70509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr86669.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr81735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr69577.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr61817-69391.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr79388-79450.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr82274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr54223-84276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr101087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr60095-69009-69515-71875.patch
	eapply "${FILESDIR}"/${PV}/postrelease/61_pr82294-87436.patch
	eapply "${FILESDIR}"/${PV}/postrelease/62_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/63_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/64_pr90951.patch
	eapply "${FILESDIR}"/${PV}/postrelease/65_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/66_pr87366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/67_pr87704.patch
	eapply "${FILESDIR}"/${PV}/postrelease/68_pr66575.patch
	eapply "${FILESDIR}"/${PV}/postrelease/69_pr76490.patch
	eapply "${FILESDIR}"/${PV}/postrelease/70_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/71_pr84671.patch
	eapply "${FILESDIR}"/${PV}/postrelease/72_pr77844.patch
	eapply "${FILESDIR}"/${PV}/postrelease/73_pr49070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/74_pr82307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/75_pr70229.patch
	eapply "${FILESDIR}"/${PV}/postrelease/76_pr67054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/77_pr77585.patch
	eapply "${FILESDIR}"/${PV}/postrelease/78_pr80227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/79_pr64095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/80_pr70288.patch
	eapply "${FILESDIR}"/${PV}/postrelease/81_pr71448.patch
	eapply "${FILESDIR}"/${PV}/postrelease/82_pr59342.patch
	eapply "${FILESDIR}"/${PV}/postrelease/83_pr69139.patch
	eapply "${FILESDIR}"/${PV}/postrelease/84_pr66360.patch
	eapply "${FILESDIR}"/${PV}/postrelease/85_pr105774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/86_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/87_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/88_pr53856.patch
	eapply "${FILESDIR}"/${PV}/postrelease/89_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/90_pr35299.patch
	eapply "${FILESDIR}"/${PV}/postrelease/91_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/92_pr16333-41426-59878-66895.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-arm-test-fail.patch
	fi
}

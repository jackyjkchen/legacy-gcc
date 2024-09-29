# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-4.2.5-without-change-version.patch
	eapply "${FILESDIR}"/${PV}/01_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/03_add-.note.GNU-stack.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/04_backport-static-libstdc++-option.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr33619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr35202.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr36300.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr34947.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr36742.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr35616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr46010.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr31198.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr34154.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr31210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr33288.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr31211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr31295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr32962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr31399.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr31203.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr33139.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr44555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr39855.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr25243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr29400.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr31530.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr38852.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr35685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr32244.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr43438.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr43555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr36137.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr35067.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr39528.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr35743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr36613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr38615.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr20416.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr39371.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr39365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr45777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/48_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/49_pr34178.patch
	eapply "${FILESDIR}"/${PV}/postrelease/50_pr28812-28834-29436.patch
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr39987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/52_pr37971.patch
	eapply "${FILESDIR}"/${PV}/postrelease/53_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/54_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/55_pr42655.patch
	eapply "${FILESDIR}"/${PV}/postrelease/56_pr41972.patch
	eapply "${FILESDIR}"/${PV}/postrelease/57_pr40566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/58_pr39295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/59_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/60_pr36089-37561.patch
	eapply "${FILESDIR}"/${PV}/postrelease/61_pr36432.patch
	eapply "${FILESDIR}"/${PV}/postrelease/62_pr33553.patch
	eapply "${FILESDIR}"/${PV}/postrelease/63_pr37877.patch
	eapply "${FILESDIR}"/${PV}/postrelease/64_pr31250.patch
	eapply "${FILESDIR}"/${PV}/postrelease/65_pr28274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/66_pr29236.patch
	eapply "${FILESDIR}"/${PV}/postrelease/67_pr32103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/68_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/69_pr31144.patch
	eapply "${FILESDIR}"/${PV}/postrelease/70_pr29928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/71_pr31222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/72_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/73_pr30746.patch
	eapply "${FILESDIR}"/${PV}/postrelease/74_pr30818.patch
	eapply "${FILESDIR}"/${PV}/postrelease/75_pr33516.patch
	eapply "${FILESDIR}"/${PV}/postrelease/76_pr33616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/77_pr30363.patch
	eapply "${FILESDIR}"/${PV}/postrelease/78_pr32906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/79_pr34213.patch
	eapply "${FILESDIR}"/${PV}/postrelease/80_pr34364.patch
	eapply "${FILESDIR}"/${PV}/postrelease/81_pr38950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/82_pr23287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/83_pr21008.patch
	eapply "${FILESDIR}"/${PV}/postrelease/84_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/85_pr14050.patch
	eapply "${FILESDIR}"/${PV}/postrelease/86_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/87_pr19977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/88_pr35650.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
		[[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail-x86.patch
		[[ $(tc-arch) == "arm" ]] && rm -rf gcc/testsuite/obj-c++.dg/try-catch-11.mm
	fi
}

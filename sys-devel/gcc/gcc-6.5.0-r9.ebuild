# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="6"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} != cross-* ]] ; then
	BDEPEND="sys-devel/gcc:9.5.0"
	CC="gcc-9.5.0"
	CXX="g++-9.5.0"
else
	BDEPEND="sys-devel/gcc:6.5.0"
	CC="gcc-6.5.0"
	CXX="g++-6.5.0"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_compat-new-isl.patch

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
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr57448-67458-78778-80640-81316.patch
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
	eapply "${FILESDIR}"/${PV}/postrelease/51_pr91927.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}
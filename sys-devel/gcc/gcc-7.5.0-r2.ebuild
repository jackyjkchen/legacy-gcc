# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="4"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86 ppc-macos"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} != cross-* ]] ; then
	BDEPEND="sys-devel/gcc:9.5.0"
	CC="gcc-9.5.0"
	CXX="g++-9.5.0"
else
	BDEPEND="sys-devel/gcc:7.5.0"
	CC="gcc-7.5.0"
	CXX="g++-7.5.0"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr94383.patch
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
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr90018.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr93246.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr99954.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr80778-84305.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr86617.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr94412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr90320.patch
}

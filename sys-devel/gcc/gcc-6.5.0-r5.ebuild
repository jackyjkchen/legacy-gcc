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

	eapply "${FILESDIR}"/${PV}/00_fix-isl-version.patch

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
}

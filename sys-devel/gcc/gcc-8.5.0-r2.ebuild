# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="2"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} != cross-* ]] ; then
	BDEPEND="sys-devel/gcc:9.5.0"
	CC="gcc-9.5.0"
	CXX="g++-9.5.0"
else
	BDEPEND="sys-devel/gcc:8.5.0"
	CC="gcc-8.5.0"
	CXX="g++-8.5.0"
fi

src_prepare() {
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/postrelease/00_ppc64le-pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr100934.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr101173.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr103181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr100672.patch
}

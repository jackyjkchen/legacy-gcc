# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
	BDEPEND="sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
else
	BDEPEND="sys-devel/gcc:4.6.4"
	CC="gcc-4.6.4"
	CXX="g++-4.6.4"
fi

src_prepare() {
	! use vanilla && eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr56899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr60485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr52413.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}

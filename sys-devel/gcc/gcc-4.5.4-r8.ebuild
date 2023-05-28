# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
	BDEPEND="sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
else
	BDEPEND="sys-devel/gcc:4.5.4"
	CC="gcc-4.5.4"
	CXX="g++-4.5.4"
fi

src_prepare() {
	! use vanilla && eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr78185.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr53922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr56810.patch
}

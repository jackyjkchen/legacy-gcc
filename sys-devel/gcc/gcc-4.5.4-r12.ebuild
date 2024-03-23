# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} != cross-* ]] ; then
	BDEPEND="sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
else
	BDEPEND="sys-devel/gcc:4.5.4"
	CC="gcc-4.5.4"
	CXX="g++-4.5.4"
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch

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
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr40850.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr47844.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr46083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr49897-49898.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr44696.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr44290.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr56539.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr38392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr3698-86208.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
}

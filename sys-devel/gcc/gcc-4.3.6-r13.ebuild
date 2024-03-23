# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} != cross-* ]] ; then
	BDEPEND="sys-devel/gcc:4.4.7"
	CC="gcc-4.4.7"
	CXX="g++-4.4.7"
else
	BDEPEND="sys-devel/gcc:4.3.6"
	CC="gcc-4.3.6"
	CXX="g++-4.3.6"
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/03_backport-static-libstdc++-option.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr50109.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr35202.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr46010.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr44942.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr35685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr56015.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr45312.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr42240.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr43419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr35729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr44996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr48837.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr39633.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr39365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr43841.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr43228.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr40962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr45777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr32000.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr3698-86208.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	is_crosscompile || ([[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-known-test-fail-x86.patch)
}

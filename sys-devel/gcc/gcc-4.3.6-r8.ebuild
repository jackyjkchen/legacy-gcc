# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
	BDEPEND="sys-devel/gcc:4.4.7"
	CC="gcc-4.4.7"
	CXX="g++-4.4.7"
else
	BDEPEND="sys-devel/gcc:4.3.6"
	CC="gcc-4.3.6"
	CXX="g++-4.3.6"
fi

src_prepare() {
	! use vanilla && eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/03_backport-static-libstdc++-option.patch

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

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

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}
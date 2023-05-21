# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="3"

# Hardened gcc 4 stuff
PIE_VER="1"
SPECS_VER="0.2.0"
SPECS_GCC_VER="4.4.3"
# arch/libc configurations known to be stable with {PIE,SSP}-by-default
PIE_GLIBC_STABLE="x86 amd64 mips ppc ppc64 arm ia64"
SSP_STABLE="amd64 x86 mips ppc ppc64 arm"
#end Hardened stuff

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
	BDEPEND="sys-devel/gcc:9.5.0"
	CC="gcc-9.5.0"
	CXX="g++-9.5.0"
else
	BDEPEND="sys-devel/gcc:5.5.0"
	CC="gcc-5.5.0"
	CXX="g++-5.5.0"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_fix-building-on-ppc64.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-bootstrap-for-sh4.patch
	use go && eapply "${FILESDIR}"/${PV}/02_fix-libgo-for-new-glibc.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr85257.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr89009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr84873.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr85859.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr86334-88906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr80533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr84033.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr89794.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr86292.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr84506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr91136.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr83687.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr66695-77746-79485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr68217.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr91126-91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr62052-69889.patch

	eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}

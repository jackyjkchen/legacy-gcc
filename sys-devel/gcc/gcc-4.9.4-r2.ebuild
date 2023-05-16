# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="2"

# Hardened gcc 4 stuff
PIE_VER="0.6.4"
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
	BDEPEND="sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
fi

src_prepare() {
	# Bug 638056
	eapply "${FILESDIR}/${P}-bootstrap.patch"

	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/00_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-bootstrap-for-sh4.patch

	# Use -r1 for newer pieapplyet that use DRIVER_SELF_SPECS for the hardened specs.
	[[ ${CHOST} == ${CTARGET} ]] && eapply "${FILESDIR}"/gcc-spec-env-r1.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77436-77450-77605-77855-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr64172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr68390.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr69014.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr69166-69239-69252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr71700.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr67037.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr71086.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr86334.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr77943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr106513.patch
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="1.5"

# Hardened gcc 4 stuff
PIE_VER="0.6.2"
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
	BDEPEND="sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
else
	BDEPEND="sys-devel/gcc:4.8.5"
	CC="gcc-4.8.5"
	CXX="g++-4.8.5"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/00_mips64-default-n64-abi.patch

	#Use -r1 for newer pieapplyet that use DRIVER_SELF_SPECS for the hardened specs.
	[[ ${CHOST} == ${CTARGET} ]] && eapply "${FILESDIR}"/gcc-spec-env-r1.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77450-77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr77943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr70022-70484-70931-71452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr61068.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr68963.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr62258.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr68814-69166-69239-69252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr58943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr69195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr71083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr67770.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr67736.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr70007.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr71086.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr65235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr69891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr70809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr69307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr77933.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr70235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr64905.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr63347.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr60392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr56810.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}

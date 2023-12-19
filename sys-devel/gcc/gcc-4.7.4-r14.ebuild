# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="1.6"

# Hardened gcc 4 stuff
PIE_VER="0.5.5"
SPECS_VER="0.2.0"
SPECS_GCC_VER="4.4.3"
# arch/libc configurations known to be stable with {PIE,SSP}-by-default
PIE_GLIBC_STABLE="x86 amd64 ppc ppc64 arm ia64"
SSP_STABLE="amd64 x86 ppc ppc64 arm"
#end Hardened stuff

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} != cross-* ]] ; then
	BDEPEND="sys-devel/gcc:4.9.4"
	CC="gcc-4.9.4"
	CXX="g++-4.9.4"
else
	BDEPEND="sys-devel/gcc:4.7.4"
	CC="gcc-4.7.4"
	CXX="g++-4.7.4"
fi

src_prepare() {
	toolchain_src_prepare
	use vanilla && return 0

	[[ $(tc-arch) == "alpha" ]] && eapply "${FILESDIR}"/${PV}/00_fix-alpha-bootstrap.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/02_fix-cpp98-break.patch
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch
	[[ ${CHOST} == ${CTARGET} ]] && eapply "${FILESDIR}"/gcc-spec-env.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr58943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr70931-71452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr81977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr67770.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr60766.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr11750.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr52448.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr53636.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr51447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr77933.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr60392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr58574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr60454.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr62031-63379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr60276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr56899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr60485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr58653.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr48814.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/42_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/43_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/44_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/45_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/46_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/47_pr3698-86208.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
}

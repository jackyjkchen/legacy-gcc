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
	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/27_all_disable-riscv32-ABIs.patch" || die
	fi
	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_riscv-fix-multilib.patch
	eapply "${FILESDIR}"/${PV}/01_fix-ia32-sanitizer-malloc.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr100934.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr101173.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr103181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr100672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr94616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr94206.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr65211.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}

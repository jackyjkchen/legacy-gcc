# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_GCC_VER="10.5.0"
PATCH_VER="6"
MUSL_GCC_VER="10.5.0"
MUSL_VER="2"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} == cross-* ]] ; then
	BDEPEND="${BDEPEND} sys-devel/gcc:10"
	CC="gcc-10"
	CXX="g++-10"
fi

src_prepare() {
	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch" || die
	fi

	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_workaround-for-gcc12-host.patch
	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr92815.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr89583.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	is_crosscompile || ([[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-armel-test-fail.patch)
}

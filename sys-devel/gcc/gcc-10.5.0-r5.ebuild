# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_GCC_VER="10.5.0"
PATCH_VER="6"
MUSL_GCC_VER="10.5.0"
MUSL_VER="2"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86"

src_prepare() {
	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch" || die
	fi

	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr92815.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr89583.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr108076.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr109263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr95620.patch

	is_crosscompile || rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.dg/format/opt-*.c
	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	is_crosscompile || ([[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-aarch64-test-fail.patch)
	is_crosscompile || ([[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/92_fix-arm-test-fail.patch)
}

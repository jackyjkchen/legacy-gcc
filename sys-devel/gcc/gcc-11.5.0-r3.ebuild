# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TOOLCHAIN_PATCH_DEV="sam"
PATCH_GCC_VER="11.5.0"
PATCH_VER="12"
MUSL_VER="2"
MUSL_GCC_VER="11.5.0"
PYTHON_COMPAT=( python3_{10..12} )

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86"

if [[ ${CATEGORY} != cross-* ]] ; then
	# Technically only if USE=hardened *too* right now, but no point in complicating it further.
	# If GCC is enabling CET by default, we need glibc to be built with support for it.
	# bug #830454
	RDEPEND="elibc_glibc? ( sys-libs/glibc[cet(-)?] )"
	DEPEND="${RDEPEND}"
fi

src_prepare() {
	local p upstreamed_patches=(
		# add them here
	)
	for p in "${upstreamed_patches[@]}"; do
		rm -v "${WORKDIR}/patch/${p}" || die
	done

	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr111224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr100130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr93444-107833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr97219.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr100394.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr100061-105142.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr99531-100623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr100740-101508-101972-102131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr101260.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr101419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr101839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr101885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr114924.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr104996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr105980.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr53164-105848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr51577-97279.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/91_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/92_fix-arm-test-fail.patch
	fi
}

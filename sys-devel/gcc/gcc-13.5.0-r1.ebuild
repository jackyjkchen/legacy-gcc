# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintenance notes and explanations of GCC handling are on the wiki:
# https://wiki.gentoo.org/wiki/Project:Toolchain/sys-devel/gcc

PATCH_GCC_VER="13.5.0"
PATCH_VER="9"
MUSL_GCC_VER="13.5.0"
MUSL_VER="3"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa loong m68k mips ppc ppc64 riscv s390 sh sparc x86"

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

	eapply "${FILESDIR}"/${PV}/01_fix-cross-fixincludes.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/10_fix-libbacktrace.patch
	eapply "${FILESDIR}"/${PV}/11_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/12_fix-break-pr78794.patch
	eapply "${FILESDIR}"/${PV}/13_gcc-loong.patch

	eapply "${FILESDIR}"/${PV}/postrelease/001_pr113486.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr59465.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr119380.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr98645-98688-111224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr114019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr53220-94264-112658.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr101195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr112995.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr112366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr116463.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr118137.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr113413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr119054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr86869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr112487.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr112830.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr112411.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr113509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr112610.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr112785.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr105475.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr106363.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr110251.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr113835.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr118400.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr114170.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr109772.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.target/aarch64/cpunative/native_cpu_18.c gcc/testsuite/gcc.target/arm/asm-flag-7.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
		[[ $(tc-arch) == "mips" ]] && eapply "${FILESDIR}"/${PV}/postrelease/903_fix-mips-test-fail.patch && \
			rm -rf gcc/testsuite/gcc.target/mips/mips-nonpic gcc/testsuite/gcc.target/mips/interrupt_handler-5.c
		[[ $(tc-arch) == "riscv" ]] && eapply "${FILESDIR}"/${PV}/postrelease/904_fix-riscv-test-fail.patch
	fi
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintenance notes and explanations of GCC handling are on the wiki:
# https://wiki.gentoo.org/wiki/Project:Toolchain/sys-devel/gcc

PATCH_GCC_VER="12.5.0"
PATCH_VER="4"
MUSL_GCC_VER="12.5.0"
MUSL_VER="4"

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

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/10_fix-libbacktrace.patch
	eapply "${FILESDIR}"/${PV}/11_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/12_fix-aarch64-fcsel_1.patch
	[[ $(tc-arch) == "arm64" || $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/13_gcc-arm.patch
	eapply "${FILESDIR}"/${PV}/14_remove-riscv_cmodel_pic.patch

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr98645-98688-111224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr83782.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr85620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr96637.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr109172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr106937.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr59465.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr110535.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr103590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr90658.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr96745.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr101195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr100545.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr113799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr110524.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr93678.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr103825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr102600-106848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr112366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr93762-100651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr97592.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr110106.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr112995.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr114052.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr102844-111465.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr110799-113630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr67196.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr116706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr93046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr47634-101833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr107508.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr53220-94264-112658.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr118047-118355.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr116906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr112411.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr101533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr109678.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr119054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr106858.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr117979.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr115657.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr98845.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr70418-106465-107557-108423.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr116681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr102553-103346-104278.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr113673.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr114709.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr112684.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr115608.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr107976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr107033.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr114292.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr95036-104107-108179.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr101886.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr106132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr105927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr100252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr101587.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr82774-87946-100193-105152.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr108158.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr105717.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr87497.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_revert-pr117763-109345.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr105225.patch
	is_cygwin || eapply "${FILESDIR}"/${PV}/postrelease/071_pr93371.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr104290.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr123102.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr119291-121773.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr124315.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr83865.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr116379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr114019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr93715.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr123991.patch
	[[ $(tc-arch) == "arm64" || $(tc-arch) == "arm" ]] || eapply "${FILESDIR}"/${PV}/postrelease/081_pr116454.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr123416.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr120987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr111036.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr121370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr123121.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr123602.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr120944.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr119085.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr115260.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr120182.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr113831.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr111683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr101188.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr125611.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr125025.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr86869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr116960-119303.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr121870.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr124132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr112830.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr112610.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr112785.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr120757.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr121771.patch

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

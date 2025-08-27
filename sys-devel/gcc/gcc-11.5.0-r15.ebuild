# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_GCC_VER="11.5.0"
PATCH_VER="12"
MUSL_VER="2"
MUSL_GCC_VER="11.5.0"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa m68k mips ppc ppc64 riscv s390 sparc x86"

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
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/03_fix-libbacktrace.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr98645-98688-111224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr100130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr93444-107833-107839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr97219.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr100394.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr100061-105142.patch
	[[ $(tc-arch) != "sh" ]] && eapply "${FILESDIR}"/${PV}/postrelease/007_pr99531-100623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr51577-97279.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr101260.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr101419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr101839-106057.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr101885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr114924.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr104996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr105980.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr53164-105848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr105157-116029.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr85620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr97952.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr93762-100651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr104447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr54052.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr101555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr102804.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr105809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr108242.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr102651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr107853.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr105481.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr105842.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr98614-104802.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr105106-105652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr66641-101582.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr88580.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr67048.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr102338.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr112366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr104583.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr103825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr104558.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr103868.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr111497.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr103676.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr108566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr112995.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr106982.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr102987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr105247.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr101702.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr115143.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr105532.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr103074.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr71703.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr106132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr108597.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr109160.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr102600-106848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr107574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr110106.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr107938.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr100127.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr107755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr103326.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr98619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr93678.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr110524.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr80270.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr108104.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr106937.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr113799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr101731.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr100545.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr101195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr105149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr103590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr103852.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr104623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr98644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr90658.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr110535.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr83873-97604.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr59465.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr39751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr109172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr77693.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr65396.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr79181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr114052.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr110799-113630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr116706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr87984.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr93672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr117432.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr116034.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr116287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr106692.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr47634-101833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr116768.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr117811.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr91299.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr116891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr66279.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr117574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr112411.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr116641.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr117113.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr117417.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr114246.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr116850.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr79786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr116922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr101533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr98487.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr115913.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr98845.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr119054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr118717.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr117254.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr101478.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr114501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr117357.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr117318.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr117418.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr117296.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr117240.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr115646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr108158.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr87497.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr112684.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr115608.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr107976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr114292.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr95036-104107-108179.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr101587.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr100252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr101886.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr82774-87946-100193.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr116108.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr120123.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.target/aarch64/cpunative/native_cpu_18.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
	fi
}

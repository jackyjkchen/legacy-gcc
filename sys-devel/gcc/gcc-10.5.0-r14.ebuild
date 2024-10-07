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

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr92815.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr89583.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr108076.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr109263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr95620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr110914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr89925.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr111764.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr90348.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr93444-107833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr97219.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr100394.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr100061-105142.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr99531-100623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr53164-105848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr101260.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr101419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr101839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr101885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr104996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr105980.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr96383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr85620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr97952.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr93762-100651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr107372.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr104447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr101555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr100393.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr102804.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr105809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr108242.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr102651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr105481.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr114474.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr98614-104802.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr88580.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr102163.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr67048.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr94799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr86430.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr97134.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr109761.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr114147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr102338.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr59238.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr104583.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr97990-112732.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr95009-103825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr110386.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr104558.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr111497.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr107574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr106982.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr102987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr115143.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr112718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr110295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr111917.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr110298.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr71703.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr88309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr105263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr109473.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr114310.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr103703.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr105725.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr105064.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr106675.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr102990.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr99893-103885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr104507.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr91706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr101030.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr100106.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr100239.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr100127.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr97034-99009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr95317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr99123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr99223.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr97900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr98056.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr96391-100796.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr103326.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr108975.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr107755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr98458.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr99585.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr93678.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr96806.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr98075.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr99281.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr96915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr112816.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr114493.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr89565-93383-95291-99200-99683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr111407.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr58646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr113598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr66833-67938-95214.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr80270.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr108104.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr106937.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr113799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr101731.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
	fi
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa loong m68k mips ppc ppc64 riscv s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch
	is_djgpp || eapply "${FILESDIR}"/${PV}/03_fix-sanitizer-glibc-2.42.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr107107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr53932.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr108365.patch
	[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/007_pr94383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr93262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr106032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr97474.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr108636.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr87103-93473-95687.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr89925.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr89563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr90348-110115-111422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr93444-107833-107839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr97219.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr53164-105848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr101419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr101839-106057.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr89355.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr85620.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr97952.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr93762-100651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr92807.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr97969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr105481.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr102804.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr105809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr108242.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr102651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr98614-104802.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr101087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr67048.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr97420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr101194.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr94799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr86430.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr49070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr82980.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr59238.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr105774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr107482-109137.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr104637.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr97990-112732.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr110386.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr104558.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr111497.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr114310.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr102987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr112718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr110295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr111917.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr71703.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr105998.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr88309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr105173.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr105263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr105163.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr103596.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr104337.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr102990.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr99893-103885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr91706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr101030.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr95317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr99123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr99323.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr103326.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr108975.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr107755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr91102.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr98458.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr96291.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr91241.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr96197.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr96935.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr99281.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr95171.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr90996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr94628.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr93678.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr99201.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr90981.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr95164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr111407.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr94346.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr114493.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr104777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr86973.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr106675.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr86216.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr107304.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr106751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr58646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr113598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr90178-90257.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr80270.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr108104.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr60855.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr101731.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr95009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr106261.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr107863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr101195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr105149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr100783.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr114634.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr105813.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr104944.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr105844.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr66477.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr99478.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr90658.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr101762.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr97358.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr93314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr85877.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr92799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr89875.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr91759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr107426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr103590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr110535.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr94040.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr61490.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr64235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr83873-97604.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr44960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr79181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr109172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr89224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr77693.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr39751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr93272.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr67791.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr114052.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr116706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr87984.patch
	eapply "${FILESDIR}"/${PV}/postrelease/171_pr112411.patch
	eapply "${FILESDIR}"/${PV}/postrelease/172_pr116034.patch
	eapply "${FILESDIR}"/${PV}/postrelease/173_pr116287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/174_pr106692.patch
	eapply "${FILESDIR}"/${PV}/postrelease/175_pr93672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/176_pr117811.patch
	eapply "${FILESDIR}"/${PV}/postrelease/177_pr91299.patch
	eapply "${FILESDIR}"/${PV}/postrelease/178_pr116891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/179_pr66279.patch
	eapply "${FILESDIR}"/${PV}/postrelease/180_pr117574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/181_pr117113.patch
	eapply "${FILESDIR}"/${PV}/postrelease/182_pr116850.patch
	eapply "${FILESDIR}"/${PV}/postrelease/183_pr79786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/184_pr101533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/185_pr98845.patch
	eapply "${FILESDIR}"/${PV}/postrelease/186_pr117254.patch
	eapply "${FILESDIR}"/${PV}/postrelease/187_pr114501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/188_pr115646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/189_pr117357.patch
	eapply "${FILESDIR}"/${PV}/postrelease/190_pr117296.patch
	eapply "${FILESDIR}"/${PV}/postrelease/191_pr114292.patch
	eapply "${FILESDIR}"/${PV}/postrelease/192_pr112684.patch
	eapply "${FILESDIR}"/${PV}/postrelease/193_pr111039.patch
	eapply "${FILESDIR}"/${PV}/postrelease/194_pr115608.patch
	eapply "${FILESDIR}"/${PV}/postrelease/195_pr105600.patch
	eapply "${FILESDIR}"/${PV}/postrelease/196_pr82774-87946-100193.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
		[[ $(tc-arch) == "loong" ]] && eapply "${FILESDIR}"/${PV}/postrelease/903_fix-loong-test-fail.patch
		[[ $(tc-arch) == "mips" ]] && eapply "${FILESDIR}"/${PV}/postrelease/904_fix-mips-test-fail.patch && \
			rm -rf gcc/testsuite/gcc.target/mips/mips-nonpic gcc/testsuite/gcc.target/mips/interrupt_handler-5.c
	fi
}

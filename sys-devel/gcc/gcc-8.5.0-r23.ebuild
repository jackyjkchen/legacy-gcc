# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 loong m68k mips ppc ppc64 riscv s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch
	is_djgpp || eapply "${FILESDIR}"/${PV}/02_fix-ia32-sanitizer-malloc.patch
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr100934.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr101173.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr103181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr100672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr87150-90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr94616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr94206.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr65211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr83860.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr108365.patch
	[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/018_pr94383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr93262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr71598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr88936.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr86853.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr106032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr103630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr105502.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr90796.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr89434-89506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr85960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr101698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr90664.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr100227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr97164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr104931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr106027.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr96657.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr84543.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr90348.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr93444-107833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr97219.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr101839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr53164-105848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr89355.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr105809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr108242.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr102651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr105481.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr98614-104802.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr67048.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr101087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr94799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr86430.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr80456.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr85977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr93442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr90212.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr87366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr86986.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr88123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr85569.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr86379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr49070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr59950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr105774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr98249.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr104558.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr111497.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr112718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr110295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr111917.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr71703.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr105173.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr105263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr105163.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr105211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr103455.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr104675.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr103596.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr99893-103885.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr104786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr100509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr114310.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr95317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr99123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr99323.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr103326.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr108975.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr107755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr102548.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr99466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr98458.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr96291.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr91241.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr96197.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr99281.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr95171.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr95870.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr96282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr95560.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr94628.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr93678.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr93794.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr92976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr103392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr99201.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr95164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr111407.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr89399.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr106675.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr93439.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr104777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr104451.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr85876.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr90765.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr86962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr89376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr87374.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr79342.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr88070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr87874.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr86397.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr85769.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr79585-90750.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr79308-89744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr80960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr94780.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr66679.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr86216.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr107304.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr106751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr58646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr113598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr101731.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr80270.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr60855.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr58836-60223-65707-89480.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr95009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr106261.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr107863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr101195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/171_pr105149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/172_pr85877.patch
	eapply "${FILESDIR}"/${PV}/postrelease/173_pr105813.patch
	eapply "${FILESDIR}"/${PV}/postrelease/174_pr100786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/175_pr104944.patch
	eapply "${FILESDIR}"/${PV}/postrelease/176_pr90658.patch
	eapply "${FILESDIR}"/${PV}/postrelease/177_pr101762.patch
	eapply "${FILESDIR}"/${PV}/postrelease/178_pr64235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/179_pr92799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/180_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/181_pr91759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/182_pr90138.patch
	eapply "${FILESDIR}"/${PV}/postrelease/183_pr89601.patch
	eapply "${FILESDIR}"/${PV}/postrelease/184_pr107426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/185_pr103590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/186_pr110535.patch
	eapply "${FILESDIR}"/${PV}/postrelease/187_pr93753.patch
	eapply "${FILESDIR}"/${PV}/postrelease/188_pr89875.patch
	eapply "${FILESDIR}"/${PV}/postrelease/189_pr86932-89966.patch
	eapply "${FILESDIR}"/${PV}/postrelease/190_pr66477.patch
	eapply "${FILESDIR}"/${PV}/postrelease/191_pr86218.patch
	eapply "${FILESDIR}"/${PV}/postrelease/192_pr83873-97604.patch
	eapply "${FILESDIR}"/${PV}/postrelease/193_pr30552.patch
	eapply "${FILESDIR}"/${PV}/postrelease/194_pr84605.patch
	eapply "${FILESDIR}"/${PV}/postrelease/195_pr89970.patch
	eapply "${FILESDIR}"/${PV}/postrelease/196_pr39751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/197_pr81506-84644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/198_pr85537.patch
	eapply "${FILESDIR}"/${PV}/postrelease/199_pr69499.patch
	eapply "${FILESDIR}"/${PV}/postrelease/200_pr86608.patch
	eapply "${FILESDIR}"/${PV}/postrelease/201_pr89224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/202_pr79181.patch
	eapply "${FILESDIR}"/${PV}/postrelease/203_pr109172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/204_pr85956.patch
	eapply "${FILESDIR}"/${PV}/postrelease/205_pr101535.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/c-c++-common/Warray-bounds-2.c gcc/testsuite/c-c++-common/Wrestrict-2.c gcc/testsuite/g++.dg/warn/Wstringop-truncation-1.C
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
		[[ $(tc-arch) == "loong" ]] && eapply "${FILESDIR}"/${PV}/postrelease/903_fix-loong-test-fail.patch
	fi
}

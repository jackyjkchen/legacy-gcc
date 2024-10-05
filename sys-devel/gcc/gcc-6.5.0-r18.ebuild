# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	use graphite && eapply "${FILESDIR}"/${PV}/01_compat-new-isl.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr80693-81019-81020.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr88563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr89679.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr68823.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr90328.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr94412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr103908.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr80533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr86334-88906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr79622.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr89794.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr89009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr91136.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr66695-77746-79485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr91126-91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr69487.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr65782.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr85593.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr80983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr86669.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr83860.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr94947.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr108365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr87597.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr89434-89506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr61504.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr60702.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr79388-79450.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr80306.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr83316.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr71488.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr74563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr81740.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr93402.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr81423.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr51333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr85118.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr101087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr81740-89392-89725-90006.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr67054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr82294-87436.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr84988.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr91308.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr90951.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr77585.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr88103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr87366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr84463.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr87734.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr66575.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr81589.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr49070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr82307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr79960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr80227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr64095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr71965.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr72813.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr66443.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr70229.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr66360.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr105774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr110295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr105163.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr104675.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr99123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr100509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr107755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr98786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr89574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr103326.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr98458.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr91241.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr96197.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr95171.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr94780.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr94438.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr93073.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr103392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr95164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr90278.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr90194.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr104451.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr92899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr93140.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr90075.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr85876.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr89296-89572.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr89403.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr88120.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr89400.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr89412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr88379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr88976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr88107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr89223.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr90765.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr89376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr88983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr87674.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr88870.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr88588.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr85422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr85062.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr84985.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr84540.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr84333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr80463-83480-83972.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr83962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr82167.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr84682.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr83957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr81422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr79342.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr80831.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr72801.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr79788-80375.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr78957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr79212.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr71607.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr78884.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr79195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr79308-89744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr80960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr79311.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr78580.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr78774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr78382.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr77959.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr70904.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr69028.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr70992.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr58706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr70689.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
	fi
}

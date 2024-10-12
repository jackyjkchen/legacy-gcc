# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86 ppc-macos"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr94460.patch
	[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/001_pr94383.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr80693-81019-81020.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr81331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr94130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr94809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr101384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr104510.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr81311-83937.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr86274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr81863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr68823.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr84858.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr93246.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr79622.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr80778-84305.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr86617.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr94412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr94509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr103908.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr66623.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr80533.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr44690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr71351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr81613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr91966.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr65211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr109164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr65782.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr80983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr83860.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr57448-67458-78778-80640-81316.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr94947.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr108365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr80306.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr93402.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr93262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr81423.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr85805.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr94361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr97285.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr97063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr89434-89506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr71598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr88936.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr106032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr103630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr90313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr69695.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr78287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr84543.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr111331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr101469.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr101156.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr90348.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr100119.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr116512.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr81917.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr12672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr67048.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr101087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr82294-87436-93949.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr83913.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr80485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr84988.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr94799.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr81933.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr93562.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr90951.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr90736.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr87366.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr86986.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr82307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr49070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr81574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr108550.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr71965.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr105774.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr110295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr111917.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr71703.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr105263.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr105163.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr105211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr104675.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr100509.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr99123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr107755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr102548.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr98786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr89574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr103326.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr98458.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr91241.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr98282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr96197.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr96370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr96579.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr95171.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr94780.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr94438.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr93073.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr92976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr103392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr95164.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr111407.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr104451.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr92899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr92763.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr93140.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr99466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr86159.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr86098-88419-89906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr85876.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr88120.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr87554.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr88379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr90765.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr89376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr88983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr85422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr88235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr83962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr85032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr85356.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr85062.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr84985.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr84540.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr84333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr80463-83480-83972.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr83916.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr84878.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr83530.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr83317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr82167.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr81373.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr79483.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr80763.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr84682.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr83957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr81422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr79342.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr70992.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr79308-89744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr80960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr66679.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr79311.patch
	eapply "${FILESDIR}"/${PV}/postrelease/171_pr115426.patch
	eapply "${FILESDIR}"/${PV}/postrelease/172_pr107304.patch
	eapply "${FILESDIR}"/${PV}/postrelease/173_pr106751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/174_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/175_pr113598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/176_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/177_pr111914.patch
	eapply "${FILESDIR}"/${PV}/postrelease/178_pr58836-60223-65707-89480.patch
	eapply "${FILESDIR}"/${PV}/postrelease/179_pr101731.patch
	eapply "${FILESDIR}"/${PV}/postrelease/180_pr95009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/181_pr106261.patch
	eapply "${FILESDIR}"/${PV}/postrelease/182_pr50892.patch
	eapply "${FILESDIR}"/${PV}/postrelease/183_pr88522.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-aarch64-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-arm-test-fail.patch
	fi
}

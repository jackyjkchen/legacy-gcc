# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr77450-77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr77943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr70022-70484-70931-71452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr61068.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr68963.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr62258.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr68814-69166-69239-69252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr58943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr47992-69195-69238.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr71083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr67770.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr67736.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr71086.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr65235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr69891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr70809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr69307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr59787.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr70235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr64905.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr63347.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr60392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr65358.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr23827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr63408.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr61741.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr60718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr58579.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr65734.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr54223-84276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr66686-96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr68995.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr69116.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr66575.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr61683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr67054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr57063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr60894.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr62255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr64970.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr77812.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr49132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr53017-59211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr60881.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr58704-58753-58930.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr60697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr93140.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr87647.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr88870.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr77919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr81422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr72801.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr79896.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr57728.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr69072-69100.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr78038.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr71103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr72717.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr79641.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr69015.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr70457.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr58706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr70778.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr54442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr71063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr69715-69574-69579.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr58635.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr65491.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr62070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr58671.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr65554.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr70205.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr58749.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr61198.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr58003.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr54440-71833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr58647.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr59477.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr58545.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr52472.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr95009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr53756.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr59645.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr59633.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-arm-test-fail.patch
		# gcc-4.8.5 on aarch64, pch case random build crash
		[[ $(tc-arch) == "arm64" ]] && rm -rf gcc/testsuite/gcc.dg/pch gcc/testsuite/g++.dg/pch gcc/testsuite/objc.dg/pch
	fi
}
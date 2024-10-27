# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "alpha" ]] && eapply "${FILESDIR}"/${PV}/02_fix-alpha-bootstrap.patch
	eapply "${FILESDIR}"/${PV}/03_remove-matrix-reorg.patch
	eapply "${FILESDIR}"/${PV}/04_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr58943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr70931-71452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr81977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr67770.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr60766.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr11750.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr52448.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr53636.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr51447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr58647.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr60392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr58574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr60454.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr62031-63379.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr60276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr56899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr60485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr58653.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr48814.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr66686-96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr77812.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr60894.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr64970.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr61683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr49132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr60361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr56609.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr53017-59211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr53648.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr55972.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr61999.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr87647.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr72801.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr79896.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr57728.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr79641.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr71103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr70778.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr71063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr54442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr58749.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr61058.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr65554.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr58003.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr58595.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr64244.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr61198.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr60108.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr58635.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr55220.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr58814.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr58504.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr58545.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr59388.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr43546.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr52472.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr54472.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr59032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr48184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr55232.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr48766.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr60400.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr48186.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr60182.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr58704-58753-58930.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr54041.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr107863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr71494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr49423.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr72809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr79361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr47220.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr58614.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr56852.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr69323.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr66461.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr77694.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr39751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr63786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr57895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr57848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr89314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr58560.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr71251.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr82872.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr54501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr60628.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr53761.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr85068.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr51148.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr70468.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr58649.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr67803.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr69637.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr69095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr49889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr84729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr56039.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr58810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr53492.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr58636.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr58611.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr58650.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr60374.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr59707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr58843.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr59082.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr60187.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr59989.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr60224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr57499.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr59097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr58980.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr58705.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr32080.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr53055.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr31671.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr20420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr26155.patch
	eapply "${FILESDIR}"/${PV}/postrelease/171_pr81304.patch
	eapply "${FILESDIR}"/${PV}/postrelease/172_pr69128.patch
	eapply "${FILESDIR}"/${PV}/postrelease/173_pr56883.patch
	eapply "${FILESDIR}"/${PV}/postrelease/174_pr63938.patch
	eapply "${FILESDIR}"/${PV}/postrelease/175_pr18969.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c gcc/testsuite/gcc.dg/format/opt-*.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-arm-test-fail.patch
	fi
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	case $(tc-arch) in
		sh)
			eapply "${FILESDIR}"/${PV}/01_remove-gtoggle-stage2.patch
			;;
	esac
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr77450-77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr64172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr68390.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr68814-69003-69166-69239-69252.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr67037.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr71086.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr99123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr77943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr94460.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr96369.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr101442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr105123.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr106513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr63373.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr57566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr69666-69920-69932-69936.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr71216.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr83687.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr70184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr70370.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr66695-77746-79485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr69307.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr68963.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr69720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr82697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr71083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr81505-81977-82084.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr64905.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr67736.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr36043-58744-65408.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr71795.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr38644.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr65358.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr56956.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr23827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr63148.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr60718.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr65734.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr60651.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr55922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr65077.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr71976.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr91927.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr82336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr64697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr54223-84276.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr66686-96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr101869.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr98016.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr12333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr87704.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr66575.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr69131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr67054.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr77585.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr80227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr64095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr57063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr60894.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr60943.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr63149.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr64970.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr63797.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr61683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr54427-57198-58845.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr77812.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr54891.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr49132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr19200.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr89574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr105376.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr60881.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr71833.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr61561.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr93140.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr85876.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr88120.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr90765.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr87647.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr88870.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr84985.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr84511.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr84767.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr83930.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr83898.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr77919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr81422.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr67278.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr72801.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr79896.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr57728.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr70406.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr78038.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr79195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr70904.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr80392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr79311.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr80141.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr72717.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr79396.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr79641.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr77959.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr80385.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr69072-69100.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr58706.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr70778.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr69102.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr69888-70062.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr58671.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr71063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr57664.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr58749.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr65491.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr62070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr70205.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr113598.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr58003.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr112494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr112887.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr95009.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr58597.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr60040.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr69742.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr46102.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr107863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr72809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr101195.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr100786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr62043.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr89314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr59336.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr83796.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr67845.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr58566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr63786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr61133.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr71350.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr89663.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr71251.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr78344.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr82872.patch
	eapply "${FILESDIR}"/${PV}/postrelease/171_pr78341.patch
	eapply "${FILESDIR}"/${PV}/postrelease/172_pr67803.patch
	eapply "${FILESDIR}"/${PV}/postrelease/173_pr70468.patch
	eapply "${FILESDIR}"/${PV}/postrelease/174_pr89876.patch
	eapply "${FILESDIR}"/${PV}/postrelease/175_pr71861.patch
	eapply "${FILESDIR}"/${PV}/postrelease/176_pr85068.patch
	eapply "${FILESDIR}"/${PV}/postrelease/177_pr66542.patch
	eapply "${FILESDIR}"/${PV}/postrelease/178_pr72707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/179_pr49889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/180_pr84820.patch
	eapply "${FILESDIR}"/${PV}/postrelease/181_pr60218.patch
	eapply "${FILESDIR}"/${PV}/postrelease/182_pr69637.patch
	eapply "${FILESDIR}"/${PV}/postrelease/183_pr69095.patch
	eapply "${FILESDIR}"/${PV}/postrelease/184_pr71627.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/
	eapply "${FILESDIR}"/${PV}/postrelease/186_pr39751.patch
	eapply "${FILESDIR}"/${PV}/postrelease/187_pr79559.patch
	eapply "${FILESDIR}"/${PV}/postrelease/188_pr84729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/189_pr84792.patch

	if use test ; then
		rm -rf gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-arm-test-fail.patch
	fi
}

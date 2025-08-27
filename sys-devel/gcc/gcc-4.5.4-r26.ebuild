# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/03_remove-combine.patch
	eapply "${FILESDIR}"/${PV}/04_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr78185.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr53922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr40850.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr47844.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr46083.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr49897-49898.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr44696.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr44290.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr56539.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr38392.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr46162-46170.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr66686-96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr54208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr23200.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr47789.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr51825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr45236.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr45401.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr49134.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr61999.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr54652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr57728.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr54442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr79641.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr58809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr43590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr58749.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr54472.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr59032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr47213.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr47053.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr55232.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr47198.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr49720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr47242.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr55838.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr48374.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr48189.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr48184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr48186.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr52547.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr50114.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr49648.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr48271.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr48442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr46494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr48302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr47968.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr48235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr46288.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr54511.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr47908.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr45310.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr47049.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr44031.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr71494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr49948.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr42894.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr56403.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr45043.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr46172.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr42696.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr72809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr79361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr66461.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr84900.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr47220.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr51565.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr57895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr89314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr53055.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr85068.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr47450.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr50070.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr49889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr47190.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr58843.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr59082.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr60224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr57499.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr53492.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr48280.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr43384.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr48599.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr47277.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr43705.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr45665.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr43082.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr45117.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr81304.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr26155.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr28501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr25811.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr56883.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr21659.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr4784.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr41681-workaround.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr80362.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr64979.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr62174.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr46815.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr41174-59224.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr56468.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr54858.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr54653.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr54487.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr49484.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr49146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr43028.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr38757.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr33763.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr28865.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr50055.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr93672.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr115646.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
	fi
}

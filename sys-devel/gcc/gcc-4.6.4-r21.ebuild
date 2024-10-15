# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/03_remove-struct-matrix-reorg.patch
	eapply "${FILESDIR}"/${PV}/04_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr77605-78185-78333.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr62052-69889.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr81395.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr68376-68670.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr78378.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr54919.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr56899.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr60485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr52413.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr53922.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr56743.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr57785.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr79351.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr56712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr54524.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr50199.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr75964.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr53690.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr58941.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr38313.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr69410.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr52625.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr80176.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr66686-96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr61420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr65879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr51308.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr60361.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr90107.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr51825.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr53841.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr60019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr88754.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr106421.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr60909.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr61999.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr87647.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr54652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr79896.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr57728.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr79641.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr70778.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr71063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr54442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr58504.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr58749.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr58003.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr58809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr59032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr43590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr48389.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr48805.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr55232.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr48766.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr48302.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr55838.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr55331.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr52621.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr47612.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr49069.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr48184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr48235.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr48186.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr50114.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr48170.patch
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr48210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr48271.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr48442.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr51505.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr50205.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr47301.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr67046.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr48106.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr47691.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr71494.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-arm-test-fail.patch
	fi
}

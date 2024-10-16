# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	[[ ${CTARGET} == arm*-*-*eabihf* ]] && eapply "${FILESDIR}"/${PV}/01_support-armhf.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/03_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/04_backport-static-libstdc++-option.patch
	use test && [[ ${CTARGET} == arm*-*-*eabi ]] && eapply "${FILESDIR}"/${PV}/05_workaround-abi-warning-in-test.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr58726.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr70222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr39120.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr77707.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr46716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr46779.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr56015.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr51613.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr45694.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr42240.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr44996.patch
	[[ ${CTARGET} == arm*-*-*eabihf* ]] || eapply "${FILESDIR}"/${PV}/postrelease/020_pr43323.patch
	[[ ${CTARGET} == arm*-*-*eabihf* ]] || eapply "${FILESDIR}"/${PV}/postrelease/021_pr42321.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr39633.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr45777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr36399.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr43886.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr82210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr54208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr66686-96097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr66957.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr46162-46170.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr40629.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr45236.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr45401.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr22556.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr17365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr16333-41426-59878-66895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr22154.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr23716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr49134.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr82314.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr54652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr58809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr43590.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr59032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr47213.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr49720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr47968.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr46494.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr55838.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr48184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr48186.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr52547.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr49648.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr48189.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr48302.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr46521.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr46288.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr71494.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr42229.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr56403.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_workaround-pr34999.patch
	fi
}

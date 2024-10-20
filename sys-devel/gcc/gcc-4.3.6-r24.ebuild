# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	sed -i 's/use_fixproto=yes/:/' gcc/config.gcc #PR33200

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	eapply "${FILESDIR}"/${PV}/02_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/03_backport-static-libstdc++-option.patch
	eapply "${FILESDIR}"/${PV}/04_support-__builtin_isinf_sign.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr50109.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr91131.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr35202.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr46010.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr44942.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr35685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr56015.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr45312.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr42240.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr43419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr35729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr44996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr48837.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr39633.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr39365.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr43841.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr43228.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr40962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr45777.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr110044.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr32000.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr31827.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr54208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr66686.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr42655.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr40629.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr39987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr45401.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr35297.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr28274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr39028.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr37971.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr23716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr49134.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr29197.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr45043.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr84001.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr44735.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr54652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr59032.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr58809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr47213.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr27100-59295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr55838.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr48184.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr48189.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr49648.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr49720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr38640.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr45894-47589.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr41646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr39764.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr42697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr43327.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr41044-41167.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr41278.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr40081.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr39431.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr37411.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr19636-24894-31644-31786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr39412.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr38700.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr34180.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr38795.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr35075.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr72809.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-x86-test-fail.patch
		[[ $(tc-arch) == "arm" ]] && rm -rf gcc/testsuite/obj-c++.dg/try-catch-11.mm
		[[ ${CTARGET} == arm*-*-*eabi ]] && eapply "${FILESDIR}"/${PV}/postrelease/902_fix-armel-test-fail.patch
	fi
}

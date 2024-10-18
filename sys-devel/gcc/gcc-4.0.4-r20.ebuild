# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/01_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/02_sh4-workaround-fixproto-core.patch
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/03_hppa-fix-build.patch
	[[ $(tc-arch) == "mips" ]] && eapply "${FILESDIR}"/${PV}/04_mips-fix-build.patch
	! is_crosscompile && eapply "${FILESDIR}"/${PV}/05_workaround-bootstrap.patch
	eapply "${FILESDIR}"/${PV}/06_backport-static-libstdc++-option.patch
	eapply "${FILESDIR}"/${PV}/07_fix-werror.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr33619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr34768.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr31309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr36300.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr44555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr25243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr33631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr32244.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr35616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr30360.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr30931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr31806.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr22429.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr43555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr29154.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr26630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr28960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr26875.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr31074.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr36019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr38615.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr29091.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr20416.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr29198.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr29302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr23518.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr34130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr19606.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr15097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr29631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr34178.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr26532.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr23708.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr33616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr31419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr29236.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr29518.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr28557.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr29886.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr27227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr30363.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr26433.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr23287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr33744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr28274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr29928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr34364.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr38950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr24268.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr19983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr35650.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr19977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr54652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr55838.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr49720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr29250.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr26622.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr25005.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr24265.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr20928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr37014.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr34180.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
	fi
}

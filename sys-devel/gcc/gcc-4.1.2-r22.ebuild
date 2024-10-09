# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-4.1.3-without-change-version.patch
	eapply "${FILESDIR}"/${PV}/01_gentoo-patchset.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/02_compat-new-mpfr.patch
	[[ $(tc-arch) == "sh" ]] && eapply "${FILESDIR}"/${PV}/03_sh4-fix-build.patch
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/04_hppa-fix-build.patch
	[[ $(tc-arch) == "mips" && ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/05_mips64-default-n64-abi.patch
	[[ $(tc-arch) == "arm" ]] && eapply "${FILESDIR}"/${PV}/06_add-.note.GNU-stack.patch
	[[ $(tc-arch) == "mips" ]] && eapply "${FILESDIR}"/${PV}/07_mips-fix-build.patch
	! is_crosscompile && eapply "${FILESDIR}"/${PV}/08_workaround-bootstrap.patch
	eapply "${FILESDIR}"/${PV}/09_Unset-_M_init.patch
	eapply "${FILESDIR}"/${PV}/10_backport-static-libstdc++-option.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr33619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr36013.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr34768.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr31196.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr36300.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr29877.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr32298.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr35616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr38987.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr46010.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr47698.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr49243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr31915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr34154.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr31210.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr33288.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr31211.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr36093.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr31295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr31203.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr28230.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr25243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr38030.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr31309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr44555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr39855.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr31725.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr56810.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr38852.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr35685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr32244.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr43555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr26875.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr36019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr38615.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr20416.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr39371.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr29302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr23518.patch
	eapply "${FILESDIR}"/${PV}/postrelease/047_pr19116.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr19606.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr28139.patch
	eapply "${FILESDIR}"/${PV}/postrelease/050_pr15097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/051_pr3698-86208.patch
	eapply "${FILESDIR}"/${PV}/postrelease/052_pr34178.patch
	eapply "${FILESDIR}"/${PV}/postrelease/053_pr28812-28834-29436.patch
	eapply "${FILESDIR}"/${PV}/postrelease/054_pr33553.patch
	eapply "${FILESDIR}"/${PV}/postrelease/055_pr23716.patch
	eapply "${FILESDIR}"/${PV}/postrelease/056_pr33516.patch
	eapply "${FILESDIR}"/${PV}/postrelease/057_pr33616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/058_pr31419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/059_pr31338.patch
	eapply "${FILESDIR}"/${PV}/postrelease/060_pr28712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/061_pr26988.patch
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr29236.patch
	eapply "${FILESDIR}"/${PV}/postrelease/063_pr30363.patch
	eapply "${FILESDIR}"/${PV}/postrelease/064_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/065_pr40566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/066_pr39295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/067_pr36435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/068_pr23287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/069_pr37877.patch
	eapply "${FILESDIR}"/${PV}/postrelease/070_pr28274.patch
	eapply "${FILESDIR}"/${PV}/postrelease/071_pr32103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/072_pr35255.patch
	eapply "${FILESDIR}"/${PV}/postrelease/073_pr31144.patch
	eapply "${FILESDIR}"/${PV}/postrelease/074_pr29928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/075_pr29273.patch
	eapply "${FILESDIR}"/${PV}/postrelease/076_pr38950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/077_pr31222.patch
	eapply "${FILESDIR}"/${PV}/postrelease/078_pr30746.patch
	eapply "${FILESDIR}"/${PV}/postrelease/079_pr34364.patch
	eapply "${FILESDIR}"/${PV}/postrelease/080_pr32906.patch
	eapply "${FILESDIR}"/${PV}/postrelease/081_pr30452.patch
	eapply "${FILESDIR}"/${PV}/postrelease/082_pr30446.patch
	eapply "${FILESDIR}"/${PV}/postrelease/083_pr21008.patch
	eapply "${FILESDIR}"/${PV}/postrelease/084_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/085_pr19983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/086_pr14050.patch
	eapply "${FILESDIR}"/${PV}/postrelease/087_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/088_pr19977.patch
	eapply "${FILESDIR}"/${PV}/postrelease/089_pr35650.patch
	eapply "${FILESDIR}"/${PV}/postrelease/090_pr29197.patch
	eapply "${FILESDIR}"/${PV}/postrelease/091_pr54652.patch
	eapply "${FILESDIR}"/${PV}/postrelease/092_pr55838.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr49720.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-known-test-fail-x86.patch
	fi
}

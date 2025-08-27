# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 arm hppa m68k mips ppc ppc64 s390 sh sparc x86"

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
	eapply "${FILESDIR}"/${PV}/11_fix-dw2-hang.patch

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
	eapply "${FILESDIR}"/${PV}/postrelease/062_pr29236-30897.patch
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
	eapply "${FILESDIR}"/${PV}/postrelease/093_pr45043.patch
	eapply "${FILESDIR}"/${PV}/postrelease/094_pr62135.patch
	eapply "${FILESDIR}"/${PV}/postrelease/095_pr49720.patch
	eapply "${FILESDIR}"/${PV}/postrelease/096_pr38700.patch
	eapply "${FILESDIR}"/${PV}/postrelease/097_pr31260-38357.patch
	eapply "${FILESDIR}"/${PV}/postrelease/098_pr42697.patch
	eapply "${FILESDIR}"/${PV}/postrelease/099_pr34180.patch
	eapply "${FILESDIR}"/${PV}/postrelease/100_pr37037.patch
	eapply "${FILESDIR}"/${PV}/postrelease/101_pr37014.patch
	eapply "${FILESDIR}"/${PV}/postrelease/102_pr34868.patch
	eapply "${FILESDIR}"/${PV}/postrelease/103_pr34895.patch
	eapply "${FILESDIR}"/${PV}/postrelease/104_pr72809.patch
	eapply "${FILESDIR}"/${PV}/postrelease/105_pr29431.patch
	eapply "${FILESDIR}"/${PV}/postrelease/106_pr34831.patch
	eapply "${FILESDIR}"/${PV}/postrelease/107_pr35075.patch
	eapply "${FILESDIR}"/${PV}/postrelease/108_pr29507-31404.patch
	eapply "${FILESDIR}"/${PV}/postrelease/109_pr19636-24894-31644-31786.patch
	eapply "${FILESDIR}"/${PV}/postrelease/110_pr30132.patch
	eapply "${FILESDIR}"/${PV}/postrelease/111_pr34953.patch
	eapply "${FILESDIR}"/${PV}/postrelease/112_pr33962.patch
	eapply "${FILESDIR}"/${PV}/postrelease/113_pr32232.patch
	eapply "${FILESDIR}"/${PV}/postrelease/114_pr32674.patch
	eapply "${FILESDIR}"/${PV}/postrelease/115_pr35317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/116_pr35429.patch
	eapply "${FILESDIR}"/${PV}/postrelease/117_pr35431.patch
	eapply "${FILESDIR}"/${PV}/postrelease/118_pr28705.patch
	eapply "${FILESDIR}"/${PV}/postrelease/119_pr30108.patch
	eapply "${FILESDIR}"/${PV}/postrelease/120_pr15759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/121_pr30917.patch
	eapply "${FILESDIR}"/${PV}/postrelease/122_pr24879.patch
	eapply "${FILESDIR}"/${PV}/postrelease/123_pr35744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/124_pr46538.patch
	eapply "${FILESDIR}"/${PV}/postrelease/125_pr43076.patch
	eapply "${FILESDIR}"/${PV}/postrelease/126_pr29966.patch
	eapply "${FILESDIR}"/${PV}/postrelease/127_pr41985.patch
	eapply "${FILESDIR}"/${PV}/postrelease/128_pr30659.patch
	eapply "${FILESDIR}"/${PV}/postrelease/129_pr28050.patch
	eapply "${FILESDIR}"/${PV}/postrelease/130_pr35996.patch
	eapply "${FILESDIR}"/${PV}/postrelease/131_pr35405.patch
	eapply "${FILESDIR}"/${PV}/postrelease/132_pr38579.patch
	eapply "${FILESDIR}"/${PV}/postrelease/133_pr20077.patch
	eapply "${FILESDIR}"/${PV}/postrelease/134_pr29295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/135_pr53492.patch
	eapply "${FILESDIR}"/${PV}/postrelease/136_pr47450.patch
	eapply "${FILESDIR}"/${PV}/postrelease/137_pr37650.patch
	eapply "${FILESDIR}"/${PV}/postrelease/138_pr34485.patch
	eapply "${FILESDIR}"/${PV}/postrelease/139_pr32519.patch
	eapply "${FILESDIR}"/${PV}/postrelease/140_pr37087.patch
	eapply "${FILESDIR}"/${PV}/postrelease/141_pr30427.patch
	eapply "${FILESDIR}"/${PV}/postrelease/142_pr35109.patch
	eapply "${FILESDIR}"/${PV}/postrelease/143_pr35447.patch
	eapply "${FILESDIR}"/${PV}/postrelease/144_pr34911.patch
	eapply "${FILESDIR}"/${PV}/postrelease/145_pr28768.patch
	eapply "${FILESDIR}"/${PV}/postrelease/146_pr35435.patch
	eapply "${FILESDIR}"/${PV}/postrelease/147_pr35433.patch
	eapply "${FILESDIR}"/${PV}/postrelease/148_pr32839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/149_pr35433.patch
	eapply "${FILESDIR}"/${PV}/postrelease/150_pr27667-26938-27329.patch
	eapply "${FILESDIR}"/${PV}/postrelease/151_pr32295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/152_pr26155.patch
	eapply "${FILESDIR}"/${PV}/postrelease/153_pr28501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/154_pr28513.patch
	eapply "${FILESDIR}"/${PV}/postrelease/155_pr37555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/156_pr30863.patch
	eapply "${FILESDIR}"/${PV}/postrelease/157_pr34486-34776.patch
	eapply "${FILESDIR}"/${PV}/postrelease/158_pr34089.patch
	eapply "${FILESDIR}"/${PV}/postrelease/159_pr32241.patch
	eapply "${FILESDIR}"/${PV}/postrelease/160_pr35436.patch
	eapply "${FILESDIR}"/${PV}/postrelease/161_pr52290.patch
	eapply "${FILESDIR}"/${PV}/postrelease/162_pr28301.patch
	eapply "${FILESDIR}"/${PV}/postrelease/163_pr33836.patch
	eapply "${FILESDIR}"/${PV}/postrelease/164_pr30302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/165_pr29573.patch
	eapply "${FILESDIR}"/${PV}/postrelease/166_pr28253.patch
	eapply "${FILESDIR}"/${PV}/postrelease/167_pr4784.patch
	eapply "${FILESDIR}"/${PV}/postrelease/168_pr28861.patch
	eapply "${FILESDIR}"/${PV}/postrelease/169_pr32121.patch
	eapply "${FILESDIR}"/${PV}/postrelease/170_pr28989.patch
	eapply "${FILESDIR}"/${PV}/postrelease/171_pr29470.patch
	eapply "${FILESDIR}"/${PV}/postrelease/172_pr34912.patch
	eapply "${FILESDIR}"/${PV}/postrelease/173_pr27492.patch
	eapply "${FILESDIR}"/${PV}/postrelease/174_pr25309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/175_pr28420.patch
	eapply "${FILESDIR}"/${PV}/postrelease/176_pr28419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/177_pr28303.patch
	eapply "${FILESDIR}"/${PV}/postrelease/178_pr28287.patch
	eapply "${FILESDIR}"/${PV}/postrelease/179_pr28266.patch
	eapply "${FILESDIR}"/${PV}/postrelease/180_pr27961.patch
	eapply "${FILESDIR}"/${PV}/postrelease/181_pr27398.patch
	eapply "${FILESDIR}"/${PV}/postrelease/182_pr14622.patch
	eapply "${FILESDIR}"/${PV}/postrelease/183_pr40473.patch
	eapply "${FILESDIR}"/${PV}/postrelease/184_pr20880.patch
	eapply "${FILESDIR}"/${PV}/postrelease/185_pr23848.patch
	eapply "${FILESDIR}"/${PV}/postrelease/186_pr25507.patch
	eapply "${FILESDIR}"/${PV}/postrelease/187_pr27144.patch
	eapply "${FILESDIR}"/${PV}/postrelease/188_pr27574.patch
	eapply "${FILESDIR}"/${PV}/postrelease/189_pr27640.patch
	eapply "${FILESDIR}"/${PV}/postrelease/190_pr27898.patch
	eapply "${FILESDIR}"/${PV}/postrelease/191_pr40057.patch
	eapply "${FILESDIR}"/${PV}/postrelease/192_pr28755.patch
	eapply "${FILESDIR}"/${PV}/postrelease/193_pr29217.patch
	eapply "${FILESDIR}"/${PV}/postrelease/194_pr29225.patch
	eapply "${FILESDIR}"/${PV}/postrelease/195_pr29558.patch
	eapply "${FILESDIR}"/${PV}/postrelease/196_pr29712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/197_pr29978-35264.patch
	[[ $(tc-arch) != "arm" ]] && eapply "${FILESDIR}"/${PV}/postrelease/198_pr30293-30494-34829.patch
	eapply "${FILESDIR}"/${PV}/postrelease/199_pr30554.patch
	eapply "${FILESDIR}"/${PV}/postrelease/200_pr30988.patch
	eapply "${FILESDIR}"/${PV}/postrelease/201_pr30565.patch
	eapply "${FILESDIR}"/${PV}/postrelease/202_pr31167.patch
	eapply "${FILESDIR}"/${PV}/postrelease/203_pr31483.patch
	eapply "${FILESDIR}"/${PV}/postrelease/204_pr32694.patch
	eapply "${FILESDIR}"/${PV}/postrelease/205_pr33094.patch
	eapply "${FILESDIR}"/${PV}/postrelease/206_pr41063.patch
	eapply "${FILESDIR}"/${PV}/postrelease/207_pr27301-33238.patch
	eapply "${FILESDIR}"/${PV}/postrelease/208_pr33501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/209_pr33506.patch
	eapply "${FILESDIR}"/${PV}/postrelease/210_pr33537.patch
	eapply "${FILESDIR}"/${PV}/postrelease/211_pr33723-34146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/212_pr41646.patch
	eapply "${FILESDIR}"/${PV}/postrelease/213_pr33842.patch
	eapply "${FILESDIR}"/${PV}/postrelease/214_pr33844.patch
	eapply "${FILESDIR}"/${PV}/postrelease/215_pr44367.patch
	eapply "${FILESDIR}"/${PV}/postrelease/216_pr34275.patch
	eapply "${FILESDIR}"/${PV}/postrelease/217_pr46815.patch
	eapply "${FILESDIR}"/${PV}/postrelease/218_pr36449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/219_pr37731.patch
	eapply "${FILESDIR}"/${PV}/postrelease/220_pr39563.patch
	eapply "${FILESDIR}"/${PV}/postrelease/221_pr50055.patch
	eapply "${FILESDIR}"/${PV}/postrelease/222_pr93672.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		[[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" ]] && eapply "${FILESDIR}"/${PV}/postrelease/901_fix-x86-test-fail.patch
	fi
}

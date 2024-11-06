# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	# Arch stuff
	case $(tc-arch) in
		amd64)
			if is_multilib ; then
				sed -i -e '/GLIBCXX_IS_NATIVE=/s:false:true:' libstdc++-v3/configure || die
			fi
			;;
		mips)
			eapply "${FILESDIR}"/${PV}/01_backport-mips-t-linux64.patch
			[[ ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
			[[ ${DEFAULT_ABI} == "n32" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n32-abi.patch
			;;
	esac
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/03_hppa-fix-build.patch
	! is_crosscompile && eapply "${FILESDIR}"/${PV}/04_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/06_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/07_backport-static-libstdc++-option.patch
	eapply "${FILESDIR}"/${PV}/08_workaround-x86-64-simd.patch
	eapply "${FILESDIR}"/${PV}/09_rhel4.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/postrelease/000_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr22127.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr55712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr19627.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr14124.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr29631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr34130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr33616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr31419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr29236-30897.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr27227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr26433.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr27424.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr19983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/021_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/022_pr33744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/023_pr29928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/024_pr25836.patch
	eapply "${FILESDIR}"/${PV}/postrelease/025_pr38950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/026_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/027_pr24683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/028_pr25554.patch
	eapply "${FILESDIR}"/${PV}/postrelease/029_pr20928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/030_pr22362.patch
	eapply "${FILESDIR}"/${PV}/postrelease/031_pr35317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/032_pr24302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/033_pr29114.patch
	eapply "${FILESDIR}"/${PV}/postrelease/034_pr15759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/035_pr28302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/036_pr29080.patch
	eapply "${FILESDIR}"/${PV}/postrelease/037_pr47450.patch
	eapply "${FILESDIR}"/${PV}/postrelease/038_pr37650.patch
	eapply "${FILESDIR}"/${PV}/postrelease/039_pr32519.patch
	eapply "${FILESDIR}"/${PV}/postrelease/040_pr28501.patch
	eapply "${FILESDIR}"/${PV}/postrelease/041_pr29295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/042_pr29632.patch
	eapply "${FILESDIR}"/${PV}/postrelease/043_pr27667.patch
	eapply "${FILESDIR}"/${PV}/postrelease/044_pr32839.patch
	eapply "${FILESDIR}"/${PV}/postrelease/045_pr24907.patch
	eapply "${FILESDIR}"/${PV}/postrelease/046_pr16104.patch
	! is_crosscompile && eapply "${FILESDIR}"/${PV}/postrelease/047_pr21955.patch
	eapply "${FILESDIR}"/${PV}/postrelease/048_pr11953.patch
	eapply "${FILESDIR}"/${PV}/postrelease/049_pr21412.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
	fi
}

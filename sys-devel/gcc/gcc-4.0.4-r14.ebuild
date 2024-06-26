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
	! is_crosscompile && eapply "${FILESDIR}"/${PV}/04_workaround-bootstrap.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/05_backport-static-libstdc++-option.patch
	eapply "${FILESDIR}"/${PV}/06_fix-werror.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr33619.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr34768.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr31309.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr36300.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr44555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr104147.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr25243.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr33631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr32244.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr35616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr36282.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr30360.patch
	eapply "${FILESDIR}"/${PV}/postrelease/15_pr30931.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr31806.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr22429.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr55771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr39415.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr43555.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr29154.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr26630.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr28960.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr26875.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr31074.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr36019.patch
	eapply "${FILESDIR}"/${PV}/postrelease/27_pr38615.patch
	eapply "${FILESDIR}"/${PV}/postrelease/28_pr29091.patch
	eapply "${FILESDIR}"/${PV}/postrelease/29_pr20416.patch
	eapply "${FILESDIR}"/${PV}/postrelease/30_pr29198.patch
	eapply "${FILESDIR}"/${PV}/postrelease/31_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/32_pr29302.patch
	eapply "${FILESDIR}"/${PV}/postrelease/33_pr23518.patch
	eapply "${FILESDIR}"/${PV}/postrelease/34_pr34130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/35_pr19606.patch
	eapply "${FILESDIR}"/${PV}/postrelease/36_pr19771.patch
	eapply "${FILESDIR}"/${PV}/postrelease/37_pr15097.patch
	eapply "${FILESDIR}"/${PV}/postrelease/38_pr29631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/39_pr34178.patch
	eapply "${FILESDIR}"/${PV}/postrelease/40_pr26532.patch
	eapply "${FILESDIR}"/${PV}/postrelease/41_pr23708.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	fi
}

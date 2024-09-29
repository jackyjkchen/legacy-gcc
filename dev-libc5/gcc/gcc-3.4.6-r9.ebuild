# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/04_workaround-for-legacy-glibc-in-non-system-dir.patch

	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/07_backport-static-libstdc++-option.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr22127.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr55712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr19627.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr14124.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr29631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr34130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr35146.patch
	eapply "${FILESDIR}"/${PV}/postrelease/12_pr33616.patch
	eapply "${FILESDIR}"/${PV}/postrelease/13_pr31419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/14_pr29236.patch
	#eapply "${FILESDIR}"/${PV}/postrelease/15_pr27227.patch
	eapply "${FILESDIR}"/${PV}/postrelease/16_pr26433.patch
	eapply "${FILESDIR}"/${PV}/postrelease/17_pr27424.patch
	eapply "${FILESDIR}"/${PV}/postrelease/18_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/19_pr19983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/20_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/21_pr45012.patch
	eapply "${FILESDIR}"/${PV}/postrelease/22_pr33744.patch
	eapply "${FILESDIR}"/${PV}/postrelease/23_pr29928.patch
	eapply "${FILESDIR}"/${PV}/postrelease/24_pr25836.patch
	eapply "${FILESDIR}"/${PV}/postrelease/25_pr38950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/26_pr42466.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/fix-known-test-fail.patch
	fi
}


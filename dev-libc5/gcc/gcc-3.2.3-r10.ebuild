# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/000_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr25572.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr24915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr35317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr15759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr24103.patch
}


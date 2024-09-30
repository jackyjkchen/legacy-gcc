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
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr25572.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr24915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr42466.patch
}


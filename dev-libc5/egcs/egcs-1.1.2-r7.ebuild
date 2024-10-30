# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_egcs-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/02_sjlj-exception-default.patch
	eapply "${FILESDIR}"/${PV}/03_add-gxxdg-exp.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr42466.patch
}


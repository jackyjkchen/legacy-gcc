# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-2.95.4-without-change-version.patch
	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/02_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/05_fix-crash-00204.patch
	eapply "${FILESDIR}"/${PV}/06_sjlj-exception-default.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch
	eapply "${FILESDIR}"/${PV}/07_add-gxxdg-exp.patch
	touch -r gcc/README gcc/configure.in || die

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr42466.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	fi
}


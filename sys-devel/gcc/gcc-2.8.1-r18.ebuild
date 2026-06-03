# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 m68k ppc sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}-workaround-for-new-glibc.patch

	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/10_sjlj-exception-default.patch
	eapply "${FILESDIR}"/${PV}/11_add-__LP64__.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch
}

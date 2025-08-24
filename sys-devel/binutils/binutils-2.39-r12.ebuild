# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="6"

inherit toolchain-binutils

KEYWORDS="loong"

src_prepare() {
	toolchain-binutils_src_prepare

	eapply "${FILESDIR}"/${PV}/00_disable-test-warning.patch
	eapply "${FILESDIR}"/${PV}/01_support-lsx-lasx-lvz-lbt.patch
}

src_configure() {
	EXTRA_ECONF='--disable-{binutils,gprof,ld,libctf}'
	toolchain-binutils_src_configure
}

# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="4"

inherit toolchain-binutils

KEYWORDS="alpha amd64 arm arm64 hppa m68k mips ppc ppc64 riscv s390 sh sparc x86"

src_prepare() {
	toolchain-binutils_src_prepare

	eapply "${FILESDIR}"/${PV}/00_adjust-max-page-size.patch
	eapply "${FILESDIR}"/${PV}/01_use-4k-max-page-size.patch
	eapply "${FILESDIR}"/${PV}/02_disable-in-function-info.patch
}

src_configure() {
	toolchain-binutils_src_configure
}

# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="5"

CC="gcc-4.9.4"
CXX="g++-4.9.4"
BDEPEND="sys-devel/gcc:4.9.4"

inherit toolchain-binutils

KEYWORDS="amd64 x86"

src_prepare() {
	toolchain-binutils_src_prepare

	eapply "${FILESDIR}"/${PV}/00_PR23919.patch
	eapply "${FILESDIR}"/${PV}/01_suppress-warning-with-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/02_suppress-warning-with-glibc217.patch
}

src_configure() {
	downgrade_arch_flags 4.9.4
	toolchain-binutils_src_configure
}

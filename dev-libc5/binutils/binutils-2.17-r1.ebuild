# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CC="gcc-4.4.7"
CXX="g++-4.4.7"
BDEPEND="sys-devel/gcc:4.4.7"

inherit toolchain-binutils

KEYWORDS="amd64 x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain-binutils_src_prepare
}

src_configure() {
	downgrade_arch_flags 4.4.7
	toolchain-binutils_src_configure
}

# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="1.1"

CC="gcc-4.9.4"
CXX="g++-4.9.4"
BDEPEND="sys-devel/gcc:4.9.4"

inherit toolchain-binutils

KEYWORDS="amd64 x86"

src_configure() {
	downgrade_arch_flags 4.9.4
	toolchain-binutils_src_configure
}

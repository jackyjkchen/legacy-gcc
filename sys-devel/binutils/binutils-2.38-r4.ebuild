# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_VER="4"

CC="gcc-10"
CXX="g++-10"
BDEPEND="sys-devel/gcc:10"

inherit toolchain-binutils

KEYWORDS="alpha amd64 arm arm64 hppa m68k mips ppc ppc64 s390 sh sparc x86"

src_configure() {
	downgrade_arch_flags 10
	toolchain-binutils_src_configure
}

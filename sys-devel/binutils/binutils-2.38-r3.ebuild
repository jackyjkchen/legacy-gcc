# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="4"

CC="gcc-9.5.0"
CXX="g++-9.5.0"
BDEPEND="sys-devel/gcc:9.5.0"

inherit toolchain-binutils

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_configure() {
	downgrade_arch_flags 9.5.0
	toolchain-binutils_src_configure
}

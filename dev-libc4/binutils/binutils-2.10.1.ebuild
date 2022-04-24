# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CC="gcc-3.4.6"
CXX="g++-3.4.6"
BDEPEND="sys-devel/gcc:3.4.6"

inherit toolchain-binutils

KEYWORDS="amd64 x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc4.patch

	toolchain-binutils_src_prepare
}

src_configure() {
	downgrade_arch_flags 3.4.6
	toolchain-binutils_src_configure
}

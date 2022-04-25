# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CC="gcc-2.95.3"
CXX="g++-2.95.3"
BDEPEND="sys-devel/gcc:2.95.3"

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

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CC="gcc-4.4.7"
CXX="g++-4.4.7"
BDEPEND="sys-devel/gcc:4.4.7"

inherit toolchain-binutils

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch

	toolchain-binutils_src_prepare
}

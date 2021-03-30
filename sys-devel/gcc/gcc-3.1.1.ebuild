# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="alpha amd64 ppc ppc64 s390 sparc x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=">=sys-devel/binutils-2.14.90.0.6-r1"
DEPEND="${RDEPEND}
	sys-devel/gcc:3.4.6
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"
CC="gcc-3.4.6"
CXX="g++-3.4.6"

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/3.1.1/00_gcc-3.1.1.patch
}

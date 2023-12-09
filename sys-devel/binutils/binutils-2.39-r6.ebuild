# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="6"

CC="gcc-9.5.0"
CXX="g++-9.5.0"
BDEPEND="sys-devel/gcc:9.5.0"

inherit toolchain-binutils

KEYWORDS="loong"

src_prepare() {
	toolchain-binutils_src_prepare

	[[ $(tc-arch) == "loong" ]] && eapply "${FILESDIR}"/${PV}/00_disable-pie-warning.patch
}
src_configure() {
	downgrade_arch_flags 9.5.0
	toolchain-binutils_src_configure
}

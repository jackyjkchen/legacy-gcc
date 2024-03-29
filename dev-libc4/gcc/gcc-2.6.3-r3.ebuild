# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${CATEGORY}/binutils
	${CATEGORY}/libc"
BDEPEND="${CATEGORY}/gcc:2.95.3"

CC="${CTARGET}-gcc-2.95.3"
CXX="${CTARGET}-g++-2.95.3"
EXTRA_ECONF="--gxx-include-dir=/usr/lib/gcc-lib/${CHOST}/${PV}/include/g++"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}-gentoo-install-path.patch
	eapply "${FILESDIR}"/${PV}/02_gcc-${PV}-workaround-for-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch
	eapply "${FILESDIR}"/${PV}/11_fix-for-libc4.patch
}


# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${CATEGORY}/binutils
	${CATEGORY}/libc"
BDEPEND="${CATEGORY}/gcc:2.95.3"

CC="${CTARGET}-gcc-2.95.3"
CXX="${CTARGET}-g++-2.95.3"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_egcs-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch
	eapply "${FILESDIR}"/${PV}/11_fix-for-libc4.patch
	rm -rf libstdc++
}

src_install() {
	toolchain-oldlibc_src_install
	cp -ax "${WORKDIR}"/build/libio/libio*.a "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/ || die
}
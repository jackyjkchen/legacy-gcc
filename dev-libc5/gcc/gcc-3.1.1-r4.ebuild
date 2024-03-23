# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${CATEGORY}/binutils
	${CATEGORY}/libc"
BDEPEND="${CATEGORY}/gcc:3.4.6"

CC="${CTARGET}-gcc-3.4.6"
CXX="${CTARGET}-g++-3.4.6"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch
}


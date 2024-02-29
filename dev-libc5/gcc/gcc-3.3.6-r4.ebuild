# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr25572.patch
}


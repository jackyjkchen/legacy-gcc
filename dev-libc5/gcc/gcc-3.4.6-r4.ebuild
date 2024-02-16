# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${CATEGORY}/binutils
	${CATEGORY}/libc"
BDEPEND="sys-devel/gcc:3.4.6"

if [[ -f /usr/bin/${CTARGET}-gcc-3.4.6 ]] ;then
	CC="${CTARGET}-gcc-3.4.6"
	CXX="${CTARGET}-g++-3.4.6"
else
	STAGE1='yes'
	CC="gcc-3.4.6 -m32"
	CXX="g++-3.4.6 -m32"
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/04_workaround-for-legacy-glibc-in-non-system-dir.patch

	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr22127.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr55712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr19627.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr14124.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr29631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr34130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr35146.patch
}


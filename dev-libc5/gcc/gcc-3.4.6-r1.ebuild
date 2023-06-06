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

	if use objc ; then
		eapply "${FILESDIR}"/${PV}/03_libffi-without-libgcj.patch
	fi
	eapply "${FILESDIR}"/${PV}/04_workaround-for-legacy-glibc-in-non-system-dir.patch

	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch
}


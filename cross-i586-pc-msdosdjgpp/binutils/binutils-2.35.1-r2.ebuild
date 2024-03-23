# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-binutils

KEYWORDS="amd64 x86"

EXTRA_ECONF=' --disable-libctf'

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_djgpp.patch
	toolchain-binutils_src_prepare
}

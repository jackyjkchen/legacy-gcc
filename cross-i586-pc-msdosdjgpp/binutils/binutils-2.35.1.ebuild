# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-binutils
SRC_URI="https://mirror.koddos.net/djgpp/current/v2gnu/bnu2351s.zip"

KEYWORDS="amd64 x86"

EXTRA_ECONF=' --disable-libctf'

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_unpack() {
	toolchain-binutils_src_unpack
	mv "${WORKDIR}"/gnu/binutils-${PV} "${WORKDIR}" || die
	rm -rf "${WORKDIR}"/{gnu,manifest} || die
	ln -sv binutils-${PV} "${WORKDIR}"/${P} || die
	chmod +x "${WORKDIR}"/${P}/configure || die
	chmod +x "${WORKDIR}"/${P}/mkinstalldirs || die
}

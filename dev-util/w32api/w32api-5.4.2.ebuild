# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

inherit eutils flag-o-matic

DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://www.mingw.org/"
SRC_URI="https://osdn.net/projects/mingw/downloads/74925/mingwrt-${PV}-mingw32-src.tar.xz
		https://osdn.net/projects/mingw/downloads/74926/w32api-${PV}-mingw32-src.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="headers-only"
RESTRICT="strip"

DEPEND="app-arch/xz-utils"
RDEPEND=""

S=${WORKDIR}/${P}

just_headers() {
	use headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
}


src_configure() {
	CFLAGS="-O2 -pipe"
	CXXFLAGS="-O2 -pipe"
	CHOST=${CTARGET} strip-unsupported-flags
	econf \
		--host=${CTARGET} \
		--prefix=/usr/${CTARGET}/usr
}

src_compile() {
	just_headers && return 0
	emake -j1 || die
}

src_install() {
	if just_headers ; then
		emake install-headers DESTDIR="${D}" || die
	else
		emake install DESTDIR="${D}" || die
		dodoc CONTRIBUTIONS ChangeLog README.w32api TODO

		# Make sure diff cross-compilers don't collide #414075
		mv "${D}"/usr/share/doc/{${PF},${CTARGET}-${PF}} || die
	fi
}
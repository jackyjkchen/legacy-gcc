# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

inherit flag-o-matic autotools versionator eutils

DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://www.mingw.org/"
# https://sourceforge.net/projects/mingw/files/MinGW/Base/mingw-rt/
SRC_URI="mirror://sourceforge/mingw/mingwrt-${PV}-mingw32-src.tar.xz
		mirror://sourceforge/mingw/w32api-${PV}-mingw32-src.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="headers-only"
RESTRICT="strip"

DEPEND="app-arch/xz-utils"

S=${WORKDIR}/mingwrt-${PV}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}
just_headers() {
	use headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_prepare() {
	default
	eautoconf
	sed -i \
		-e '/^install_dlls_host:/s:$: install-dirs:' \
		Makefile.in || die # fix parallel install
}

src_configure() {
	CHOST=${CTARGET} strip-unsupported-flags
	econf \
		--host=${CTARGET} \
		--prefix="/usr/${CTARGET}/usr"
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
		rm -rf "${D}"/usr/${CTARGET}/usr/doc
		docinto ${CTARGET} # Avoid collisions with other cross-compilers.
		dodoc CONTRIBUTORS ChangeLog README TODO readme.txt
	fi
	is_crosscompile && dosym usr /usr/${CTARGET}/mingw
}

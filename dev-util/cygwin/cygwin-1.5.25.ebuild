# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://github.com/jackyjkchen/binaries/releases/download/v0.1/w32api-3.14-1.tar.bz2
		https://github.com/jackyjkchen/binaries/releases/download/v0.1/cygwin-1.5.25-15.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/cygwin-${PV}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_unpack() {
	mkdir -p "${S}" || die
	tar -pxf "${DISTDIR}"/w32api-3.14-1.tar.bz2 -C "${S}" || die
	tar -pxf "${DISTDIR}"/cygwin-${PV}-15.tar.bz2 -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	popd > /dev/null
}

src_compile() {
	pushd "${S}" > /dev/null
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/${CTARGET}/ || die
	cp -ax . "${ED}"/usr/${CTARGET}/ || die
	ln -sv usr/include/w32api "${ED}"/usr/${CTARGET}/include
	ln -sv usr/lib/w32api "${ED}"/usr/${CTARGET}/lib
	popd > /dev/null
}

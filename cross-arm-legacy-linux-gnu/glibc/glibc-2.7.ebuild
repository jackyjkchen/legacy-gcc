# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://github.com/jackyjkchen/binaries/releases/download/v0.2/glibc-${PV}-arm-legacy-linux-gnu.tar.xz"

LICENSE=""
SLOT="0"
KEYWORDS="arm"
RESTRICT="strip"

DEPEND="${CATEGORY}/linux-headers"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/glibc-${PV}

src_unpack() {
	mkdir -p "${S}" || die
	tar -pxf "${DISTDIR}"/glibc-${PV}-arm-legacy-linux-gnu.tar.xz -C "${S}" || die
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
	CHOST="arm-legacy-linux-gnu"
	mkdir -p "${ED}"/usr/${CHOST}/ || die
	cp -ax . "${ED}"/usr/${CHOST}/ || die
	popd > /dev/null
}

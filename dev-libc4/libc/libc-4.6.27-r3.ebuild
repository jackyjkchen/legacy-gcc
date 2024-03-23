# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://www.win.tue.nl/~aeb/ftpdocs/linux-local/libc.archive/libc/libc-4.7.6.bin.tar.gz
		https://www.win.tue.nl/~aeb/ftpdocs/linux-local/libc.archive/libc/inc-4.6.27.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"

IUSE="+stdint"

DEPEND="${CATEGORY}/linux-headers"
RDEPEND="${DEPEND}"
BDEPEND="dev-vcs/git"

S=${WORKDIR}/libc-${PV}

src_unpack() {
	mkdir -p "${S}" || die
	tar -pxf "${DISTDIR}"/libc-4.7.6.bin.tar.gz -C "${S}" || die
	tar -pxf "${DISTDIR}"/inc-${PV}.tar.gz -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	git apply -p1 < "${FILESDIR}"/00_${P}.patch || die
	rm -r lib || die
	mv usr/i486-linuxaout/lib usr/i486-linuxaout/include . || die
	cp -ax usr/include . || die
	rm -r usr || die
	rm lib/*.so* lib/*.sa include/linux include/asm || die
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
	CHOST="i486-legacy-linuxaout"
	mkdir -p "${ED}"/usr/${CHOST}/ || die
	cp -ax . "${ED}"/usr/${CHOST}/ || die
	ln -sv libc.a "${ED}"/usr/${CHOST}/lib/libg.a || die
	if use stdint; then
		cp -ax "${FILESDIR}"/stdint.h "${ED}"/usr/${CHOST}/include/ || die
	fi
	popd > /dev/null
}

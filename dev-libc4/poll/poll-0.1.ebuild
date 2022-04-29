# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"

DEPEND="${CATEGORY}/gcc:2.95.3"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/poll-${PV}

CHOST="i486-legacy-linuxaout"

src_unpack() {
	mkdir -p "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	cp -ax ${FILESDIR}/* ./ || die
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	popd > /dev/null
}

src_compile() {
	pushd "${S}" > /dev/null
	INCLUDES="-Iinclude -Isysdeps/linux/i386 -I."
	${CHOST}-gcc-2.95.3 -O2 -s -c ${INCLUDES} sysdeps/linux/poll.c || die
	${CHOST}-gcc-2.95.3 -O2 -s -c ${INCLUDES} sysdeps/linux/__errno_loc.c || die
	${CHOST}-gcc-2.95.3 -O2 -s -c ${INCLUDES} sysdeps/linux/__syscall_poll.S || die
	${CHOST}-ar rc libpoll.a poll.o __errno_loc.o __syscall_poll.o || die
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/${CHOST}/lib || die
	cp -ax "${FILESDIR}"/include "${ED}"/usr/${CHOST}/ || die
	cp -ax libpoll.a "${ED}"/usr/${CHOST}//lib || die
	popd > /dev/null
}

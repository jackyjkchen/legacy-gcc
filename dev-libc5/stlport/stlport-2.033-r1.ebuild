# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport%20archive/STLport%203/STLport-${PV}.tar.gz"

inherit downgrade-arch-flags

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 x86"

DEPEND="${CATEGORY}/gcc:2.6.3[cxx]
		${CATEGORY}/libg++:2.6.2"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i586-legacy-linux-gnulibc1"

CC="${CHOST}-gcc-2.6,3"
CXX="${CHOST}-g++-2.6.3"

S="${WORKDIR}"/STLport-${PV}

src_unpack() {
	mkdir -p "${S}"
	tar -pxf "${DISTDIR}"/STLport-${PV}.tar.gz -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/${PV}/00_stlport-${PV}.patch || die
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	downgrade_arch_flags 2.6.3
	PATH=/usr/${CHOST}/bin:${PATH} sh ./configure --enable-newalloc || die
	popd > /dev/null
}

src_compile() {
	pushd "${S}" > /dev/null
	rm -rfv README* *.c config.log
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/ || die
	cp -ax . "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/stlport || die
	popd > /dev/null
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport%20archive/STLport%203/STLport-${PV}.tar.gz"

inherit downgrade-arch-flags

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 m68k ppc x86"

case ${ARCH} in
	amd64|x86)
		TOOL_PREFIX="i686-legacy"
		;;
	m68k)
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	ppc)
		TOOL_PREFIX="powerpc-legacy"
		;;
	*)
		;;
esac

DEPEND="sys-devel/gcc:2.6.3[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_PREFIX}-linux-gnu"

CC="gcc-2.6,3"
CXX="g++-2.6.3"

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
	sh ./configure --enable-newalloc || die
	popd > /dev/null
}

src_compile() {
	pushd "${S}" > /dev/null
	rm -rfv README* *.c configure config.log config/configure.in
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/ || die
	cp -avx . "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/stlport || die
	popd > /dev/null
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport/STLport-${PV}.tar.bz2"

inherit downgrade-arch-flags

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 m68k x86"

case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	m68k)
		TOOL_SLOT="${ARCH}-legacy"
		;;
	*)
		;;
esac

DEPEND="
	sys-devel/gcc:2.95.3[cxx]
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

CC="gcc-2.95.3"
CXX="g++-2.95.3"

S="${WORKDIR}"/STLport-5.2.1

src_prepare() {
	pushd "${S}" > /dev/null
	default
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	downgrade_arch_flags 2.95.3
	popd > /dev/null
}

src_compile() {
	pushd "${S}"/build/lib > /dev/null
	emake -j1 CC="${CC} ${CFLAGS}" CXX="${CXX} ${CXXFLAGS}" -f gcc.mak depend
	emake CC="${CC} ${CFLAGS}" CXX="${CXX} ${CXXFLAGS}" -f gcc.mak release-shared release-static
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/ || die
	cp -avx build/lib/obj/gcc/so/libstlport.* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/ || die
	cp -avx stlport "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/ || die
	popd > /dev/null
}

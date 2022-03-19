# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport%20archive/STLport%204/STLport-${PV}.tar.gz"

inherit downgrade-arch-flags

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 m68k ppc x86"

case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	m68k)
		TOOL_SLOT="${ARCH}-legacy"
		;;
	ppc)
		TOOL_SLOT="powerpc-legacy"
		;;
	*)
		;;
esac

DEPEND="
	sys-devel/egcs:1.1.2[cxx]
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

CC="gcc-2.91.66"
CXX="g++-2.91.66"

S="${WORKDIR}"/STLport-${PV}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/${PV}/00_stlport-${PV}.patch || die
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	downgrade_arch_flags 2.91.66
	popd > /dev/null
}

src_compile() {
	pushd "${S}"/src > /dev/null
	case ${ARCH} in
		ppc)
			emake CC="${CC} ${CFLAGS}" CXX="${CXX} ${CXXFLAGS} -pthread -fexceptions" DYN_LINK='${CXX} ${CXXFLAGS} -pthread -fexceptions -shared -o' -f gcc-linux.mak release_static
			;;
		*)
			emake CC="${CC} ${CFLAGS}" CXX="${CXX} ${CXXFLAGS} -pthread -fexceptions" DYN_LINK='${CXX} ${CXXFLAGS} -pthread -fexceptions -shared -o' -f gcc-linux.mak release_dynamic release_static
	esac
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
	cp -avx lib/libstlport_gcc.* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/ || die
	cp -avx stlport "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
	popd > /dev/null
}

# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport%20archive/STLport%204/STLport-${PV}.tar.gz"

inherit downgrade-arch-flags

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="alpha amd64 m68k ppc x86"

case ${ARCH} in
	amd64|x86)
		TOOL_PREFIX="i686-legacy"
		;;
	alpha|m68k)
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	ppc)
		TOOL_PREFIX="powerpc-legacy"
		;;
	*)
		;;
esac

DEPEND="sys-devel/egcs:1.1.2[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_PREFIX}-linux-gnu"

CC="${CHOST}-gcc-2.91.66"
CXX="${CHOST}-g++-2.91.66"

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
	strip-flags
	popd > /dev/null
}

src_compile() {
	pushd "${S}"/src > /dev/null
	case ${ARCH} in
		ppc)
			emake CC="${CC} ${CFLAGS}" CXX="${CXX} ${CXXFLAGS} -pthread -fexceptions" AR="${CHOST}-ar" RANLIB="${CHOST}-ranlib" NM="${CHOST}-nm" DYN_LINK='${CXX} ${CXXFLAGS} -pthread -fexceptions -shared -o' -f gcc-linux.mak release_static
			;;
		*)
			emake CC="${CC} ${CFLAGS}" CXX="${CXX} ${CXXFLAGS} -pthread -fexceptions" AR="${CHOST}-ar" RANLIB="${CHOST}-ranlib" NM="${CHOST}-nm" DYN_LINK='${CXX} ${CXXFLAGS} -pthread -fexceptions -shared -o' -f gcc-linux.mak release_dynamic release_static
	esac
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
	ln -sv libstlport_gcc.a lib/libstlport.a || die
	[ -f lib/libstlport_gcc.so.4.6 ] && ( ln -sv libstlport_gcc.so.4.6 lib/libstlport_gcc.so.4 || die )
	[ -f lib/libstlport_gcc.so.4 ] && ( ln -sv libstlport_gcc.so.4 lib/libstlport_gcc.so || die )
	[ -f lib/libstlport_gcc.so.4.6 ] && ( ln -sv libstlport_gcc.so.4.6 lib/libstlport.so.4.6 || die )
	[ -f lib/libstlport.so.4.6 ] && (ln -sv libstlport.so.4.6 lib/libstlport.so.4 || die )
	[ -f lib/libstlport.so.4 ] && ( ln -sv libstlport.so.4 lib/libstlport.so || die )
	cp -ax lib/libstlport* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/ || die
	cp -ax stlport "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
	popd > /dev/null
}

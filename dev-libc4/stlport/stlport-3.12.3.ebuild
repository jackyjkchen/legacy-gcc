# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport%20archive/STLport%203/STLport-${PV}.tar.gz"

inherit downgrade-arch-flags

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 x86"

IUSE="+gcc295 +egcs112"

DEPEND="
	gcc295? ( ${CATEGORY}/gcc:2.95.3[cxx] )
	egcs112? ( ${CATEGORY}/egcs:1.1.2[cxx] )"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i486-legacy-linuxaout"

S="${WORKDIR}"/STLport-${PV}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/${PV}/00_stlport-${PV}.patch || die
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	if use gcc295; then
		downgrade_arch_flags 2.95.3
		CC="${CHOST}-gcc-2.95.3" CXX="${CHOST}-g++-2.95.3" sh ./stl/config/configure --enable-newalloc || die
		mv stlconf.h stlconf.h_gcc295 || die
	fi
	if use egcs112; then
		downgrade_arch_flags 2.91.66
		CC="${CHOST}-gcc-2.91.66" CXX="${CHOST}-g++-2.91.66" sh ./stl/config/configure --enable-newalloc || die
		mv stlconf.h stlconf.h_gcc291 || die
	fi
	popd > /dev/null
}

src_compile() {
	pushd "${S}" > /dev/null
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	if use gcc295; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/g++-v2 || die
		cp -avx stlconf.h_gcc295 "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/g++-v2/config/stlconf.h || die
	fi
	if use egcs112; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/g++-v2 || die
		cp -avx stlconf.h_gcc291 "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/g++-v2/config/stlconf.h || die
	fi
	popd > /dev/null
}

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

IUSE="+gcc295 +gcc291 +gcc281 +gcc272"

DEPEND="
	gcc295? ( ${CATEGORY}/gcc:2.95.3[cxx] )
	gcc291? ( ${CATEGORY}/gcc:2.91.66[cxx] )
	gcc281? ( ${CATEGORY}/gcc:2.8.1[cxx] ${CATEGORY}/libstdc++:2.8.1 )
	gcc272? ( ${CATEGORY}/gcc:2.7.2[cxx] ${CATEGORY}/libg++:2.7.2 )"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i586-legacy-linux-gnulibc1"

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
		CC="${CHOST}-gcc-2.95.3" CXX="${CHOST}-g++-2.95.3" sh ./stl/config/configure || die
		mv stlconf.h stlconf.h_gcc295 || die
	fi
	if use gcc291; then
		downgrade_arch_flags 2.91.66
		CC="${CHOST}-gcc-2.91.66" CXX="${CHOST}-g++-2.91.66" sh ./stl/config/configure || die
		mv stlconf.h stlconf.h_gcc291 || die
	fi
	if use gcc281; then
		downgrade_arch_flags 2.8.1
		CC="${CHOST}-gcc-2.8.1" CXX="${CHOST}-g++-2.8.1" sh ./stl/config/configure || die
		mv stlconf.h stlconf.h_gcc281 || die
	fi
	if use gcc272; then
		downgrade_arch_flags 2.7.2
		CC="${CHOST}-gcc-2.7.2" CXX="${CHOST}-g++-2.7.2" sh ./stl/config/configure || die
		mv stlconf.h stlconf.h_gcc272 || die
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
		cp -ax stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/stlport || die
		cp -ax stlconf.h_gcc295 "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/stlport/config/stlconf.h || die
	fi
	if use gcc291; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
		cp -ax stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/stlport || die
		cp -ax stlconf.h_gcc291 "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/stlport/config/stlconf.h || die
	fi
	if use gcc281; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/ || die
		cp -ax stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/stlport || die
		cp -ax stlconf.h_gcc281 "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/stlport/config/stlconf.h || die
	fi
	if use gcc272; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/ || die
		cp -ax stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/stlport || die
		cp -ax stlconf.h_gcc272 "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/stlport/config/stlconf.h || die
		ln -sv g++/new "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/ || die
		ln -sv g++/new.h "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/ || die
	fi
	popd > /dev/null
}

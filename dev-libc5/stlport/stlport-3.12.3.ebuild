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

case ${ARCH} in
	amd64|x86)
		TOOL_PREFIX="i586-legacy"
		;;
	*)
		;;
esac

IUSE="+gcc295 +egcs112 +gcc281 +gcc272"

DEPEND="
	gcc295? ( ${CATEGORY}/gcc:2.95.3[cxx] )
	egcs112? ( ${CATEGORY}/egcs:1.1.2[cxx] )
	gcc281? ( ${CATEGORY}/gcc:2.8.1[cxx] )
	gcc272? ( ${CATEGORY}/gcc:2.7.2[cxx] )"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_PREFIX}-linux-gnulibc1"

S="${WORKDIR}"/STLport-${PV}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/${PV}/00_stlport-${PV}.patch || die
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
	if use gcc295; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.95.3/include/stlport || die
	fi
	if use egcs112; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.91.66/include/stlport || die
	fi
	if use gcc281; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/stlport || die
	fi
	if use gcc272; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/stlport || die
	fi
	popd > /dev/null
}

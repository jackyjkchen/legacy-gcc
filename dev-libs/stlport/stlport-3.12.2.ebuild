# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/stlport/STLport%20archive/STLport%203/STLport-${PV}.tar.gz"

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

IUSE="+gcc281 +gcc272"

DEPEND="
	gcc281? ( sys-devel/gcc:2.8.1[cxx] )
	gcc272? ( sys-devel/gcc:2.7.2[cxx] )
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

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
	if use gcc281; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/include/stlport || die
	fi
	if use gcc272; then
		mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2.3/include/ || die
		cp -avx stl "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2.3/include/stlport || die
	fi
	popd > /dev/null
}

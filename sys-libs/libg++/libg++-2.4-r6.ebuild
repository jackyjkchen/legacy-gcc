# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libg++/${P}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 m68k x86"

case ${ARCH} in
amd64|x86)
	TOOL_PREFIX="i686-legacy"
	;;
m68k)
	TOOL_PREFIX="${ARCH}-legacy"
	;;
*)
	;;
esac

DEPEND="sys-devel/gcc:2.4.5[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_PREFIX}-linux-gnu"

CC="${CHOST}-gcc-2.4.5"
CXX="${CHOST}-gcc-2.4.5"

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_libgxx-${PV}.patch || die
}

src_configure() {
	downgrade_arch_flags 2.4.5
	local econfargs=(
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	"${S}"/configure "${econfargs[@]}" || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	pushd "${WORKDIR}"/build > /dev/null
	emake -j1 CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" AR="${CHOST}-ar" RANLIB="${CHOST}-ranlib" NM="${CHOST}-nm" || die "failed to run make"
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	emake -j1 DESTDIR="${ED}" install || die "failed to run make install"
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.4.5/include || die
	mv -v "${ED}"/usr/lib/g++-include "${ED}"/usr/lib/gcc-lib/${CHOST}/2.4.5/include/g++ || die
	mv -v "${ED}"/usr/lib/libg++.a "${ED}"/usr/lib/gcc-lib/${CHOST}/2.4.5/ || die
	rm -rfv "${ED}"/usr/lib/lib* "${ED}"/usr/lib/doc "${ED}"/usr/bin "${ED}"/usr/include "${ED}"/usr/man "${ED}"/usr/${CHOST} "${ED}"/usr/lib/${CHOST}
	popd > /dev/null
}

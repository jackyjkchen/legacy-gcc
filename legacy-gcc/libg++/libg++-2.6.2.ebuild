# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libg++/${P}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="${PV}"
KEYWORDS="amd64 x86"

DEPEND="
	sys-devel/gcc:2.6.3
	legacy-gcc/linux-headers:i686-legacy
	legacy-gcc/glibc-headers:i686-legacy
	legacy-gcc/binutils-wrapper:i686-legacy"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i686-legacy-linux-gnu"

CC="gcc-2.6.3"
CXX="g++-2.6.3"

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_libgxx-${PV}.patch || die
}

src_configure() {
	downgrade_arch_flags 2.6.3
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
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
	emake -j1 CC="${CC}" CXX="${CXX}" || die "failed to run make"
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	emake -j1 DESTDIR="${ED}" install || die "failed to run make"
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include || die
	mv -v "${ED}"/usr/lib/g++-include "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/g++ || die
	mv -v "${ED}"/usr/lib/libstdc++.a "${ED}"/usr/lib/libg++.a "${ED}"/usr/lib/libiostream.a "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/ || die
	rm -rfv "${ED}"/usr/lib/libiberty.a "${ED}"/usr/bin "${ED}"/usr/man "${ED}"/usr/${CHOST}
	popd > /dev/null
}
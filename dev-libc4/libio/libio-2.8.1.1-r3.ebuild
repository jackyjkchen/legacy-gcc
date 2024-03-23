# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libstdc++/libstdc++-${PV}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 x86"

DEPEND="${CATEGORY}/gcc:2.8.1[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i486-legacy-linuxaout"

CC="${CHOST}-gcc-2.8.1"
CXX="${CHOST}-g++-2.8.1"

S=${WORKDIR}/libstdc++-${PV}

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_fix-for-gentoo.patch || die
}

src_configure() {
	downgrade_arch_flags 2.8.1
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
		--disable-shared
		--with-gxx-include-dir=/usr/lib/gcc-lib/${CHOST}/2.8.1/include/g++-v2
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	PATH=/usr/${CHOST}/bin:${PATH} "${S}"/configure "${econfargs[@]}" || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	pushd "${WORKDIR}"/build > /dev/null
	PATH=/usr/${CHOST}/bin:${PATH} emake || die "failed to run make"
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	PATH=/usr/${CHOST}/bin:${PATH} emake -j1 DESTDIR="${ED}" install-target-libio || die "failed to run make install"
	cp -ax libraries/libio/libiostream.a "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/ || die
	rm -rfv "${ED}"/usr/lib/libiberty.a "${ED}"/usr/${CHOST}
	popd > /dev/null
}

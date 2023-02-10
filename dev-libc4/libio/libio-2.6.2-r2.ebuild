# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libg++/libg++-${PV}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 x86"

DEPEND="${CATEGORY}/gcc:2.6.3[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i486-legacy-linuxaout"

CC="${CHOST}-gcc-2.6.3"
CXX="${CHOST}-gcc-2.6.3"

S=${WORKDIR}/libg++-${PV}

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_fix-for-gentoo.patch || die
	eapply "${FILESDIR}"/${PV}/01_workaround-for-libc4.patch || die
}

src_configure() {
	downgrade_arch_flags 2.6.3
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	PATH=/usr/${CHOST}/bin:${PATH} "${S}"/configure "${econfargs[@]}" || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	pushd "${WORKDIR}"/build > /dev/null
	PATH=/usr/${CHOST}/bin:${PATH} emake -j1 CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die "failed to run make"
	popd > /dev/null
	pushd "${WORKDIR}"/build/libio > /dev/null
	${CHOST}-ar rc libiostream.a `cat iostream.list` || die
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	PATH=/usr/${CHOST}/bin:${PATH} emake -j1 DESTDIR="${ED}" install-libio || die "failed to run make install"
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include || die
	mv -v "${ED}"/usr/lib/g++-include "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/g++ || die
	sed -i ${S}/libstdc++/new -e 's/cstddef/stddef.h/g' || die
	cp -ax ${S}/libstdc++/{new,new.h} "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/include/g++ || die
	cp -ax libio/libio*.a "${ED}"/usr/lib/gcc-lib/${CHOST}/2.6.3/ || die
	rm -rfv "${ED}"/usr/lib/lib* "${ED}"/usr/lib/doc "${ED}"/usr/bin "${ED}"/usr/include "${ED}"/usr/man "${ED}"/usr/${CHOST}
	popd > /dev/null
}

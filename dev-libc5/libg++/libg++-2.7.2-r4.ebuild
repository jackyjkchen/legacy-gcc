# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libg++/${P}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 x86"

DEPEND="${CATEGORY}/gcc:2.7.2[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="i586-legacy-linux-gnulibc1"

CC="${CHOST}-gcc-2.7.2"
CXX="${CHOST}-gcc-2.7.2"

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_fix-for-gentoo.patch || die
	eapply "${FILESDIR}"/${PV}/02_fix-for-crash-00187.patch || die
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch || die
}

src_configure() {
	downgrade_arch_flags 2.7.2
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
		--disable-shared
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	PATH=/usr/${CHOST}/bin:${PATH} "${S}"/configure "${econfargs[@]}" || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	pushd "${WORKDIR}"/build > /dev/null
	PATH=/usr/${CHOST}/bin:${PATH} emake CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS} -fvtable-thunks" || die "failed to run make"
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	PATH=/usr/${CHOST}/bin:${PATH} emake -j1 DESTDIR="${ED}" install || die "failed to run make install"
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include || die
	mv -v "${ED}"/usr/lib/g++-include "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/include/g++ || die
	mv -v "${ED}"/usr/lib/libstdc++* "${ED}"/usr/lib/libg++* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2/ || die
	rm -rfv "${ED}"/usr/lib/lib* "${ED}"/usr/lib/doc "${ED}"/usr/bin "${ED}"/usr/include "${ED}"/usr/man "${ED}"/usr/${CHOST}
	popd > /dev/null
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libg++/${P}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 x86"

case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	*)
		;;
esac

DEPEND="
	=sys-devel/gcc-2.7.2.3[cxx]
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

CC="gcc-2.7.2"
CXX="gcc-2.7.2"

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_libgxx-${PV}.patch || die
}

src_configure() {
	downgrade_arch_flags 2.7.2
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
		--enable-shared
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	"${S}"/configure "${econfargs[@]}" || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	pushd "${WORKDIR}"/build > /dev/null
	emake CC="${CC}" CXX="${CXX}" || die "failed to run make"
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	emake -j1 DESTDIR="${ED}" install || die "failed to run make"
	mkdir -p "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2.3/include || die
	mv -v "${ED}"/usr/lib/g++-include "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2.3/include/g++ || die
	mv -v "${ED}"/usr/lib/libstdc++* "${ED}"/usr/lib/libg++* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.7.2.3/ || die
	rm -rfv "${ED}"/usr/lib/lib* "${ED}"/usr/bin "${ED}"/usr/man "${ED}"/usr/${CHOST}
	popd > /dev/null
}

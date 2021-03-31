# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libstdc++/${P}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 ppc x86"

case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	ppc)
		TOOL_SLOT="powerpc-legacy"
		;;
	*)
		;;
esac

DEPEND="
	sys-devel/gcc:2.8.1
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/glibc-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

CC="gcc-2.8.1"
CXX="g++-2.8.1"

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_libstdcxx-${PV}.patch || die
}

src_configure() {
	downgrade_arch_flags 2.8.1
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
		--enable-shared
		--with-gxx-include-dir=/usr/lib/gcc-lib/${CHOST}/2.8.1/include/g++-v2
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	"${S}"/configure "${econfargs[@]}" || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	pushd "${WORKDIR}"/build > /dev/null
	emake || die "failed to run make"
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}"/build > /dev/null
	emake -j1 DESTDIR="${ED}" install || die "failed to run make"
	mv -v "${ED}"/usr/lib/libstdc++* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/ || die
	rm -rfv "${ED}"/usr/lib/libiberty.a "${ED}"/usr/${CHOST}
	popd > /dev/null
}

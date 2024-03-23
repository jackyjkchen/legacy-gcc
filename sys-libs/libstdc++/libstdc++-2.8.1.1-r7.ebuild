# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://gcc.gnu.org/pub/gcc/old-releases/libstdc++/${P}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
SLOT="$(ver_cut 1-3 ${PV})"
KEYWORDS="amd64 alpha m68k ppc sparc x86"

case ${ARCH} in
amd64|x86)
	TOOL_PREFIX="i686-legacy"
	;;
alpha|m68k)
	TOOL_PREFIX="${ARCH}-legacy"
	;;
ppc)
	TOOL_PREFIX="powerpc-legacy"
	;;
sparc)
	TOOL_PREFIX="sparc-legacy"
	;;
*)
	;;
esac

DEPEND="sys-devel/gcc:2.8.1[cxx]"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_PREFIX}-linux-gnu"

CC="${CHOST}-gcc-2.8.1"
CXX="${CHOST}-g++-2.8.1"

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_fix-for-gentoo.patch || die
	eapply "${FILESDIR}"/${PV}/01_fix-for-new-glibc.patch || die
}

src_configure() {
	downgrade_arch_flags 2.8.1
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--prefix=/usr
		--with-gxx-include-dir=/usr/lib/gcc-lib/${CHOST}/2.8.1/include/g++-v2
	)

	# workaround alpha binutils coredump
	if [[ ${ARCH} == "alpha" ]] ; then
		econfargs+=(
			--disable-shared
        )
	else
		econfargs+=(
			--enable-shared
        )
	fi

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
	emake -j1 DESTDIR="${ED}" install || die "failed to run make install"
	mv -v "${ED}"/usr/lib/libstdc++* "${ED}"/usr/lib/gcc-lib/${CHOST}/2.8.1/ || die
	rm -rfv "${ED}"/usr/lib/libiberty.a "${ED}"/usr/${CHOST}
	popd > /dev/null
}

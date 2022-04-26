# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/libs/libc5/old/libc-${PV}.bin.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"

DEPEND="${CATEGORY}/linux-headers"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/libc-${PV}

src_unpack() {
	mkdir -p "${S}" || die
	tar -pxf "${DISTDIR}"/libc-${PV}.bin.tar.gz -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	rm -r lib || die
	mv usr/lib usr/include . || die
	rm -r usr || die
	rm lib/*.so || die
	eapply "${FILESDIR}"/00_${P}.patch || die
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
	case ${CATEGORY} in
	dev-libc5)
		TOOL_SUFFIX="linux-gnulibc1"
		case ${ARCH} in
		amd64|x86)
			TOOL_PREFIX="i586-legacy"
			;;
		*)
			die
			;;
		esac
		;;
	*)
		die
		;;
	esac
	CHOST="${TOOL_PREFIX}-${TOOL_SUFFIX}"
	mkdir -p "${ED}"/usr/${CHOST}/ || die
	cp -avx . "${ED}"/usr/${CHOST}/ || die
	ln -sv libc.a "${ED}"/usr/${CHOST}/lib/libg.a || die
	popd > /dev/null
}

# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

case ${CTARGET} in
	x86_64-pc-cygwin)
		cygwin_arch=x86_64
		;;
	i686-pc-cygwin)
		cygwin_arch=x86
		;;
	*)
		die "Invalid ${CTARGET}"
		;;
esac

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/cygwin/${cygwin_arch}/release/w32api-headers/w32api-headers-10.0.0-1.tar.xz
		https://mirrors.ustc.edu.cn/cygwin/${cygwin_arch}/release/w32api-runtime/w32api-runtime-10.0.0-1.tar.xz
		https://mirrors.ustc.edu.cn/cygwin/${cygwin_arch}/release/cygwin/cygwin-${PV}-1.tar.xz
		https://mirrors.ustc.edu.cn/cygwin/${cygwin_arch}/release/cygwin/cygwin-devel/cygwin-devel-${PV}-1.tar.xz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/cygwin-${PV}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_unpack() {
	mkdir -p "${S}" || die
	tar -pxf "${DISTDIR}"/w32api-headers-10.0.0-1.tar.xz -C "${S}" || die
	tar -pxf "${DISTDIR}"/w32api-runtime-10.0.0-1.tar.xz -C "${S}" || die
	tar -pxf "${DISTDIR}"/cygwin-${PV}-1.tar.xz -C "${S}" || die
	tar -pxf "${DISTDIR}"/cygwin-devel-${PV}-1.tar.xz -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
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
	mkdir -p "${ED}"/usr/${CTARGET}/ || die
	cp -avx . "${ED}"/usr/${CTARGET}/ || die
	ln -sv usr/include/w32api "${ED}"/usr/${CTARGET}/include
	ln -sv usr/lib/w32api "${ED}"/usr/${CTARGET}/lib
	popd > /dev/null
}

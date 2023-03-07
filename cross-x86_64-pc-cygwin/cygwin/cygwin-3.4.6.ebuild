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
		;;
esac

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/cygwin/x86_64/release/w32api-headers/w32api-headers-10.0.0-1.tar.xz -> w32api-headers-10.0.0-1-x86_64.tar.xz
		https://mirrors.ustc.edu.cn/cygwin/x86_64/release/w32api-runtime/w32api-runtime-10.0.0-1.tar.xz -> w32api-runtime-10.0.0-1-x86_64.tar.xz
		https://mirrors.ustc.edu.cn/cygwin/x86_64/release/cygwin/cygwin-${PV}-1.tar.xz -> cygwin-${PV}-1-x86_64.tar.xz
		https://mirrors.ustc.edu.cn/cygwin/x86_64/release/cygwin/cygwin-devel/cygwin-devel-${PV}-1.tar.xz -> cygwin-devel-${PV}-1-x86_64.tar.xz"

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
	tar -pxf "${DISTDIR}"/w32api-headers-10.0.0-1-${cygwin_arch}.tar.xz -C "${S}" || die
	tar -pxf "${DISTDIR}"/w32api-runtime-10.0.0-1-${cygwin_arch}.tar.xz -C "${S}" || die
	tar -pxf "${DISTDIR}"/cygwin-${PV}-1-${cygwin_arch}.tar.xz -C "${S}" || die
	tar -pxf "${DISTDIR}"/cygwin-devel-${PV}-1-${cygwin_arch}.tar.xz -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/${PV}/00_fix-gcc-47.patch
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
	cp -ax . "${ED}"/usr/${CTARGET}/ || die
	ln -sv usr/include/w32api "${ED}"/usr/${CTARGET}/include
	ln -sv usr/lib/w32api "${ED}"/usr/${CTARGET}/lib
	popd > /dev/null
}

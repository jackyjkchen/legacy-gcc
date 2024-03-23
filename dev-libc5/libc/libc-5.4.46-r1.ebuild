# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/libs/libc5/old/libc-${PV}.bin.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"

IUSE="+stdint"

DEPEND="${CATEGORY}/linux-headers"
RDEPEND="${DEPEND}"
BDEPEND="dev-vcs/git"

S=${WORKDIR}/libc-${PV}

src_unpack() {
	mkdir -p "${S}" || die
	tar -pxf "${DISTDIR}"/libc-${PV}.bin.tar.gz -C "${S}" || die
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	git apply -p1 < "${FILESDIR}"/00_${P}.patch || die
	rm -r lib || die
	mv usr/lib usr/include . || die
	rm -r usr || die
	rm lib/*.so || die
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
	CHOST="i586-legacy-linux-gnulibc1"
	mkdir -p "${ED}"/usr/${CHOST}/ || die
	cp -ax . "${ED}"/usr/${CHOST}/ || die
	ln -sv libc.a "${ED}"/usr/${CHOST}/lib/libg.a || die
	if use stdint; then
		cp -ax "${FILESDIR}"/stdint.h "${ED}"/usr/${CHOST}/include/ || die
	fi
	popd > /dev/null
}

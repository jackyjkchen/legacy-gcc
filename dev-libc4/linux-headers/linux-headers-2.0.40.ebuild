# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.0/linux-${PV}.tar.xz"

LICENSE=""
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

unset ARCH

S=${WORKDIR}/linux-${PV}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/00_${P}.patch || die
	popd > /dev/null
}

src_compile() {
	i386 emake mrproper || die
	i386 emake include/linux/version.h || die
	i386 emake symlinks || die
}

src_install() {
	TARGET_PREFIX="i486-legacy-linuxaout"
	UNIX_PREFIX="/usr"
	mkdir -p ${ED}/${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	cp -HR include/asm ${ED}/${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	cp -R include/asm-generic ${ED}/${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	cp -R include/linux ${ED}/${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	touch ${ED}/${UNIX_PREFIX}/${TARGET_PREFIX}/include/linux/autoconf.h || die
}

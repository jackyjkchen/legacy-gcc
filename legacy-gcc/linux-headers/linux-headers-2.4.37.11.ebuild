# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.4/linux-${PV}.tar.xz"

LICENSE=""
SLOT="i486-legacy"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_PREFIX="${SLOT}-linux-gnu"
UNIX_PREFIX="/usr"
unset ARCH

src_unpack(){
	default
	ln -svf linux-${PV} "${WORKDIR}"/${P} || die
}

src_compile() {
	pushd "${WORKDIR}"/${P} > /dev/null
	emake mrproper || die
	emake include/linux/version.h || die
	emake symlinks || die
	popd >/dev/null
}

src_install() {
	pushd "${WORKDIR}"/${P} > /dev/null
	mkdir -p "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete || die
	cp -HR include/asm "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	cp -R include/asm-generic "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	cp -R include/linux "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/include || die
	touch "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/include/linux/autoconf.h || die
	popd >/dev/null
}

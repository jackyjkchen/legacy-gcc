# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.6/longterm/v2.6.32/linux-2.6.32.71.tar.xz"

LICENSE=""
SLOT="i686-legacy"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_PREFIX="${SLOT}-linux-gnu"
UNIX_PREFIX="/usr"
unset ARCH

src_unpack(){
	default
	ln -svf linux-2.6.32.71 "${WORKDIR}"/${P} || die
}

src_compile() {
	pushd "${WORKDIR}"/${P} > /dev/null
	emake mrproper || die
	emake headers_check || die
	popd >/dev/null
}

src_install() {
	pushd "${WORKDIR}"/${P} > /dev/null
	emake INSTALL_HDR_PATH="${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} headers_install || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete
	popd >/dev/null
}

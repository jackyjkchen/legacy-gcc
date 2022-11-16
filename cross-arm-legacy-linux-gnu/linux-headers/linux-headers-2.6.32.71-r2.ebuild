# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.6/longterm/v2.6.32/linux-${PV}.tar.xz"

LICENSE=""
KEYWORDS="arm"
TOOL_PREFIX="arm-legacy"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/make
	sys-devel/gcc:4.4.7"

unset ARCH
HOSTCC="gcc-4.4.7"

S=${WORKDIR}/linux-${PV}

src_compile() {
	emake mrproper || die
	emake HOSTCC=${HOSTCC} headers_check || die
}

src_install() {
	TARGET_PREFIX="${TOOL_PREFIX}-linux-gnu"
	UNIX_PREFIX="/usr"
	emake HOSTCC=${HOSTCC} ARCH=arm INSTALL_HDR_PATH="${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} headers_install || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete || die
}

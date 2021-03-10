# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.6/longterm/v2.6.32/linux-${PV}.tar.xz"

LICENSE=""
KEYWORDS="amd64 x86"
case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	*)
		TOOL_SLOT="invalid"
		;;
esac
SLOT="${TOOL_SLOT}"

DEPEND="sys-devel/make"
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_PREFIX="${TOOL_SLOT}-linux-gnu"
UNIX_PREFIX="/usr"
unset ARCH

S=${WORKDIR}/linux-${PV}

src_compile() {
	emake mrproper || die
	emake headers_check || die
}

src_install() {
	emake INSTALL_HDR_PATH="${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} headers_install || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete || die
}

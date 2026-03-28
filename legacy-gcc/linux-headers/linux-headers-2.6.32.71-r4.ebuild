# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.tuna.tsinghua.edu.cn/kernel/v2.6/longterm/v2.6.32/linux-${PV}.tar.xz"

LICENSE=""
KEYWORDS="alpha amd64 hppa m68k mips ppc ppc64 s390 sh sparc x86"
case ${ARCH} in
	amd64|x86|alpha|hppa|m68k|mips|ppc|ppc64|s390|sparc|sh)
		TOOL_PREFIX="${CHOST%%-*}"
		;;
	*)
		;;
esac
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gcc:4.4.7"

unset ARCH
HOSTCC="gcc-4.4.7"

S=${WORKDIR}/linux-${PV}

src_compile() {
	emake mrproper || die
	emake HOSTCC=${HOSTCC} headers_check || die
}

src_install() {
	TARGET_PREFIX="${TOOL_PREFIX}-legacy-linux-gnu"
	UNIX_PREFIX="/usr"
	emake HOSTCC=${HOSTCC} INSTALL_HDR_PATH="${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} headers_install || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete || die
}

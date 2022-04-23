# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.6/longterm/v2.6.32/linux-${PV}.tar.xz"

LICENSE=""
KEYWORDS="alpha amd64 m68k mips ppc ppc64 s390 sh sparc x86"
case ${ARCH} in
amd64)
	TOOL_PREFIX="x86_64-legacy"
	;;
x86)
	TOOL_PREFIX="i686-legacy"
	;;
alpha|m68k)
	TOOL_PREFIX="${ARCH}-legacy"
	;;
mips|sparc)
	TOOL_PREFIX="${PROFILE_ARCH}-legacy"
	;;
ppc)
	TOOL_PREFIX="powerpc-legacy"
	;;
ppc64)
	TOOL_PREFIX="powerpc64-legacy"
	;;
s390)
	TOOL_PREFIX="s390x-legacy"
	;;
sh)
	TOOL_PREFIX="sh4-legacy"
	;;
*)
	;;
esac
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
	emake HOSTCC=${HOSTCC} INSTALL_HDR_PATH="${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} headers_install || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete || die
}

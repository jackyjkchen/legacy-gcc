# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v2.6/longterm/v2.6.32/linux-${PV}.tar.xz"

LICENSE=""
KEYWORDS="alpha amd64 mips ppc s390 sparc x86"
case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	alpha)
		TOOL_SLOT="${ARCH}-legacy"
		;;
	mips)
		TOOL_SLOT="${PROFILE_ARCH/64/}-legacy"
		;;
	ppc)
		TOOL_SLOT="powerpc-legacy"
		;;
	s390)
		TOOL_SLOT="s390x-legacy"
		;;
	sparc)
		if [[ ${ABI} == "sparc64" ]]; then
			TOOL_SLOT="sparc64-legacy"
		else
			TOOL_SLOT="sparc-legacy"
		fi
		;;
	*)
		TOOL_SLOT="invalid"
		;;
esac
SLOT="${TOOL_SLOT}"

DEPEND="sys-devel/make
	sys-devel/gcc:4.4.7"
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_PREFIX="${TOOL_SLOT}-linux-gnu"
UNIX_PREFIX="/usr"
unset ARCH
HOSTCC="gcc-4.4.7"

S=${WORKDIR}/linux-${PV}

src_compile() {
	emake mrproper || die
	emake HOSTCC=${HOSTCC} headers_check || die
}

src_install() {
	emake HOSTCC=${HOSTCC} INSTALL_HDR_PATH="${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} headers_install || die
	find "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX} -name '..install.cmd' -delete || die
}

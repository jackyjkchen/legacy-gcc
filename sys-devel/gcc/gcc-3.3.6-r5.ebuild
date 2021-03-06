# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PATCH_VER="3"
UCLIBC_VER="1.1"
HTB_VER="1.00-r2"

inherit toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="alpha amd64 m68k mips ppc ppc64 s390 sh sparc x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=">=sys-devel/binutils-2.14.90.0.6-r1"
DEPEND="${RDEPEND}
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"

if is_crosscompile ; then
	DEPEND="${DEPEND} sys-devel/gcc:3.3.6"
	CC="gcc-3.3.6"
	CXX="g++-3.3.6"
else
	DEPEND="${DEPEND} sys-devel/gcc:3.4.6"
	CC="gcc-3.4.6"
	CXX="g++-3.4.6"
fi

src_prepare() {
	toolchain_src_prepare

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		[[ ${ARCH} != "mips" ]] && epatch "${FILESDIR}"/${PV}/libffi-without-libgcj.patch
	fi
	[[ ${ARCH} == "mips" ]] && eapply "${FILESDIR}"/${PV}/00_support_mips64.patch
	[[ ${ARCH} == "mips" && ${DEFAULT_ABI} == "n32" ]] && eapply "${FILESDIR}"/${PV}/01_mips64_default_n32_abi.patch
	[[ ${ARCH} == "sh" ]] && eapply "${FILESDIR}"/${PV}/02_fix_for_sh4_install.patch
}

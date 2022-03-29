# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

case ${ARCH} in
	sh)
		CC="gcc-4.1.2"
		CXX="g++-4.1.2"
		STAGE1_GCC="sys-devel/gcc:4.1.2"
		;;
	*)
		CC="gcc-4.4.7"
		CXX="g++-4.4.7"
		STAGE1_GCC="sys-devel/gcc:4.4.7"
		;;
esac

inherit toolchain

KEYWORDS="alpha amd64 arm ia64 m68k mips ppc ppc64 s390 sh sparc x86"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/binutils-2.14.90.0.8-r1
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:3.4.6"
	CC="gcc-3.4.6"
	CXX="g++-3.4.6"
else
	BDEPEND="${STAGE1_GCC}"
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	# Arch stuff
	case $(tc-arch) in
		amd64)
			if is_multilib ; then
				sed -i -e '/GLIBCXX_IS_NATIVE=/s:false:true:' libstdc++-v3/configure || die
			fi
			;;
		mips)
			eapply "${FILESDIR}"/${PV}/01_backport-mips-t-linux64.patch
			[[ ${DEFAULT_ABI} == "n64" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n64-abi.patch
			[[ ${DEFAULT_ABI} == "n32" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n32-abi.patch
			;;
	esac

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		[[ ${ARCH} != "mips" ]] && eapply "${FILESDIR}"/${PV}/03_libffi-without-libgcj.patch
	fi
}

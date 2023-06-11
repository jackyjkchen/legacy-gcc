# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${CATEGORY} != cross-* ]] ; then
	STAGE1_GCC="sys-devel/gcc:4.4.7"
	case $(tc-arch) in
	amd64)
		TOOL_PREFIX="x86_64-legacy"
		;;
	x86)
		TOOL_PREFIX="i686-legacy"
		;;
	alpha|m68k)
		TOOL_PREFIX="$(tc-arch)-legacy"
		;;
	hppa)
		TOOL_PREFIX="hppa1.1-legacy"
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
		CC="gcc-4.1.2"
		CXX="g++-4.1.2"
		STAGE1_GCC="sys-devel/gcc:4.1.2"
		TOOL_PREFIX="sh4-legacy"
		;;
	*)
		TOOL_PREFIX=""
		;;
	esac

	if [[ ${TOOL_PREFIX} != "" ]]; then
		CBUILD="${TOOL_PREFIX}-linux-gnu"
		CHOST=${CBUILD}
		AS="${CHOST}-as"
		LD="${CHOST}-ld"
		AR="${CHOST}-ar"
		RANLIB="${CHOST}-ranlib"
		LEGACY_DEPEND="
			legacy-gcc/linux-headers
			legacy-gcc/glibc-headers
			legacy-gcc/binutils-wrapper"
	fi
fi

inherit toolchain

KEYWORDS="alpha amd64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=""
DEPEND="${RDEPEND}
	>=${CATEGORY}/binutils-2.14.90.0.8-r1
	amd64? ( >=${CATEGORY}/binutils-2.15.90.0.1.1-r1 )"

if is_crosscompile ; then
	BDEPEND="sys-devel/gcc:3.4.6"
	CC="gcc-3.4.6"
	CXX="g++-3.4.6"
else
	DEPEND="${DEPEND} ${LEGACY_DEPEND}"
	BDEPEND="${STAGE1_GCC}"
	CC=${CC-"gcc-4.4.7"}
	CXX=${CXX-"g++-4.4.7"}
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

	if use objc ; then
		[[ $(tc-arch) != "mips" ]] && eapply "${FILESDIR}"/${PV}/03_libffi-without-libgcj.patch
	fi

	[[ ${TOOL_PREFIX} != "" ]] && eapply "${FILESDIR}"/${PV}/04_workaround-for-legacy-glibc-in-non-system-dir.patch
	[[ $(tc-arch) == "hppa" ]] && eapply "${FILESDIR}"/${PV}/05_hppa-fix-build.patch
	eapply "${FILESDIR}"/${PV}/06_fix-werror.patch
	eapply "${FILESDIR}"/${PV}/07_backport-static-libstdc++-option.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr22127.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr32245.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr55712.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr19627.patch
	eapply "${FILESDIR}"/${PV}/postrelease/05_pr14124.patch
	eapply "${FILESDIR}"/${PV}/postrelease/06_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/07_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/08_pr29631.patch
	eapply "${FILESDIR}"/${PV}/postrelease/09_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/10_pr34130.patch
	eapply "${FILESDIR}"/${PV}/postrelease/11_pr35146.patch
}

src_install() {
	toolchain_src_install
	if [[ ${TOOL_PREFIX} != "" ]]; then
		mkdir -p ${ED}/etc/ld.so.conf.d/ || die
		case ${TOOL_PREFIX} in
			x86_64-legacy|sparc64-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/06-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc/${CHOST}/${PV}
/usr/lib/gcc/${CHOST}/${PV}/32
_EOF_
				;;
			mips64*-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/06-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc/${CHOST}/${PV}
/usr/lib/gcc/${CHOST}/${PV}/32
/usr/lib/gcc/${CHOST}/${PV}/n32
_EOF_
				;;
			*)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/06-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc/${CHOST}/${PV}
_EOF_
				;;
		esac
	fi
}

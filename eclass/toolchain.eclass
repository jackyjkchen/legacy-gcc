# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain.eclass
# @MAINTAINER:
# Toolchain Ninjas <toolchain@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common code for sys-devel/gcc ebuilds
# @DESCRIPTION:
# Common code for sys-devel/gcc ebuilds (and occasionally GCC forks, like
# GNAT for Ada). If not building GCC itself, please use toolchain-funcs.eclass
# instead.

case ${EAPI} in
	7) inherit eutils ;;
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_TOOLCHAIN_ECLASS} ]]; then
_TOOLCHAIN_ECLASS=1

DESCRIPTION="The GNU Compiler Collection"
HOMEPAGE="https://gcc.gnu.org/"

inherit edo fixheadtails flag-o-matic gnuconfig libtool multilib pax-utils toolchain-funcs prefix downgrade-arch-flags

tc_is_live() {
	[[ ${PV} == *9999* ]]
}

if tc_is_live ; then
	EGIT_REPO_URI="https://gcc.gnu.org/git/gcc.git"
	# Naming style:
	# gcc-10.1.0_pre9999 -> gcc-10-branch
	#  Note that the micro version is required or lots of stuff will break.
	#  To checkout master set gcc_LIVE_BRANCH="master" in the ebuild before
	#  inheriting this eclass.
	EGIT_BRANCH="releases/${PN}-${PV%.?.?_pre9999}"
	EGIT_BRANCH=${EGIT_BRANCH//./_}
	inherit git-r3
fi

FEATURES=${FEATURES/multilib-strict/}

#---->> globals <<----

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
: ${TARGET_ABI:=${ABI}}
: ${TARGET_MULTILIB_ABIS:=${MULTILIB_ABIS}}
: ${TARGET_DEFAULT_ABI:=${DEFAULT_ABI}}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

is_mingw64() {
	[[ ${CTARGET} == *-w64-mingw* || ${CTARGET} == x86_64-*-mingw* ]]
}

is_mingw() {
	[[ ${CTARGET} == mingw* || ${CTARGET} == *-mingw* ]] && ! is_mingw64
}

is_cygwin() {
	[[ ${CTARGET} == *-cygwin ]]
}

is_djgpp() {
	[[ ${CTARGET} == *-msdosdjgpp* ]]
}

# @FUNCTION: tc_version_is_at_least
# @USAGE: ver1 [ver2]
# @DESCRIPTION:
# General purpose version check. Without a second argument, matches
# up to minor version (x.x.x).
tc_version_is_at_least() {
	ver_test "${2:-${GCC_RELEASE_VER}}" -ge "$1"
}

# @FUNCTION: tc_version_is_between
# @USAGE: ver1 ver2
# @DESCRIPTION:
# General purpose version range check.
# Note that it matches up to but NOT including the second version
tc_version_is_between() {
	tc_version_is_at_least "${1}" && ! tc_version_is_at_least "${2}"
}

# @ECLASS_VARIABLE: TOOLCHAIN_GCC_PV
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used to override GCC version. Useful for e.g. live ebuilds or snapshots.
# Defaults to ${PV}.

# @ECLASS_VARIABLE: GCC_PV
# @INTERNAL
# @DESCRIPTION:
# Internal variable representing (spoofed) GCC version.
GCC_PV=${TOOLCHAIN_GCC_PV:-${PV}}

# @ECLASS_VARIABLE: GCC_PVR
# @INTERNAL
# @DESCRIPTION:
# Full GCC version including revision.
GCC_PVR=${GCC_PV}
[[ ${PR} != "r0" ]] && GCC_PVR=${GCC_PVR}-${PR}

# GCC_RELEASE_VER must always match 'gcc/BASE-VER' value.
# It's an internal representation of gcc version used for:
# - versioned paths on disk
# - 'gcc -dumpversion' output. Must always match <digit>.<digit>.<digit>.
if [[ ${PN} == "egcs" ]] ; then
	GCC_PV=2.91.66
fi

# @ECLASS_VARIABLE: GCC_RELEASE_VER
# @INTERNAL
# @DESCRIPTION:
# GCC_RELEASE_VER must always match 'gcc/BASE-VER' value.
# It's an internal representation of gcc version used for:
# - versioned paths on disk
# - 'gcc -dumpversion' output. Must always match <digit>.<digit>.<digit>.
GCC_RELEASE_VER=$(ver_cut 1-3 ${GCC_PV})

# @ECLASS_VARIABLE: GCC_BRANCH_VER
# @INTERNAL
# @DESCRIPTION:
# GCC branch version.
GCC_BRANCH_VER=$(ver_cut 1-2 ${GCC_PV})
# @ECLASS_VARIABLE: GCCMAJOR
# @INTERNAL
# @DESCRIPTION:
# Major GCC version.
GCCMAJOR=$(ver_cut 1 ${GCC_PV})
# @ECLASS_VARIABLE: GCCMINOR
# @INTERNAL
# @DESCRIPTION:
# Minor GCC version.
GCCMINOR=$(ver_cut 2 ${GCC_PV})
# @ECLASS_VARIABLE: GCCMICRO
# @INTERNAL
# @DESCRIPTION:
# GCC micro version.
GCCMICRO=$(ver_cut 3 ${GCC_PV})

# @ECLASS_VARIABLE: GCC_CONFIG_VER
# @INTERNAL
# @DESCRIPTION:
# Ideally this variable should allow for custom gentoo versioning
# of binary and gcc-config names not directly tied to upstream
# versioning. In practice it's hard to untangle from gcc/BASE-VER
# (GCC_RELEASE_VER) value.
GCC_CONFIG_VER=${GCC_RELEASE_VER}

# Pre-release support. Versioning schema:
# 1.0.0_pre9999: live ebuild
# 1.2.3_pYYYYMMDD (or 1.2.3_preYYYYMMDD for unreleased major versions): weekly snapshots
# 1.2.3_rcYYYYMMDD: release candidates
if [[ ${GCC_PV} == *_pre* ]] ; then
	# Weekly snapshots
	SNAPSHOT=${GCCMAJOR}-${GCC_PV##*_pre}
elif [[ ${GCC_PV} == *_p* ]] ; then
	# Weekly snapshots
	SNAPSHOT=${GCCMAJOR}-${GCC_PV##*_p}
elif [[ ${GCC_PV} == *_rc* ]] ; then
	# Release candidates
	SNAPSHOT=${GCC_PV%_rc*}-RC-${GCC_PV##*_rc}
fi

PREFIX=${TOOLCHAIN_PREFIX:-${EPREFIX}/usr}

if tc_version_is_at_least 3.4 ; then
	LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc/${CTARGET}/${GCC_CONFIG_VER}}
else
	LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc-lib/${CTARGET}/${GCC_CONFIG_VER}}
fi
INCLUDEPATH=${TOOLCHAIN_INCLUDEPATH:-${LIBPATH}/include}

if is_crosscompile ; then
	BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CHOST}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
	HOSTLIBPATH=${PREFIX}/${CHOST}/${CTARGET}/lib/${GCC_CONFIG_VER}
else
	BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
fi

DATAPATH=${TOOLCHAIN_DATAPATH:-${PREFIX}/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}}

# Don't install in /usr/include/g++-v3/, but instead to gcc's internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR=${TOOLCHAIN_STDCXX_INCDIR:-${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}}

#---->> LICENSE+SLOT+IUSE logic <<----

if tc_version_is_at_least 4.6 ; then
	LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
elif tc_version_is_at_least 4.4 ; then
	LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.2+"
elif tc_version_is_at_least 4.3 ; then
	LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ ) FDL-1.2+"
elif tc_version_is_at_least 4.2 ; then
	LICENSE="GPL-3+ LGPL-2.1+ || ( GPL-3+ libgcc libstdc++ ) FDL-1.2+"
elif tc_version_is_at_least 3.3 ; then
	LICENSE="GPL-2+ LGPL-2.1+ FDL-1.2+"
else
	LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
fi

IUSE="test vanilla +nls"
RESTRICT="!test? ( test )"

is_crosscompile && RESTRICT+=" strip" # cross-compilers need controlled stripping

TC_FEATURES=()

tc_has_feature() {
	has "$1" "${TC_FEATURES[@]}"
}

if [[ ${PN} != kgcc64 && ${PN} != gcc-* ]] ; then
	IUSE+=" debug +nptl" TC_FEATURES+=( nptl )
	[[ -n ${PIE_VER} ]] && IUSE+=" nopie"
	[[ -n ${SPECS_VER} ]] && IUSE+=" nossp"
	case $(tc-arch) in
	alpha)
		tc_version_is_at_least 2.9 && IUSE+=" +cxx"
		tc_version_is_at_least 2.9 && IUSE+=" objc"
		;;
	ppc64)
		tc_version_is_at_least 3.2 && IUSE+=" +cxx"
		tc_version_is_at_least 3.1 && IUSE+=" objc"
		;;
	sparc)
		tc_version_is_at_least 2.9 && IUSE+=" +cxx"
		tc_version_is_at_least 2.8 && IUSE+=" objc"
		;;
	m68k)
		tc_version_is_at_least 2.1 && IUSE+=" +cxx"
		tc_version_is_at_least 2.4 && IUSE+=" objc"
		;;
	*)
		tc_version_is_at_least 2.1 && IUSE+=" +cxx"
		tc_version_is_at_least 2.1 && IUSE+=" objc"
		;;
	esac
	tc_version_is_between 2.9 4.0 && IUSE+=" f77"
	# fortran support appeared in 4.1, but 4.1 needs outdated mpfr
	tc_version_is_at_least 4.1 && IUSE+=" +fortran" TC_FEATURES+=( fortran )
	tc_version_is_between 4.0 4.1 && IUSE+=" f95"
	tc_version_is_at_least 3 && IUSE+=" doc hardened"
	tc_version_is_at_least 3.1 && IUSE+=" multilib"
	tc_version_is_at_least 3.4 && IUSE+=" pgo"
	tc_version_is_at_least 4.0 &&
		IUSE+=" objc-gc" TC_FEATURES+=(objc-gc)
	tc_version_is_at_least 4.1 && IUSE+=" libssp objc++"
	tc_version_is_at_least 4.2 && IUSE+=" +openmp"

	tc_version_is_at_least 4.3 && IUSE+=" fixed-point"
	tc_version_is_at_least 4.7 && IUSE+=" go"

	# sanitizer support appeared in gcc-4.8, but <gcc-5 does not
	# support modern glibc.
	tc_version_is_at_least 5 && IUSE+=" +sanitize"  TC_FEATURES+=( sanitize )

	# Note:
	#   <gcc-4.8 supported graphite, it required forked ppl
	#     versions which we dropped.  Since graphite was also experimental in
	#     the older versions, we don't want to bother supporting it.  #448024
	#   <gcc-5 supported graphite, it required cloog
	#   <gcc-6.5 supported graphite, it required old incompatible isl
	tc_version_is_at_least 6.5 &&
		IUSE+=" graphite" TC_FEATURES+=( graphite )

	tc_version_is_between 4.9 8 && IUSE+=" cilk"
	tc_version_is_at_least 4.9 && IUSE+=" ada"
	tc_version_is_at_least 4.9 && IUSE+=" vtv"
	tc_version_is_at_least 5.0 && IUSE+=" jit"
	tc_version_is_between 5.0 9 && IUSE+=" mpx"
	tc_version_is_at_least 6.0 && IUSE+=" +pie +ssp"
	tc_version_is_at_least 3.4 && IUSE+=" pch"

	# systemtap is a gentoo-specific switch: bug #654748
	tc_version_is_at_least 8.0 &&
		IUSE+=" systemtap" TC_FEATURES+=( systemtap )

	tc_version_is_at_least 9.0 && IUSE+=" d"
	case $(tc-arch) in
	amd64)
		tc_version_is_at_least 4.6 && IUSE+=" lto"
		;;
	x86)
		tc_version_is_at_least 4.7 && IUSE+=" lto"
		;;
	*)
		tc_version_is_at_least 9.1 && IUSE+=" lto"
		;;
	esac
	tc_version_is_at_least 10 && IUSE+=" cet"
	tc_version_is_at_least 10 && IUSE+=" zstd" TC_FEATURES+=( zstd )
	tc_version_is_at_least 11 && IUSE+=" valgrind" TC_FEATURES+=( valgrind )
	tc_version_is_at_least 11 && IUSE+=" custom-cflags"
fi

if tc_version_is_at_least 10; then
	# Note: currently we pull in releases, snapshots and
	# git versions into the same SLOT.
	SLOT="${GCCMAJOR}"
elif [[ ${PN} == "egcs" ]] ; then
	SLOT="${PV}"
else
	SLOT="${GCC_CONFIG_VER}"
fi

#---->> DEPEND <<----

RDEPEND="sys-libs/zlib
	nls? ( virtual/libintl )"

tc_version_is_at_least 3 && RDEPEND+=" virtual/libiconv"

if tc_version_is_at_least 4 ; then
	GMP_MPFR_DEPS=">=dev-libs/gmp-4.3.2:0= >=dev-libs/mpfr-2.4.2:0="
	if tc_version_is_at_least 4.3 ; then
		RDEPEND+=" ${GMP_MPFR_DEPS}"
	elif tc_has_feature fortran ; then
		RDEPEND+=" fortran? ( ${GMP_MPFR_DEPS} )"
	fi
fi

tc_version_is_at_least 4.5 && RDEPEND+=" >=dev-libs/mpc-0.8.1:0="

if tc_has_feature objc-gc ; then
	if tc_version_is_at_least 7 ; then
		RDEPEND+=" objc-gc? ( >=dev-libs/boehm-gc-7.4.2 )"
	fi
fi

if tc_has_feature graphite ; then
	RDEPEND+=" graphite? ( >=dev-libs/isl-0.14:0= )"
fi

BDEPEND="
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4
	nls? ( sys-devel/gettext )
	test? (
		>=dev-util/dejagnu-1.4.4
		>=sys-devel/autogen-5.5.4
	)"
DEPEND="${RDEPEND}"

if tc_has_feature sanitize ; then
	# libsanitizer relies on 'crypt.h' to be present
	# on target. glibc user to provide it unconditionally.
	# Nowadays it's a standalone library: bug #802648
	DEPEND+=" sanitize? ( virtual/libcrypt )"
fi

if tc_has_feature systemtap ; then
	# gcc needs sys/sdt.h headers on target
	DEPEND+=" systemtap? ( dev-util/systemtap )"
fi

if tc_has_feature zstd ; then
	DEPEND+=" zstd? ( app-arch/zstd:= )"
	RDEPEND+=" zstd? ( app-arch/zstd:= )"
fi

if tc_has_feature valgrind ; then
	BDEPEND+=" valgrind? ( dev-util/valgrind )"
fi

PDEPEND=">=sys-devel/gcc-config-2.3"

#---->> S + SRC_URI essentials <<----

# @ECLASS_VARIABLE: TOOLCHAIN_PATCH_SUFFIX
# @DESCRIPTION:
# Used to override compression used for for patchsets.
# Default is xz for EAPI 8+ and bz2 for older EAPIs.
if [[ ${EAPI} == 8 ]] ; then
	: ${TOOLCHAIN_PATCH_SUFFIX:=xz}
else
	# Older EAPIs
	: ${TOOLCHAIN_PATCH_SUFFIX:=bz2}
fi

# @ECLASS_VARIABLE: TOOLCHAIN_SET_S
# @DESCRIPTION:
# Used to override value of S for snapshots and such. Mainly useful
# if needing to set GCC_TARBALL_SRC_URI.
: ${TOOLCHAIN_SET_S:=yes}

# Set the source directory depending on whether we're using
# a live git tree, snapshot, or release tarball.
if [[ ${TOOLCHAIN_SET_S} == yes ]] ; then
	S=$(
		if tc_is_live ; then
			echo ${EGIT_CHECKOUT_DIR}
		elif [[ -n ${SNAPSHOT} ]] ; then
			echo ${WORKDIR}/gcc-${SNAPSHOT}
		elif [[ ${PN} == "egcs" ]] ; then
			echo ${WORKDIR}/${P}
		else
			echo ${WORKDIR}/gcc-${GCC_PV}
		fi
	)
fi

gentoo_urls() {
	local devspace="
		HTTP~soap/distfiles/URI
		HTTP~sam/distfiles/URI
		HTTP~sam/distfiles/sys-devel/gcc/URI
		HTTP~tamiko/distfiles/URI
		HTTP~zorry/patches/gcc/URI
		HTTP~vapier/dist/URI
		HTTP~blueness/dist/URI"
	devspace=${devspace//HTTP/https:\/\/dev.gentoo.org\/}
	echo ${devspace//URI/$1} mirror://gentoo/$1
}

# This function handles the basics of setting the SRC_URI for a gcc ebuild.
# To use, set SRC_URI with:
#
#	SRC_URI="$(get_gcc_src_uri)"
#
# Other than the variables normally set by portage, this function's behavior
# can be altered by setting the following:
#
#	GCC_TARBALL_SRC_URI
#			Override link to main tarball into SRC_URI. Used by dev-lang/gnat-gpl
#			to provide gcc tarball snapshots. Patches are usually reused as-is.
#
#	SNAPSHOT
#			If set, this variable signals that we should be using a snapshot of
#			gcc. It is expected to be in the format "YYYY-MM-DD". Note that if
#			the ebuild has a _pre suffix, this variable is ignored and the
#			prerelease tarball is used instead.
#
#	PATCH_VER
#	PATCH_GCC_VER
#			This should be set to the version of the gentoo patch tarball.
#			The resulting filename of this tarball will be:
#			gcc-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.xz
#
#	PIE_VER
#	PIE_GCC_VER
#			These variables control patching in various updates for the logic
#			controlling Position Independent Executables. PIE_VER is expected
#			to be the version of this patch, and PIE_GCC_VER the gcc version of
#			the patch:
#			An example:
#					PIE_VER="8.7.6.5"
#					PIE_GCC_VER="3.4.0"
#			The resulting filename of this tarball will be:
#			gcc-${PIE_GCC_VER:-${GCC_RELEASE_VER}}-piepatches-v${PIE_VER}.tar.xz
#
#	SPECS_VER
#	SPECS_GCC_VER
#			This is for the minispecs files included in the hardened gcc-4.x
#			The specs files for hardenedno*, vanilla and for building the "specs" file.
#			SPECS_VER is expected to be the version of this patch, SPECS_GCC_VER
#			the gcc version of the patch.
#			An example:
#					SPECS_VER="8.7.6.5"
#					SPECS_GCC_VER="3.4.0"
#			The resulting filename of this tarball will be:
#			gcc-${SPECS_GCC_VER:-${GCC_RELEASE_VER}}-specs-${SPECS_VER}.tar.xz
#
get_gcc_src_uri() {
	export PATCH_GCC_VER=${PATCH_GCC_VER:-${GCC_RELEASE_VER}}
	export MUSL_GCC_VER=${MUSL_GCC_VER:-${PATCH_GCC_VER}}
	export PIE_GCC_VER=${PIE_GCC_VER:-${GCC_RELEASE_VER}}
	export SPECS_GCC_VER=${SPECS_GCC_VER:-${GCC_RELEASE_VER}}

	# Set where to download gcc itself depending on whether we're using a
	# live git tree, snapshot, or release tarball.
	if tc_is_live ; then
		: # Nothing to do w/git snapshots.
	elif [[ -n ${GCC_TARBALL_SRC_URI} ]] ; then
		# Pull gcc tarball from another location. Frequently used by gnat-gpl.
		GCC_SRC_URI="${GCC_TARBALL_SRC_URI}"
	elif [[ -n ${SNAPSHOT} ]] ; then
		GCC_SRC_URI="https://gcc.gnu.org/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.xz"
	else
		if tc_version_is_at_least 5 ; then
			GCC_SRC_URI="http://mirrors.ustc.edu.cn/gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.xz"
		elif tc_version_is_between 3.2 5 ; then
			GCC_SRC_URI="http://mirrors.ustc.edu.cn/gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.bz2"
		elif tc_version_is_between 3.0 3.2 ; then
			GCC_SRC_URI="http://mirrors.ustc.edu.cn/gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.gz"
		elif [[ ${PN} == "egcs" ]] ; then
			GCC_SRC_URI="http://gcc.gnu.org/pub/gcc/old-releases/egcs/${P}.tar.bz2"
		elif tc_version_is_between 2.0 3.0 ; then
			GCC_SRC_URI="http://gcc.gnu.org/pub/gcc/old-releases/gcc-2/gcc-${GCC_PV}.tar.bz2"
		elif tc_version_is_between 1.0 2.0 ; then
			GCC_SRC_URI="http://gcc.gnu.org/pub/gcc/old-releases/gcc-1/gcc-${GCC_PV}.tar.bz2"
		fi
	fi

	if tc_version_is_at_least 10 ; then
		[[ -n ${PATCH_VER} ]] && \
			GCC_SRC_URI+=" $(gentoo_urls gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.${TOOLCHAIN_PATCH_SUFFIX})"
		[[ -n ${MUSL_VER} ]] && \
			GCC_SRC_URI+=" $(gentoo_urls gcc-${MUSL_GCC_VER}-musl-patches-${MUSL_VER}.tar.${TOOLCHAIN_PATCH_SUFFIX})"

		[[ -n ${PIE_VER} ]] && \
			PIE_CORE=${PIE_CORE:-gcc-${PIE_GCC_VER}-piepatches-v${PIE_VER}.tar.${TOOLCHAIN_PATCH_SUFFIX}} && \
			GCC_SRC_URI+=" $(gentoo_urls ${PIE_CORE})"

		# gcc minispec for the hardened gcc 4 compiler
		[[ -n ${SPECS_VER} ]] && \
			GCC_SRC_URI+=" $(gentoo_urls gcc-${SPECS_GCC_VER}-specs-${SPECS_VER}.tar.${TOOLCHAIN_PATCH_SUFFIX})"
	fi

	echo "${GCC_SRC_URI}"
}

SRC_URI=$(get_gcc_src_uri)

unpack_gcc_patchset() {
	export PATCH_GCC_VER=${PATCH_GCC_VER:-${GCC_RELEASE_VER}}
	export PIE_GCC_VER=${PIE_GCC_VER:-${GCC_RELEASE_VER}}
	export SPECS_GCC_VER=${SPECS_GCC_VER:-${GCC_RELEASE_VER}}

	if [[ -n ${PATCH_VER} ]] ; then
		local PATCH_FILE=gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.bz2
		tar -pxf ${FILESDIR}/patchset/${PATCH_FILE} -C ${WORKDIR}/ || die
	fi

	if [[ -n ${PIE_VER} ]] ; then
		local PIE_CORE=${PIE_CORE:-gcc-${PIE_GCC_VER}-piepatches-v${PIE_VER}.tar.bz2}
		tar -pxf ${FILESDIR}/patchset/${PIE_CORE} -C ${WORKDIR}/ || die
	fi

	# gcc minispec for the hardened gcc 4 compiler
	if [[ -n ${SPECS_VER} ]] ; then
		local SPECS_FILE=gcc-${SPECS_GCC_VER}-specs-${SPECS_VER}.tar.bz2
		tar -pxf ${FILESDIR}/patchset/${SPECS_FILE} -C ${WORKDIR}/ || die
	fi

}


#---->> pkg_pretend <<----

toolchain_pkg_pretend() {
	if ! _tc_use_if_iuse cxx ; then
		_tc_use_if_iuse go && \
			ewarn 'Go requires a C++ compiler, disabled due to USE="-cxx"'
		_tc_use_if_iuse objc++ && \
			ewarn 'Obj-C++ requires a C++ compiler, disabled due to USE="-cxx"'
	fi

	want_minispecs
}

#---->> pkg_setup <<----

toolchain_pkg_setup() {
	# We don't want to use the installed compiler's specs to build gcc
	unset GCC_SPECS

	# bug #265283
	unset LANGUAGES
}

git_init_src() {
	pushd "${WORKDIR}"/${P} > /dev/null
	git init && git config user.name toolchain && \
	git config user.email "toolchain@localhost" && \
	git add * && git commit -am "init" 1>/dev/null
	popd > /dev/null
}

#---->> src_unpack <<----

toolchain_src_unpack() {
	if tc_is_live ; then
		git-r3_src_unpack
	fi

	default_src_unpack
	tc_version_is_at_least 10 || unpack_gcc_patchset
	#tc_version_is_at_least 4.7 || git_init_src
}

#---->> src_prepare <<----

toolchain_src_prepare() {
	export BRANDING_GCC_PKGVERSION="Gentoo ${GCC_PVR}"
	cd "${S}" || die

	do_gcc_gentoo_patches
	do_gcc_PIE_patches
	do_gcc_MINGW64_patches
	do_gcc_MINGW_patches
	do_gcc_CYGWIN_patches
	do_gcc_DJGPP_patches

	if tc_is_live ; then
		BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION}, commit ${EGIT_VERSION}"
	fi

	eapply_user

	if ( tc_version_is_at_least 4.8.2 || _tc_use_if_iuse hardened ) \
		   && ! use vanilla ; then
		make_gcc_hard
	fi

	# install the libstdc++ python into the right location
	# http://gcc.gnu.org/PR51368
	if tc_version_is_between 4.5 4.7 ; then
		sed -i \
			'/^pythondir =/s:=.*:= $(datadir)/python:' \
			"${S}"/libstdc++-v3/python/Makefile.in || die
	fi

	# make sure the pkg-config files install into multilib dirs.
	# since we configure with just one --libdir, we can't use that
	# (as gcc itself takes care of building multilibs). bug #435728
	find "${S}" -name Makefile.in \
		-exec sed -i '/^pkgconfigdir/s:=.*:=$(toolexeclibdir)/pkgconfig:' {} +

	# No idea when this first started being fixed, but let's go with 4.3.x for now
	if tc_version_is_between 2.9 4.3 ; then
		fix_files=""
		for x in contrib/test_summary libstdc++-v3/scripts/check_survey.in ; do
			[[ -e ${x} ]] && fix_files="${fix_files} ${x}"
		done
		ht_fix_file ${fix_files} */configure *.sh */Makefile.in
	fi

	setup_multilib_osdirnames

	if tc_version_is_at_least 2.9 ; then
		gcc_version_patch
	fi

	if tc_version_is_at_least 4.1 ; then
		local actual_version=$(< "${S}"/gcc/BASE-VER)
		if [[ "${GCC_RELEASE_VER}" != "${actual_version}" ]] ; then
			eerror "'${S}/gcc/BASE-VER' contains '${actual_version}', expected '${GCC_RELEASE_VER}'"
			die "Please set 'TOOLCHAIN_GCC_PV' to '${actual_version}'"
		fi
	fi

	if tc_version_is_at_least 3.1 ; then
		# disable --as-needed from being compiled into gcc specs
		# natively when using a gcc version < 3.4.4
		# http://gcc.gnu.org/PR14992
		if ! tc_version_is_at_least 3.4.4 ; then
			sed -i -e s/HAVE_LD_AS_NEEDED/USE_LD_AS_NEEDED/g "${S}"/gcc/config.in || die
		fi
	fi

	# Prevent libffi from being installed
	if tc_version_is_between 3.0 4.8 && ! is_djgpp ; then
		sed -i -e 's/\(install.*:\) install-.*recursive/\1/' "${S}"/libffi/Makefile.in || die
		sed -i -e 's/\(install-data-am:\).*/\1/' "${S}"/libffi/include/Makefile.in || die
	fi

	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# Update configure files
	local f
	einfo "Fixing misc issues in configure files"
	for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)) ; do
		ebegin "  Updating ${f/${S}\/} [LANG]"
		if tc_version_is_at_least 2.95 ; then
			patch "${f}" "${FILESDIR}"/gcc-configure-LANG.patch >& "${T}"/configure-patch.log \
			|| eerror "Please file a bug about this"
		fi
		eend $?
	done
	# bug #215828
	if tc_version_is_at_least 3 ; then
		sed -i 's|A-Za-z0-9|[:alnum:]|g' "${S}"/gcc/*.awk || die #215828
	fi

	# Prevent new texinfo from breaking old versions (see #198182, bug #464008)
	if tc_version_is_at_least 4.1; then
		einfo "Remove texinfo (bug #198182, bug #464008)"
		eapply "${FILESDIR}"/gcc-configure-texinfo.patch
	fi

	# >=gcc-4
	if [[ -x contrib/gcc_update ]] ; then
		einfo "Touching generated files"
		./contrib/gcc_update --touch | \
			while read f ; do
				einfo "  ${f%%...}"
			done
	fi
}

do_gcc_gentoo_patches() {
	if ! use vanilla ; then
		if [[ -n ${PATCH_VER} ]] ; then
			einfo "Applying Gentoo patches ..."
			eapply "${WORKDIR}"/patch/*.patch
			BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION} p${PATCH_VER}"
		fi

		if [[ -n ${MUSL_VER} ]] && [[ ${CTARGET} == *musl* ]] ; then
			if [[ ${CATEGORY} == cross-* ]] ; then
				# We don't want to apply some patches when cross-compiling.
				if [[ -d "${WORKDIR}"/musl/nocross ]] ; then
					rm -fv "${WORKDIR}"/musl/nocross/*.patch || die
				else
					# Just make an empty directory to make the glob below easier.
					mkdir -p "${WORKDIR}"/musl/nocross || die
				fi
			fi

			local shopt_save=$(shopt -p nullglob)
			shopt -s nullglob
			einfo "Applying musl patches ..."
			eapply "${WORKDIR}"/musl/{,nocross/}*.patch
			${shopt_save}
		fi
	fi
}

do_gcc_PIE_patches() {
	want_pie || return 0
	use vanilla && return 0

	einfo "Applying PIE patches ..."
	eapply "${WORKDIR}"/piepatch/*.patch

	BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION}, pie-${PIE_VER}"
}

do_gcc_MINGW64_patches() {
	is_mingw64 || return 0

	if [ -d "${FILESDIR}/${GCC_RELEASE_VER}/mingw64" ]; then
		einfo "Applying mingw64 port patches ..."
		eapply "${FILESDIR}"/${GCC_RELEASE_VER}/mingw64/*.patch
	fi
}

do_gcc_MINGW_patches() {
	is_mingw || return 0

	if [ -d "${FILESDIR}/${GCC_RELEASE_VER}/mingw" ]; then
		einfo "Applying mingw port patches ..."
		eapply "${FILESDIR}"/${GCC_RELEASE_VER}/mingw/*.patch
	fi
}

do_gcc_CYGWIN_patches() {
	is_cygwin || return 0

	if [ -d "${FILESDIR}/${GCC_RELEASE_VER}/cygwin" ]; then
		einfo "Applying cygwin port patches ..."
		eapply "${FILESDIR}"/${GCC_RELEASE_VER}/cygwin/*.patch
	fi
	[[ ${CTARGET} == x86_64-*-cygwin ]] && \
	if [ -d "${FILESDIR}/${GCC_RELEASE_VER}/cygwin64" ]; then
		einfo "Applying cygwin64 port patches ..."
		eapply "${FILESDIR}"/${GCC_RELEASE_VER}/cygwin64/*.patch
	fi
}

do_gcc_DJGPP_patches() {
	if is_djgpp ; then
		rm -rf boehm-gc fastjar gcc/go gcc/java gcc/treelang gotools \
			libatomic libcilkrts libgo libgomp libitm libjava libmudflap \
			libmpx liboffloadmic libsanitizer libvtv zlib lt~obsolete.m4
		tc_version_is_at_least 4.1 || rm -rf libssp
		tc_version_is_at_least 7 || rm -rf gcc/testsuite
		tc_version_is_at_least 8 || rm -rf libffi
		if [ -d "${FILESDIR}/${GCC_RELEASE_VER}/djgpp" ]; then
			einfo "Applying djgpp port patches ..."
			eapply "${FILESDIR}"/${GCC_RELEASE_VER}/djgpp/*.patch
		fi
	fi
}

# configure to build with the hardened GCC specs as the default
make_gcc_hard() {
	local gcc_hard_flags=""

	# If we use gcc-6 or newer with PIE enabled to compile older gcc,
	# we need to pass -no-pie to stage1; bug #618908
	if ! tc_version_is_at_least 6.0 && [[ $(gcc-major-version) -ge 6 ]] ; then
		einfo "Disabling PIE in stage1 (only) ..."
		sed -i -e "/^STAGE1_LDFLAGS/ s/$/ -no-pie/" "${S}"/Makefile.in || die
	fi

	# For gcc >= 6.x, we can use configuration options to turn PIE/SSP
	# on as default
	if tc_version_is_at_least 6.0 ; then
		if _tc_use_if_iuse pie ; then
			einfo "Updating gcc to use automatic PIE building ..."
		fi
		if _tc_use_if_iuse ssp ; then
			einfo "Updating gcc to use automatic SSP building ..."
		fi
		if _tc_use_if_iuse hardened ; then
			# Will add some hardened options as default, like:
			# * -fstack-clash-protection
			# * -z now
			# See gcc *_all_extra-options.patch patches.
			gcc_hard_flags+=" -DEXTRA_OPTIONS"

			if _tc_use_if_iuse cet && [[ ${CTARGET} == *x86_64*-linux* ]] ; then
				gcc_hard_flags+=" -DEXTRA_OPTIONS_CF"
			fi

			# Rebrand to make bug reports easier
			BRANDING_GCC_PKGVERSION=${BRANDING_GCC_PKGVERSION/Gentoo/Gentoo Hardened}
		fi
	else
		if _tc_use_if_iuse hardened ; then
			# Rebrand to make bug reports easier
			BRANDING_GCC_PKGVERSION=${BRANDING_GCC_PKGVERSION/Gentoo/Gentoo Hardened}
			if hardened_gcc_works ; then
				einfo "Updating gcc to use automatic PIE + SSP building ..."
				gcc_hard_flags+=" -DEFAULT_PIE_SSP"
			elif hardened_gcc_works pie ; then
				einfo "Updating gcc to use automatic PIE building ..."
				ewarn "SSP has not been enabled by default"
				gcc_hard_flags+=" -DEFAULT_PIE"
			elif hardened_gcc_works ssp ; then
				einfo "Updating gcc to use automatic SSP building ..."
				ewarn "PIE has not been enabled by default"
				gcc_hard_flags+=" -DEFAULT_SSP"
			else
				# Do nothing if hardened isn't supported, but don't die either
				ewarn "hardened is not supported for this arch in this gcc version"
				return 0
			fi
		else
			if hardened_gcc_works ssp ; then
				einfo "Updating gcc to use automatic SSP building ..."
				gcc_hard_flags+=" -DEFAULT_SSP"
			fi
		fi
	fi

	# We want to be able to control the PIE patch logic via something other
	# than ALL_CFLAGS...
	sed -e '/^ALL_CFLAGS/iHARD_CFLAGS = ' \
		-e 's|^ALL_CFLAGS = |ALL_CFLAGS = $(HARD_CFLAGS) |' \
		-i "${S}"/gcc/Makefile.in || die
	# Need to add HARD_CFLAGS to ALL_CXXFLAGS on >= 4.7
	if tc_version_is_at_least 4.7 ; then
		sed -e '/^ALL_CXXFLAGS/iHARD_CFLAGS = ' \
			-e 's|^ALL_CXXFLAGS = |ALL_CXXFLAGS = $(HARD_CFLAGS) |' \
			-i "${S}"/gcc/Makefile.in || die
	fi

	sed -i \
		-e "/^HARD_CFLAGS = /s|=|= ${gcc_hard_flags} |" \
		"${S}"/gcc/Makefile.in || die

}

# This is a historical wart.  The original Gentoo/amd64 port used:
#    lib32 - 32bit binaries (x86)
#    lib64 - 64bit binaries (x86_64)
#    lib   - "native" binaries (a symlink to lib64)
# Most other distros use the logic (including mainline gcc):
#    lib   - 32bit binaries (x86)
#    lib64 - 64bit binaries (x86_64)
# Over time, Gentoo is migrating to the latter form (17.1 profiles).
#
# Unfortunately, due to distros picking the lib32 behavior, newer gcc
# versions will dynamically detect whether to use lib or lib32 for its
# 32bit multilib.  So, to keep the automagic from getting things wrong
# while people are transitioning from the old style to the new style,
# we always set the MULTILIB_OSDIRNAMES var for relevant targets.
setup_multilib_osdirnames() {
	is_multilib || return 0

	local config
	local libdirs="../lib64 ../lib32"

	# This only makes sense for some Linux targets
	case ${CTARGET} in
		x86_64*-linux*)    config="i386" ;;
		powerpc64*-linux*) config="rs6000" ;;
		sparc64*-linux*)   config="sparc" ;;
		s390x*-linux*)     config="s390" ;;
		*)	               return 0 ;;
	esac
	config+="/t-linux64"

	local sed_args=()
	if tc_version_is_at_least 4.6 ; then
		sed_args+=( -e 's:$[(]call if_multiarch[^)]*[)]::g' )
	fi
	if [[ ${SYMLINK_LIB} == "yes" ]] ; then
		einfo "Updating multilib directories to be: ${libdirs}"
		if tc_version_is_at_least 4.6.4 || tc_version_is_at_least 4.7 ; then
			sed_args+=( -e '/^MULTILIB_OSDIRNAMES.*lib32/s:[$][(]if.*):../lib32:' )
		else
			sed_args+=( -e "/^MULTILIB_OSDIRNAMES/s:=.*:= ${libdirs}:" )
		fi
	else
		einfo "Using upstream multilib; disabling lib32 autodetection"
		sed_args+=( -r -e 's:[$][(]if.*,(.*)[)]:\1:' )
	fi
	sed -i "${sed_args[@]}" "${S}"/gcc/config/${config} || die
}

gcc_version_patch() {
	# gcc-4.3+ has configure flags (whoo!)
	tc_version_is_at_least 4.3 && return 0

	local version_string=${GCC_RELEASE_VER}

	einfo "Patching gcc version: ${version_string} (${BRANDING_GCC_PKGVERSION})"

	local gcc_sed=( -e 's:gcc\.gnu\.org/bugs\.html:bugs\.gentoo\.org/:' )
	if grep -qs VERSUFFIX "${S}"/gcc/version.c ; then
		gcc_sed+=( -e "/VERSUFFIX \"\"/s:\"\":\" (${BRANDING_GCC_PKGVERSION})\":" )
	else
		version_string="${version_string} (${BRANDING_GCC_PKGVERSION})"
		gcc_sed+=( -e "/const char version_string\[\] = /s:= \".*\":= \"${version_string}\":" )
	fi
	sed -i "${gcc_sed[@]}" "${S}"/gcc/version.c || die
}

#---->> src_configure <<----

toolchain_src_configure() {
	downgrade_arch_flags ${GCC_BRANCH_VER}
	gcc_do_filter_flags

	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""
	einfo "LDFLAGS=\"${LDFLAGS}\""

	# Force internal zip based jar script to avoid random
	# issues with 3rd party jar implementations. bug #384291
	export JAR=no

	# For hardened gcc 4.3: add the pie patchset to build the hardened specs
	# file (build.specs) to use when building gcc.
	if ! tc_version_is_at_least 4.4 && want_minispecs ; then
		setup_minispecs_gcc_build_specs
	fi

	local confgcc
	if tc_version_is_at_least 2.0 ; then
		confgcc=( --host=${CHOST} )

		if is_crosscompile || tc-is-cross-compiler ; then
			# Straight from the GCC install doc:
			# "GCC has code to correctly determine the correct value for target
			# for nearly all native systems. Therefore, we highly recommend you
			# not provide a configure target when configuring a native compiler."
			confgcc+=( --target=${CTARGET} )
		fi
	else
		confgcc=( -srcdir=../${P} ${CHOST} )
	fi

	local build_config_targets=()

	if tc_version_is_at_least 2.3 ; then
		[[ -n ${CBUILD} ]] && confgcc+=( --build=${CBUILD} )
	fi

	tc_version_is_between 2.0 2.6 && confgcc+=( --target=${CTARGET} )

	if tc_version_is_at_least 2.3 ; then
		confgcc+=( 
			--prefix="${PREFIX}"
		)
	fi

	if ! tc_version_is_at_least 2.5 ; then
		export gcc_cv_prog_makeinfo_modern=no
		export ac_cv_have_x='have_x=yes ac_x_includes= ac_x_libraries='

		confgcc+=( "$@" ${EXTRA_ECONF} )

		mkdir -p "${WORKDIR}"/build
		pushd "${WORKDIR}"/build > /dev/null

		addwrite /dev/zero
		echo "${S}"/configure "${confgcc[@]}"
		CONFIG_SHELL="${EPREFIX}/bin/bash" \
		bash "${S}"/configure "${confgcc[@]}" || die "failed to run configure"

		popd > /dev/null
		return 0
	fi

	if tc_version_is_at_least 2.8 ; then
		confgcc+=(
			--bindir="${BINPATH}"
			--includedir="${INCLUDEPATH}"
			--datadir="${DATAPATH}"
			--mandir="${DATAPATH}/man"
			--infodir="${DATAPATH}/info"
			--with-gxx-include-dir="${STDCXX_INCDIR}"
		)
	fi


	# Stick the python scripts in their own slotted directory (bug #279252)
	#
	#  --with-python-dir=DIR
	#  Specifies where to install the Python modules used for aot-compile. DIR
	#  should not include the prefix used in installation. For example, if the
	#  Python modules are to be installed in /usr/lib/python2.5/site-packages,
	#  then --with-python-dir=/lib/python2.5/site-packages should be passed.
	#
	# This should translate into "/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}/python"
	if tc_version_is_at_least 4.4 ; then
		confgcc+=( --with-python-dir=${DATAPATH/$PREFIX/}/python )
	fi

	### language options

	local GCC_LANG="c"
	is_cxx && GCC_LANG+=",c++"
	is_d   && GCC_LANG+=",d"
	is_go  && GCC_LANG+=",go"
	if is_objc || is_objcxx ; then
		GCC_LANG+=",objc"
		if tc_version_is_at_least 4 ; then
			use objc-gc && confgcc+=( --enable-objc-gc )
		fi
		is_objcxx && GCC_LANG+=",obj-c++"
	fi

	# Fortran support just got sillier! The lang value can be f77 for
	# fortran77, f95 for fortran95, or just plain old fortran for the
	# currently supported standard depending on gcc version.
	is_fortran && GCC_LANG+=",fortran"
	is_f77 && GCC_LANG+=",f77"
	is_f95 && GCC_LANG+=",f95"

	is_ada && GCC_LANG+=",ada"

	tc_version_is_at_least 2.9 && confgcc+=( --enable-languages=${GCC_LANG} )

	### general options

	confgcc+=(
		--enable-obsolete
		--enable-secureplt
		--with-system-zlib
	)

	if tc_version_is_at_least 2.7 ; then
		confgcc+=( --disable-werror )
	fi

	if use nls ; then
		confgcc+=( --enable-nls )
		tc_version_is_at_least 2.6 && confgcc+=( --without-included-gettext )
	else
		tc_version_is_at_least 2.7 && confgcc+=( --disable-nls )
	fi

	if tc_version_is_between 2.7 3.4 ; then
		confgcc+=( --disable-libunwind-exceptions )
	fi

	# Use the default ("release") checking because upstream usually neglects
	# to test "disabled" so it has a history of breaking. bug #317217
	if tc_version_is_at_least 3.4 && in_iuse debug ; then
		# The "release" keyword is new to 4.0. bug #551636
		local off=$(tc_version_is_at_least 4.0 && echo release || echo no)
		confgcc+=( --enable-checking="${GCC_CHECKS_LIST:-$(usex debug yes ${off})}" )
	fi

	# Branding
	tc_version_is_at_least 4.3 && confgcc+=(
		--with-bugurl=https://bugs.gentoo.org/
		--with-pkgversion="${BRANDING_GCC_PKGVERSION}"
	)

	# If we want hardened support with the newer PIE patchset for >=gcc 4.4
	if tc_version_is_at_least 4.4 && want_minispecs && in_iuse hardened ; then
		confgcc+=( $(use_enable hardened esp) )
	fi

	# Allow gcc to search for clock funcs in the main C lib.
	# if it can't find them, then tough cookies -- we aren't
	# going to link in -lrt to all C++ apps. bug #411681
	if tc_version_is_at_least 4.4 && is_cxx ; then
		confgcc+=( --enable-libstdcxx-time )
	fi

	# Build compiler itself using LTO
	if tc_version_is_at_least 4.6 && _tc_use_if_iuse lto ; then
		build_config_targets+=( bootstrap-lto )
	fi

	if tc_version_is_at_least 12 && _tc_use_if_iuse cet ; then
		build_config_targets+=( bootstrap-cet )
	fi

	# Support to disable PCH when building libstdcxx
	if tc_version_is_at_least 3.4 && ! _tc_use_if_iuse pch ; then
		confgcc+=( --disable-libstdcxx-pch )
	fi

	# build-id was disabled for file collisions: bug #526144
	#
	# # Turn on the -Wl,--build-id flag by default for ELF targets. bug #525942
	# # This helps with locating debug files.
	# case ${CTARGET} in
	# *-linux-*|*-elf|*-eabi)
	# 	tc_version_is_at_least 4.5 && confgcc+=(
	# 		--enable-linker-build-id
	# 	)
	# 	;;
	# esac

	# Newer gcc versions like to bootstrap themselves with C++,
	# so we need to manually disable it ourselves
	if tc_version_is_between 4.7 4.8 && ! is_cxx ; then
		confgcc+=( --disable-build-with-cxx --disable-build-poststage1-with-cxx )
	fi

	### Cross-compiler options
	if is_crosscompile ; then
		# Enable build warnings by default with cross-compilers when system
		# paths are included (e.g. via -I flags).
		confgcc+=( --enable-poison-system-directories )

		# When building a stage1 cross-compiler (just C compiler), we have to
		# disable a bunch of features or gcc goes boom
		local needed_libc=""
		case ${CTARGET} in
			*-linux)
				needed_libc=error-unknown-libc
				;;
			*-dietlibc)
				needed_libc=dietlibc
				;;
			*-elf|*-eabi)
				needed_libc=newlib
				# Bare-metal targets don't have access to clock_gettime()
				# arm-none-eabi example: bug #589672
				# But we explicitly do --enable-libstdcxx-time above.
				# Undoing it here.
				confgcc+=( --disable-libstdcxx-time )
				;;
			*-gnu*)
				needed_libc=glibc
				;;
			*-klibc)
				needed_libc=klibc
				;;
			*-musl*)
				needed_libc=musl
				;;
			i[3456]86-legacy-cygwin)
				needed_libc=cygwin
				confgcc+=( --disable-shared --enable-threads=posix --disable-symvers )
				;;
			*-cygwin)
				needed_libc=cygwin
				confgcc+=( --enable-shared --enable-threads=posix )
				;;
			x86_64-*-mingw*|*-w64-mingw*)
				needed_libc=mingw64-runtime
				confgcc+=( --enable-shared --enable-threads=win32 )
				;;
			mingw*|*-mingw*)
				needed_libc=mingw-runtime
				confgcc+=( --enable-shared --enable-threads=win32 )
				;;
			*-msdosdjgpp*)
				needed_libc=djgpp
				confgcc+=( --disable-shared --enable-threads=single )
				;;
			avr)
				confgcc+=( --enable-shared --disable-threads )
				;;
		esac

		if [[ -n ${needed_libc} ]] ; then
			local confgcc_no_libc=( --disable-shared )
			# requires libc: bug #734820
			tc_version_is_at_least 4.6 && confgcc_no_libc+=( --disable-libquadmath )
			# requires libc
			tc_version_is_at_least 4.8 && confgcc_no_libc+=( --disable-libatomic )

			if ! has_version ${CATEGORY}/${needed_libc} ; then
				confgcc+=(
					"${confgcc_no_libc[@]}"
					--disable-threads
					--without-headers
				)
				if [[ ${needed_libc} == glibc ]] ; then
					# By default gcc looks at glibc's headers
					# to detect long double support. This does
					# not work for --disable-headers mode.
					# Any >=glibc-2.4 is good enough for float128.
					# The option appeared in gcc-4.2.
					confgcc+=( --with-long-double-128 )
				fi
			elif has_version "${CATEGORY}/${needed_libc}[headers-only(-)]" ; then
				confgcc+=(
					"${confgcc_no_libc[@]}"
					--with-sysroot="${PREFIX}"/${CTARGET}
				)
			else
				confgcc+=( --with-sysroot="${PREFIX}"/${CTARGET} )
			fi
		fi

		tc_version_is_at_least 4.2 && confgcc+=( --disable-bootstrap )
	else
		if tc-is-static-only ; then
			confgcc+=( --disable-shared )
		elif [[ $(tc-arch) == "ppc64" ]] && ! tc_version_is_at_least 3.3 ; then
			confgcc+=( --enable-shared=libgcc)
		else
			confgcc+=( --enable-shared )
		fi
		case ${CHOST} in
			mingw*|*-mingw*)
				confgcc+=( --enable-threads=win32 )
				;;
			*)
				confgcc+=( --enable-threads=posix )
				;;
		esac
	fi

	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	case ${CTARGET} in
		*-elf|*-eabi)
			confgcc+=( --with-newlib )
			;;
		*-musl*)
			confgcc+=( --enable-__cxa_atexit )
			;;
		*-gnu*)
			confgcc+=(
				--enable-__cxa_atexit
				--enable-clocale=gnu
			)
			;;
		*-cygwin)
			if tc_version_is_at_least 4.8 ; then
				confgcc+=( --enable-__cxa_atexit )
			else
				confgcc+=( --disable-__cxa_atexit --disable-libitm )
			fi
			if tc_version_is_at_least 4.0 ; then
				confgcc+=( 
					--enable-clocale=gnu
				)
			else
				confgcc+=( 
					--enable-clocale=generic
				)
			fi
			confgcc+=(
				--with-dwarf2
			)
			[[ ${CTARGET} == x86_64-*-cygwin ]] || \
			confgcc+=(
				--disable-sjlj-exceptions
			)
			;;
		*-solaris*)
			confgcc+=( --enable-__cxa_atexit )
			;;
	esac

	### arch options

	gcc-multilib-configure

	# gcc has fixed-point arithmetic support in 4.3 for mips targets that can
	# significantly increase compile time by several hours.  This will allow
	# users to control this feature in the event they need the support.
	tc_version_is_at_least 4.3 && in_iuse fixed-point && confgcc+=( $(use_enable fixed-point) )

	case ${CTARGET} in
		arm*-*-linux-gnu)
			;;
		*)
			case $(tc-is-softfloat) in
				yes)
					confgcc+=( --with-float=soft )
					;;
				softfp)
					confgcc+=( --with-float=softfp )
					;;
				*)
					# If they've explicitly opt-ed in, do hardfloat,
					# otherwise let the gcc default kick in.
					case ${CTARGET//_/-} in
						*-hardfloat-*|*eabihf)
							confgcc+=( --with-float=hard )
					;;
					esac
			esac
			;;
	esac

	local with_abi_map=()
	case $(tc-arch) in
		alpha)
			if ! tc_version_is_at_least 3.1 ; then
				CFLAGS="${CFLAGS} -gstabs+"
				CXXFLAGS="${CXXFLAGS} -gstabs+"
			fi
			;;
		arm)
			# bug #264534, bug #414395
			local a arm_arch=${CTARGET%%-*}
			# Remove trailing endian variations first: eb el be bl b l
			for a in e{b,l} {b,l}e b l ; do
				if [[ ${arm_arch} == *${a} ]] ; then
					arm_arch=${arm_arch%${a}}
					break
				fi
			done

			# Convert armv6m to armv6-m
			[[ ${arm_arch} == armv6m ]] && arm_arch=armv6-m
			# Convert armv7{a,r,m} to armv7-{a,r,m}
			[[ ${arm_arch} == armv7? ]] && arm_arch=${arm_arch/7/7-}
			# See if this is a valid --with-arch flag
			if (srcdir=${S}/gcc target=${CTARGET} with_arch=${arm_arch};
			    . "${srcdir}"/config.gcc) &>/dev/null
			then
				confgcc+=( --with-arch=${arm_arch} )
			fi

			# Make default mode thumb for microcontroller classes, bug #418209
			[[ ${arm_arch} == *-m ]] && confgcc+=( --with-mode=thumb )

			# Enable hardvfp
			if [[ $(tc-is-softfloat) == "no" ]] && \
			   [[ ${CTARGET} == armv[67]* ]] && \
			   tc_version_is_at_least 4.5
			then
				# Follow the new arm hardfp distro standard by default
				confgcc+=( --with-float=hard )
				case ${CTARGET} in
					armv6*) confgcc+=( --with-fpu=vfp ) ;;
					armv7*) confgcc+=( --with-fpu=vfpv3-d16 ) ;;
				esac
			fi
			;;
		mips)
			# Add --with-abi flags to set default ABI
			tc_version_is_at_least 3.4 && confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
			;;
		amd64)
			# drop the older/ABI checks once this get's merged into some
			# version of gcc upstream
			if tc_version_is_at_least 4.8 && has x32 $(get_all_abis TARGET) ; then
				confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
			fi
			;;
		x86)
			# Default arch for x86 is normally i386, let's give it a bump
			# since glibc will do so based on CTARGET anyways
			tc_version_is_at_least 3.0 && confgcc+=( --with-arch=${CTARGET%%-*} )
			;;
		hppa)
			# Enable sjlj exceptions for backward compatibility on hppa
			[[ ${GCCMAJOR} == "3" ]] && confgcc+=( --enable-sjlj-exceptions )
			;;
		ppc)
			# Set up defaults based on current CFLAGS
			is-flagq -mfloat-gprs=double && confgcc+=( --enable-e500-double )
			[[ ${CTARGET//_/-} == *-e500v2-* ]] && confgcc+=( --enable-e500-double )
			;;
		ppc64)
			# On ppc64, the big endian target gcc assumes elfv1 by default,
			# and elfv2 on little endian.
			# But musl does not support elfv1 at all on any endian ppc64.
			# See:
			# - https://git.musl-libc.org/cgit/musl/tree/INSTALL
			# - bug #704784
			# - https://gcc.gnu.org/PR93157
			[[ ${CTARGET} == powerpc64-*-musl ]] && confgcc+=( --with-abi=elfv2 )
			# <gcc-3.4 not support -m64
			if ! tc_version_is_at_least 3.4; then
				CFLAGS_ppc64=""
				CFLAGS_ppc=""
			fi
			;;
		riscv)
			# Add --with-abi flags to set default ABI
			confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
			;;
		sparc)
			if ! tc_version_is_at_least 3.1 && [[ ${ABI} == "sparc64" ]]; then
				CFLAGS="${CFLAGS} -gstabs+"
				CXXFLAGS="${CXXFLAGS} -gstabs+"
			fi
			;;
	esac

	# If the target can do biarch (-m32/-m64), enable it.  overhead should
	# be small, and should simplify building of 64bit kernels in a 32bit
	# userland by not needing sys-devel/kgcc64. bug #349405
	case $(tc-arch) in
		ppc|ppc64)
			tc_version_is_at_least 3.4 && confgcc+=( --enable-targets=all )
			;;
		sparc)
			tc_version_is_at_least 4.4 && confgcc+=( --enable-targets=all )
			;;
		amd64|x86)
			tc_version_is_at_least 4.3 && confgcc+=( --enable-targets=all )
			;;
	esac

	tc_version_is_between 2.7 3.1 && confgcc+=( --enable-version-specific-runtime-libs )

	# On Darwin we need libdir to be set in order to get correct install names
	# for things like libobjc-gnu, libgcj and libfortran.  If we enable it on
	# non-Darwin we screw up the behaviour this eclass relies on.  We in
	# particular need this over --libdir for bug #255315.
	[[ ${CTARGET} == *-darwin* ]] && \
		confgcc+=( --enable-version-specific-runtime-libs )

	### library options

	if tc_version_is_between 3.0 7.0 ; then
		confgcc+=( --disable-libgcj )
	fi

	if tc_version_is_at_least 4.2 ; then
		if in_iuse openmp ; then
			# Make sure target has pthreads support. #326757 #335883
			# There shouldn't be a chicken & egg problem here as openmp won't
			# build without a C library, and you can't build that w/o
			# already having a compiler...
			if ! is_crosscompile || \
			   $(tc-getCPP ${CTARGET}) -E - <<<"#include <pthread.h>" >& /dev/null
			then
				confgcc+=( $(use_enable openmp libgomp) )
			else
				# Force disable as the configure script can be dumb bug #359855
				confgcc+=( --disable-libgomp )
			fi
		else
			# For gcc variants where we don't want openmp (e.g. kgcc)
			confgcc+=( --disable-libgomp )
		fi
	fi

	if tc_version_is_at_least 4.0 ; then
		if _tc_use_if_iuse libssp ; then
			confgcc+=( --enable-libssp )
		else
			if hardened_gcc_is_stable ssp; then
				export gcc_cv_libc_provides_ssp=yes
			fi
			if _tc_use_if_iuse ssp; then
				# On some targets USE="ssp -libssp" is an invalid
				# configuration as the target libc does not provide
				# stack_chk_* functions. Do not disable libssp there.
				case ${CTARGET} in
					mingw*|*-mingw*) ewarn "Not disabling libssp" ;;
					*) confgcc+=( --disable-libssp ) ;;
				esac
			else
				confgcc+=( --disable-libssp )
			fi
		fi
	fi

	if in_iuse ada ; then
		confgcc+=( --disable-libada )
	fi

	if in_iuse cet ; then
		confgcc+=( $(use_enable cet) )
	fi

	if in_iuse cilk ; then
		confgcc+=( $(use_enable cilk libcilkrts) )
	fi

	if in_iuse mpx ; then
		confgcc+=( $(use_enable mpx libmpx) )
	fi

	if in_iuse systemtap ; then
		confgcc+=( $(use_enable systemtap) )
	fi

	if in_iuse valgrind ; then
		confgcc+=( $(use_enable valgrind valgrind-annotations) )
	fi

	if in_iuse vtv ; then
		confgcc+=(
			$(use_enable vtv vtable-verify)
			# See Note [implicitly enabled flags]
			$(usex vtv '' --disable-libvtv)
		)
	fi

	if in_iuse zstd ; then
		confgcc+=( $(use_with zstd) )
	fi

	# newer gcc's come with libquadmath, but only fortran uses
	# it, so auto punt it when we don't care
	if tc_version_is_at_least 4.6 && ! is_fortran ; then
		confgcc+=( --disable-libquadmath )
	fi

	# This only controls whether the compiler *supports* LTO, not whether
	# it's *built using* LTO. Hence we do it without a USE flag.
	if is_djgpp ; then
		if tc_version_is_at_least 4.8 ; then
			confgcc+=( --enable-lto )
		fi
	elif tc_version_is_at_least 4.6 ; then
		confgcc+=( --enable-lto )
	elif tc_version_is_at_least 4.5 ; then
		confgcc+=( --disable-lto )
	fi

	# graphite was added in 4.4 but we only support it in 6.5+ due to external
	# library issues. bug #448024, bug #701270
	if tc_version_is_at_least 6.5 && in_iuse graphite ; then
		confgcc+=( $(use_with graphite isl) )
		use graphite && confgcc+=( --disable-isl-version-check )
	elif tc_version_is_at_least 5.0 ; then
		confgcc+=( --without-isl )
	elif tc_version_is_at_least 4.8 ; then
		confgcc+=( --without-cloog )
	elif tc_version_is_at_least 4.4 ; then
		confgcc+=( --without-{cloog,ppl} )
	fi

	if tc_version_is_at_least 4.8; then
		if in_iuse sanitize ; then
			# See Note [implicitly enabled flags]
			confgcc+=( $(usex sanitize '' --disable-libsanitizer) )
		else
			confgcc+=( --disable-libsanitizer )
		fi
	fi

	if tc_version_is_at_least 6.0 && in_iuse pie ; then
		confgcc+=( $(use_enable pie default-pie) )
	fi

	if tc_version_is_at_least 6.0 && in_iuse ssp ; then
		confgcc+=(
			# This defaults to -fstack-protector-strong.
			$(use_enable ssp default-ssp)
		)
	fi

	# Disable gcc info regeneration -- it ships with generated info pages
	# already.  Our custom version/urls/etc... trigger it. bug #464008
	export gcc_cv_prog_makeinfo_modern=no

	# Do not let the X detection get in our way.  We know things can be found
	# via system paths, so no need to hardcode things that'll break multilib.
	# Older gcc versions will detect ac_x_libraries=/usr/lib64 which ends up
	# killing the 32bit builds which want /usr/lib.
	export ac_cv_have_x='have_x=yes ac_x_includes= ac_x_libraries='

	confgcc+=( "$@" ${EXTRA_ECONF} )

	if [[ -n ${build_config_targets} ]] ; then
		# ./configure --with-build-config='bootstrap-lto bootstrap-cet'
		confgcc+=( --with-build-config="${build_config_targets[*]}" )
	fi

	# Nothing wrong with a good dose of verbosity
	echo
	einfo "PREFIX:          ${PREFIX}"
	einfo "BINPATH:         ${BINPATH}"
	einfo "LIBPATH:         ${LIBPATH}"
	einfo "DATAPATH:        ${DATAPATH}"
	einfo "STDCXX_INCDIR:   ${STDCXX_INCDIR}"
	einfo "Languages:       ${GCC_LANG}"
	echo

	# Build in a separate build tree
	mkdir -p "${WORKDIR}"/build || die
	pushd "${WORKDIR}"/build > /dev/null || die

	# ...and now to do the actual configuration
	addwrite /dev/zero

	local gcc_shell="${BROOT}"/bin/bash
	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash for them.
	if tc_version_is_at_least 11.2 ; then
		gcc_shell="${BROOT}"/bin/sh
	fi

	if is_jit ; then
		einfo "Configuring JIT gcc"

		mkdir -p "${WORKDIR}"/build-jit || die
		pushd "${WORKDIR}"/build-jit > /dev/null || die
		CONFIG_SHELL="${gcc_shell}" edo "${gcc_shell}" "${S}"/configure \
				"${confgcc[@]}" \
				--disable-libada \
				--disable-libsanitizer \
				--disable-libvtv \
				--disable-libgomp \
				--disable-libquadmath \
				--disable-libatomic \
				--disable-lto \
				--disable-bootstrap \
				--enable-host-shared \
				--enable-languages=jit
		popd > /dev/null || die
	fi

	CONFIG_SHELL="${gcc_shell}" edo "${gcc_shell}" "${S}"/configure "${confgcc[@]}"

	# Return to whatever directory we were in before
	popd > /dev/null || die
}

gcc_do_filter_flags() {
	# Allow users to explicitly avoid flag sanitization via
	# USE=custom-cflags.
	if ! _tc_use_if_iuse custom-cflags; then
		# Over-zealous CFLAGS can often cause problems.  What may work for one
		# person may not work for another.  To avoid a large influx of bugs
		# relating to failed builds, we strip most CFLAGS out to ensure as few
		# problems as possible.
		strip-flags

		# Lock gcc at -O2; we want to be conservative here.
		filter-flags '-O?'
		append-flags -O2
	fi

	# Avoid shooting self in foot
	filter-flags '-mabi*' -m31 -m32 -m64

	# bug #490738
	filter-flags -frecord-gcc-switches
	# bug #506202
	filter-flags -mno-rtm -mno-htm

	filter-flags '-fsanitize=*'
	if tc_version_is_between 3.2 3.4 ; then
		# XXX: this is so outdated it's barely useful, but it don't hurt...
		replace-cpu-flags G3 750
		replace-cpu-flags G4 7400
		replace-cpu-flags G5 7400

		# XXX: should add a sed or something to query all supported flags
		#      from the gcc source and trim everything else ...
		filter-flags -f{no-,}unit-at-a-time -f{no-,}web -mno-tls-direct-seg-refs
		filter-flags -f{no-,}stack-protector{,-all}
		filter-flags -fvisibility-inlines-hidden -fvisibility=hidden
		# and warning options
		filter-flags -Wextra -Wstack-protector
	fi
	if ! tc_version_is_at_least 4.1 ; then
		filter-flags -fdiagnostics-show-option
		filter-flags -Wstack-protector
	fi

	if tc_version_is_between 6 8 ; then
		# -mstackrealign triggers crashes in exception throwing
		# at least on ada: bug #688580
		# The reason is unknown. Drop the flag for now.
		filter-flags -mstackrealign
	fi

	if tc_version_is_at_least 3.4 ; then
		case $(tc-arch) in
			amd64|x86)
				filter-flags '-mcpu=*'

				tc_version_is_between 4.4 4.5 && append-flags -mno-avx # 357287

				if tc_version_is_between 4.6 4.7 ; then
					# https://bugs.gentoo.org/411333
					# https://bugs.gentoo.org/466454
					replace-cpu-flags c3-2 pentium2 pentium3 pentium3m pentium-m i686
				fi
				;;
			alpha)
				# https://bugs.gentoo.org/454426
				append-ldflags -Wl,--no-relax
				;;
			*-macos)
				# http://gcc.gnu.org/PR25127
				tc_version_is_between 4.0 4.2 && \
					filter-flags '-mcpu=*' '-march=*' '-mtune=*'
				;;
		esac
	fi

	strip-unsupported-flags

	if [[ $(tc-arch) == amd64 || $(tc-arch) == x86 ]] && ! tc_version_is_at_least 2.8 ${bver} ; then
		filter-flags '-mtune=*' '-march=*' '-mcpu=*' '-m*' '-mno-*'
		tc_version_is_at_least 2.0 ${bver} && append-flags -m486
		return 0
	fi

	# These are set here so we have something sane at configure time
	if is_crosscompile ; then
		# Set this to something sane for both native and target
		CFLAGS="-O2 -pipe"
		FFLAGS=${CFLAGS}
		FCFLAGS=${CFLAGS}

		# "hppa2.0-unknown-linux-gnu" -> hppa2_0_unknown_linux_gnu
		local VAR="CFLAGS_"${CTARGET//[-.]/_}
		CXXFLAGS=${!VAR-${CFLAGS}}
	fi

	export GCJFLAGS=${GCJFLAGS:-${CFLAGS}}
}

setup_minispecs_gcc_build_specs() {
	# Setup the "build.specs" file for gcc 4.3 to use when building.
	if hardened_gcc_works pie ; then
		cat "${WORKDIR}"/specs/pie.specs >> "${WORKDIR}"/build.specs
	fi

	if hardened_gcc_works ssp ; then
		for s in ssp sspall ; do
			cat "${WORKDIR}"/specs/${s}.specs >> "${WORKDIR}"/build.specs
		done
	fi

	for s in nostrict znow ; do
		cat "${WORKDIR}"/specs/${s}.specs >> "${WORKDIR}"/build.specs
	done

	export GCC_SPECS="${WORKDIR}"/build.specs
}

gcc-multilib-configure() {
	if ! is_multilib ; then
		if tc_version_is_at_least 2.7 ; then
			confgcc+=( --disable-multilib )
		fi
		# Fun times: if we are building for a target that has multiple
		# possible ABI formats, and the user has told us to pick one
		# that isn't the default, then not specifying it via the list
		# below will break that on us.
	else
		confgcc+=( --enable-multilib )
	fi

	# Translate our notion of multilibs into gcc's
	local abi list
	for abi in $(get_all_abis TARGET) ; do
		local l=$(gcc-abi-map ${abi})
		[[ -n ${l} ]] && list+=",${l}"
	done

	if [[ -n ${list} ]] ; then
		case ${CTARGET} in
			x86_64*)
				tc_version_is_at_least 4.7 && confgcc+=( --with-multilib-list=${list:1} )
			;;
		esac
	fi
}

gcc-abi-map() {
	# Convert the ABI name we use in Gentoo to what gcc uses
	local map=()
	case ${CTARGET} in
		mips*)
			map=("o32 32" "n32 n32" "n64 64")
			;;
		riscv*)
			map=("lp64d lp64d" "lp64 lp64" "ilp32d ilp32d" "ilp32 ilp32")
			;;
		x86_64*)
			map=("amd64 m64" "x86 m32" "x32 mx32")
			;;
	esac

	local m
	for m in "${map[@]}" ; do
		l=( ${m} )
		[[ $1 == ${l[0]} ]] && echo ${l[1]} && break
	done
}

#----> src_compile <----

toolchain_src_compile() {
	tc_version_is_at_least 2.9 && touch "${S}"/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	[[ ! -x /usr/bin/perl ]] \
		&& find "${WORKDIR}"/build -name '*.[17]' -exec touch {} +

	# To compile ada library standard files special compiler options are passed
	# via ADAFLAGS in the Makefile.
	# Unset ADAFLAGS as setting this override the options
	unset ADAFLAGS

	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash for them.
	# This needs to be set for compile as well, as it's used in libtool
	# generation, which will break install otherwise (at least in 3.3.6): bug #664486
	local gcc_shell="${BROOT}"/bin/bash
	if tc_version_is_at_least 11.2 ; then
		gcc_shell="${BROOT}"/bin/sh
	fi

	CONFIG_SHELL="${gcc_shell}" \
		gcc_do_make ${GCC_MAKE_TARGET}
}

gcc_do_make() {
	# This function accepts one optional argument, the make target to be used.
	# If omitted, gcc_do_make will try to guess whether it should use all,
	# or bootstrap-lean depending on CTARGET and arch.
	# An example of how to use this function:
	#
	#	gcc_do_make all-target-libstdc++-v3

	[[ -n ${1} ]] && GCC_MAKE_TARGET=${1}

	# default target
	if is_crosscompile || tc-is-cross-compiler ; then
		# 3 stage bootstrapping doesn't quite work when you can't run the
		# resulting binaries natively
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}
	else
		if [[ ${EXTRA_ECONF} == *--disable-bootstrap* ]] ; then
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}

			ewarn "Disabling bootstrapping. ONLY recommended for development."
			ewarn "This is NOT a safe configuration for endusers!"
			ewarn "This compiler may not be safe or reliable for production use!"
		elif tc_version_is_at_least 3.3 && _tc_use_if_iuse pgo; then
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-profiledbootstrap}
		elif tc_version_is_at_least 4.1 ; then
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap-lean}
		else
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap}
		fi
	fi

	# Older versions of GCC could not do profiledbootstrap in parallel due to
	# collisions with profiling info.
	if [[ ${GCC_MAKE_TARGET} == "profiledbootstrap" ]] ; then
		! tc_version_is_at_least 4.6 && export MAKEOPTS="${MAKEOPTS} -j1"
	fi

	if [[ ${GCC_MAKE_TARGET} == "all" ]] ; then
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"${CFLAGS}"}
	elif [[ ${GCC_BRANCH_VER} == "4.9" && $(tc-arch) == "ppc64" ]] ; then
		STAGE1_CFLAGS=
	elif [[ ${GCC_BRANCH_VER} == "3.0" ]] ; then
		STAGE1_CFLAGS=
	else
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"${CFLAGS}"}
	fi

	if is_crosscompile; then
		# In 3.4, BOOT_CFLAGS is never used on a crosscompile...
		# but I'll leave this in anyways as someone might have had
		# some reason for putting it in here... --eradicator
		BOOT_CFLAGS=${BOOT_CFLAGS-"-O2"}
	else
		# we only want to use the system's CFLAGS if not building a
		# cross-compiler.
		BOOT_CFLAGS=${BOOT_CFLAGS-"${CFLAGS}"}
	fi

	if is_jit ; then
		# TODO: docs for jit?
		pushd "${WORKDIR}"/build-jit > /dev/null || die

		einfo "Building JIT"
		emake \
			LDFLAGS="${LDFLAGS}" \
			STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
			LIBPATH="${LIBPATH}" \
			BOOT_CFLAGS="${BOOT_CFLAGS}"
		popd > /dev/null || die
        fi

	einfo "Compiling ${PN} (${GCC_MAKE_TARGET})..."

	pushd "${WORKDIR}"/build >/dev/null || die

	if tc_version_is_at_least 2.9 ; then
		emake \
			LDFLAGS="${LDFLAGS}" \
			STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
			LIBPATH="${LIBPATH}" \
			BOOT_CFLAGS="${BOOT_CFLAGS}" \
			${GCC_MAKE_TARGET} \
			|| die "emake failed with ${GCC_MAKE_TARGET}"
	else
		LANGUAGES="c"
		tc_version_is_at_least 2.8 && LANGUAGES+=" gcov"
		_tc_use_if_iuse cxx && LANGUAGES+=" c++"
		_tc_use_if_iuse objc && LANGUAGES+=" objective-c"
		emake \
			CC="${CC}" \
			CXX="${CXX}" \
			LANGUAGES="${LANGUAGES}" \
			LDFLAGS="${LDFLAGS}" \
			STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
			LIBPATH="${LIBPATH}" \
			${GCC_MAKE_TARGET} \
			|| die "emake failed with ${GCC_MAKE_TARGET}"
	fi

	if is_ada; then
		# Without these links, it is not getting the good compiler
		# TODO: Need to check why
		ln -s gcc ../build/prev-gcc || die
		ln -s ${CHOST} ../build/prev-${CHOST} || die

		# Building standard ada library
		emake -C gcc gnatlib-shared
		# Building gnat toold
		emake -C gcc gnattools
	fi

	if ! is_crosscompile && _tc_use_if_iuse cxx && _tc_use_if_iuse doc ; then
		if type -p doxygen > /dev/null ; then
			if tc_version_is_at_least 4.3 ; then
				cd "${CTARGET}"/libstdc++-v3/doc
				emake doc-man-doxygen
			elif tc_version_is_at_least 3.0 ; then
				cd "${CTARGET}"/libstdc++-v3
				emake doxygen-man
			fi
			# Clean bogus manpages. bug #113902
			find -name '*_build_*' -delete

			# Blow away generated directory references. Newer versions of gcc
			# have gotten better at this, but not perfect. This is easier than
			# backporting all of the various doxygen patches. bug #486754
			find -name '*_.3' -exec grep -l ' Directory Reference ' {} + | \
				xargs rm -f
		else
			ewarn "Skipping libstdc++ manpage generation since you don't have doxygen installed"
		fi
	fi

	popd >/dev/null || die
}

#---->> src_test <<----

toolchain_src_test() {
	cd "${WORKDIR}"/build || die

	# From opensuse's spec file:
	# "asan needs a whole shadow address space"
	ulimit -v unlimited

	# 'asan' wants to be preloaded first, so does 'sandbox'.
	# To make asan tests work disable sandbox for all of test suite.
	# 'backtrace' tests also does not like 'libsandbox.so' presence.
	SANDBOX_ON=0 LD_PRELOAD= emake -k check

	einfo "Testing complete! Review the following output to check for success or failure."
	einfo "Please ignore any 'mail' lines in the summary output below (no mail is sent)."
	einfo "Summary:"
	"${S}"/contrib/test_summary
}

#---->> src_install <<----

toolchain_src_install() {
	cd "${WORKDIR}"/build || die

	# Don't allow symlinks in private gcc include dir as this can break the build
	find gcc/include*/ -type l -delete

	# Copy over the info pages.  We disabled their generation earlier, but the
	# build system only expects to install out of the build dir, not the source. bug #464008
	mkdir -p gcc/doc
	local x=
	for x in "${S}"/gcc/doc/*.info* ; do
		if [[ -f ${x} ]] ; then
			cp "${x}" gcc/doc/ || die
		fi
	done

	# We remove the generated fixincludes, as they can cause things to break
	# (ncurses, openssl, etc).  We do not prevent them from being built, as
	# in the following commit which we revert:
	# https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/toolchain.eclass?r1=1.647&r2=1.648
	# This is because bsd userland needs fixedincludes to build gcc, while
	# linux does not.  Both can dispose of them afterwards.
	while read x ; do
		grep -q 'It has been auto-edited by fixincludes from' "${x}" \
			&& rm -f "${x}"
	done < <(find gcc/include*/ -name '*.h')

	# Do the 'make install' from the build directory
	if tc_version_is_at_least 4.5 ; then
		S="${WORKDIR}"/build emake DESTDIR="${D}" install || die
	elif tc_version_is_at_least 2.9 ; then
		S="${WORKDIR}"/build emake -j1 DESTDIR="${D}" install || die
	else
		S="${WORKDIR}"/build emake CC="${CC}" CXX="${CXX}" LANGUAGES="${LANGUAGES}" -j1 DESTDIR="${D}" install || die
	fi

	if is_jit ; then
		# See https://gcc.gnu.org/onlinedocs/gcc-11.3.0/jit/internals/index.html#packaging-notes
		# and bug #843341.
		#
		# Both of the non-JIT and JIT builds  are configured to install to $(DESTDIR)
		# Install the configuration with --enable-host-shared first
		# *then* the one without, so that the faster build
		# of "cc1" et al overwrites the slower build.
		#
		# Do the 'make install' from the build directory
		pushd "${WORKDIR}"/build-jit > /dev/null || die
		S="${WORKDIR}"/build-jit emake DESTDIR="${D}" install

		# Punt some tools which are really only useful while building gcc
		find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \;
		# This one comes with binutils
		find "${ED}" -name libiberty.a -delete

		# Move the libraries to the proper location
		gcc_movelibs

		popd > /dev/null || die
	fi

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \;
	# This one comes with binutils
	find "${ED}" -name libiberty.a -delete

	# Move the libraries to the proper location
	gcc_movelibs

	# Basic sanity check
	if ! is_crosscompile && tc_version_is_at_least 2.8; then
		local EXEEXT
		eval $(grep ^EXEEXT= "${WORKDIR}"/build/gcc/config.log)
		[[ -r ${D}${BINPATH}/gcc${EXEEXT} ]] || die "gcc not found in ${ED}"
	fi

	dodir /etc/env.d/gcc
	create_gcc_env_entry
	create_revdep_rebuild_entry

	# Setup the gcc_env_entry for hardened gcc 4 with minispecs
	want_minispecs && copy_minispecs_gcc_specs

	dodir /usr/bin
	cd "${D}"${BINPATH} || die
	# Ugh: we really need to auto-detect this list.
	#      It's constantly out of date.
	for x in cpp gcc g++ c++ gcov g77 gfortran gccgo gnat* ; do
		# For some reason, g77 gets made instead of ${CTARGET}-g77...
		# this should take care of that
		if [[ -f ${x} ]] ; then
			# In case they're hardlinks, clear out the target first
			# otherwise the mv below will complain.
			rm -f ${CTARGET}-${x}
			mv ${x} ${CTARGET}-${x}
		fi

		if [[ -f ${CTARGET}-${x} ]] ; then
			if ! is_crosscompile ; then
				ln -sf ${CTARGET}-${x} ${x}
				dosym ${BINPATH}/${CTARGET}-${x} \
					/usr/bin/${x}-${GCC_CONFIG_VER}
			fi
			# Create versioned symlinks
			dosym ${BINPATH}/${CTARGET}-${x} \
				/usr/bin/${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi

		if [[ -f ${CTARGET}-${x}-${GCC_CONFIG_VER} ]] ; then
			rm -f ${CTARGET}-${x}-${GCC_CONFIG_VER}
			ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi
	done

	# When gcc builds a crosscompiler it does not install unprefixed tools.
	# When cross-building gcc does install native tools.
	if ! is_crosscompile; then
		# Rename the main go binaries as we don't want to clobber dev-lang/go
		# when gcc-config runs. bug #567806
		if tc_version_is_at_least 5 && is_go ; then
			for x in go gofmt; do
				mv ${x} ${x}-${GCCMAJOR} || die
			done
		fi
	fi

	if is_crosscompile; then
		if [[ ${CTARGET} == 'avr' ]] ; then
			find ${D}${LIBPATH} | grep "\.a"| xargs ${CTARGET}-strip -d
		else
			${CTARGET}-strip -d ${D}${LIBPATH}/{*.a,*.o,32/*.a,32/*.o,n32/*.o,n32/*.a}
			${CTARGET}-strip -s ${D}${LIBPATH}/{*.so*,32/*.so*,n32/*.so*,*.dll,32/*.dll}
		fi
		${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .GCC.command.line -R .note.gnu.gold-version ${D}${BINPATH}/*
		${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .GCC.command.line -R .note.gnu.gold-version ${D}${HOSTLIBPATH}/*
		${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .GCC.command.line -R .note.gnu.gold-version ${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/{*,plugin/*}
		${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .GCC.command.line -R .note.gnu.gold-version ${D}${LIBPATH}/plugin/*.so*
	fi

	cd "${S}" || die
	if is_crosscompile; then
		rm -rf "${ED}"/usr/share/{man,info}
		rm -rf "${D}"${DATAPATH}/{man,info}
	else
		if tc_version_is_at_least 3.0 ; then
			local cxx_mandir=$(find "${WORKDIR}/build/${CTARGET}/libstdc++-v3" -name man)
			if [[ -d ${cxx_mandir} ]] ; then
				cp -r "${cxx_mandir}"/man? "${D}${DATAPATH}"/man/
			fi
		fi
	fi

	# Portage regenerates 'dir' files on its own: bug #672408
	# Drop 'dir' files to avoid collisions.
	if [[ -f "${D}${DATAPATH}"/info/dir ]]; then
		einfo "Deleting '${D}${DATAPATH}/info/dir'"
		rm "${D}${DATAPATH}"/info/dir || die
	fi

	# Prune empty dirs left behind
	find "${ED}" -depth -type d -delete 2>/dev/null

	# libstdc++.la: Delete as it doesn't add anything useful: g++ itself
	# handles linkage correctly in the dynamic & static case.  It also just
	# causes us pain: any C++ progs/libs linking with libtool will gain a
	# reference to the full libstdc++.la file which is gcc version specific.
	# libstdc++fs.la: It doesn't link against anything useful.
	# libsupc++.la: This has no dependencies.
	# libcc1.la: There is no static library, only dynamic.
	# libcc1plugin.la: Same as above, and it's loaded via dlopen.
	# libcp1plugin.la: Same as above, and it's loaded via dlopen.
	# libgomp.la: gcc itself handles linkage (libgomp.spec).
	# libgomp-plugin-*.la: Same as above, and it's an internal plugin only
	# loaded via dlopen.
	# libgfortran.la: gfortran itself handles linkage correctly in the
	# dynamic & static case (libgfortran.spec). bug #573302
	# libgfortranbegin.la: Same as above, and it's an internal lib.
	# libmpx.la: gcc itself handles linkage correctly (libmpx.spec).
	# libmpxwrappers.la: See above.
	# libitm.la: gcc itself handles linkage correctly (libitm.spec).
	# libvtv.la: gcc itself handles linkage correctly.
	# lib*san.la: Sanitizer linkage is handled internally by gcc, and they
	# do not support static linking. bug #487550, bug #546700
	find "${D}${LIBPATH}" \
		'(' \
			-name libstdc++.la -o \
			-name libstdc++fs.la -o \
			-name libsupc++.la -o \
			-name libcc1.la -o \
			-name libcc1plugin.la -o \
			-name libcp1plugin.la -o \
			-name 'libgomp.la' -o \
			-name 'libgomp-plugin-*.la' -o \
			-name libgfortran.la -o \
			-name libgfortranbegin.la -o \
			-name libgf95begin.la -o \
			-name libmpx.la -o \
			-name libmpxwrappers.la -o \
			-name libitm.la -o \
			-name libvtv.la -o \
			-name libobjc.la -o \
			-name libatomic.la -o \
			-name libcaf_single.la -o \
			-name libquadmath.la -o \
			-name libg2c.la -o \
			-name libf2c.la -o \
			-name libgo.la -o \
			-name 'lib*san.la' \
		')' -type f -delete

	rm -rfv "${D}${BINPATH}"/{c++filt,gccbug,protoize,unprotoize}

	# Use gid of 0 because some stupid ports don't have
	# the group 'root' set to gid 0.  Send to /dev/null
	# for people who are testing as non-root.
	chown -R 0:0 "${D}${LIBPATH}" 2>/dev/null

	# Installing gdb pretty-printers into gdb-specific location.
	local py gdbdir=/usr/share/gdb/auto-load${LIBPATH}
	pushd "${D}${LIBPATH}" >/dev/null
	for py in $(find . -name '*-gdb.py') ; do
		local multidir=${py%/*}

		insinto "${gdbdir}/${multidir}"
		# bug #348128
		sed -i "/^libdir =/s:=.*:= '${LIBPATH}/${multidir}':" "${py}" || die
		doins "${py}"

		rm "${py}" || die
	done
	popd >/dev/null

	# Don't scan .gox files for executable stacks - false positives
	export QA_EXECSTACK="usr/lib*/go/*/*.gox"
	export QA_WX_LOAD="usr/lib*/go/*/*.gox"

	# Disable RANDMMAP so PCH works, bug #301299
	if tc_version_is_at_least 4.3 ; then
		pax-mark -r "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/cc1"
		pax-mark -r "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/cc1plus"
	fi
}

# Move around the libs to the right location.  For some reason,
# when installing gcc, it dumps internal libraries into /usr/lib
# instead of the private gcc lib path
gcc_movelibs() {
	# older versions of gcc did not support --print-multi-os-directory
	tc_version_is_at_least 3.1 || return 0

	# For non-target libs which are for CHOST and not CTARGET, we want to
	# move them to the compiler-specific CHOST internal dir.  This is stuff
	# that you want to link against when building tools rather than building
	# code to run on the target.
	if tc_version_is_at_least 5 && is_crosscompile ; then
		dodir "${HOSTLIBPATH#${EPREFIX}}"
		mv "${ED}"/usr/$(get_libdir)/libcc1* "${D}${HOSTLIBPATH}" || die
	fi

	# libgccjit gets installed to /usr/lib, not /usr/$(get_libdir). Probably
	# due to a bug in gcc build system.
	if [[ ${PWD} == "${WORKDIR}"/build-jit ]] && is_jit ; then
		dodir "${LIBPATH#${EPREFIX}}"
		mv "${ED}"/usr/lib/libgccjit* "${D}${LIBPATH}" || die
	fi

	# For all the libs that are built for CTARGET, move them into the
	# compiler-specific CTARGET internal dir.
	local x multiarg removedirs=""
	for multiarg in $($(XGCC) -print-multi-lib) ; do
		multiarg=${multiarg#*;}
		multiarg=${multiarg//@/ -}

		local OS_MULTIDIR=$($(XGCC) ${multiarg} --print-multi-os-directory)
		local MULTIDIR=$($(XGCC) ${multiarg} --print-multi-directory)
		local TODIR="${D}${LIBPATH}"/${MULTIDIR}
		local FROMDIR=

		[[ -d ${TODIR} ]] || mkdir -p ${TODIR}

		for FROMDIR in \
			"${LIBPATH}"/${OS_MULTIDIR} \
			"${LIBPATH}"/../${MULTIDIR} \
			"${PREFIX}"/lib/${OS_MULTIDIR} \
			"${PREFIX}"/${CTARGET}/lib/${OS_MULTIDIR}
		do
			removedirs="${removedirs} ${FROMDIR}"
			FROMDIR=${D}${FROMDIR}
			if [[ ${FROMDIR} != "${TODIR}" && -d ${FROMDIR} ]] ; then
				local files=$(find "${FROMDIR}" -maxdepth 1 ! -type d 2>/dev/null)
				if [[ -n ${files} ]] ; then
					mv ${files} "${TODIR}" || die
				fi
			fi
		done
		fix_libtool_libdir_paths "${LIBPATH}/${MULTIDIR}"
	done

	# We remove directories separately to avoid this case:
	#	mv SRC/lib/../lib/*.o DEST
	#	rmdir SRC/lib/../lib/
	#	mv SRC/lib/../lib32/*.o DEST  # Bork
	for FROMDIR in ${removedirs} ; do
		rmdir "${D}"${FROMDIR} >& /dev/null
	done

	find -depth "${ED}" -type d -exec rmdir {} + >& /dev/null

	if is_mingw || is_cygwin ; then
		mv "${ED}"/usr/${CTARGET}/bin/*.dll "${ED}${LIBPATH}"
		mv "${ED}${BINPATH}"/*.dll "${ED}${LIBPATH}"
	fi
}

# Make sure the libtool archives have libdir set to where they actually
# -are-, and not where they -used- to be. Also, any dependencies we have
# on our own .la files need to be updated.
fix_libtool_libdir_paths() {
	local libpath="$1"

	pushd "${D}" >/dev/null || die

	pushd "./${libpath}" >/dev/null || die
	local dir="${PWD#${D%/}}"
	local allarchives=$(echo *.la)
	allarchives="\(${allarchives// /\\|}\)"
	popd >/dev/null || die

	# The libdir might not have any .la files. bug #548782
	find "./${dir}" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^libdir=/s:=.*:='${dir}':" {} + || die
	# Would be nice to combine these, but -maxdepth can not be specified
	# on sub-expressions.
	find "./${PREFIX}"/lib* -maxdepth 3 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die
	find "./${dir}/" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die

	popd >/dev/null || die
}

create_gcc_env_entry() {
	dodir /etc/env.d/gcc

	local gcc_envd_base="/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}"
	local gcc_specs_file
	local gcc_envd_file="${ED}${gcc_envd_base}"
	if [[ -z $1 ]] ; then
		# I'm leaving the following commented out to remind me that it
		# was an insanely -bad- idea. Stuff broke. GCC_SPECS isnt unset
		# on chroot or in non-toolchain.eclass gcc ebuilds!
		#gcc_specs_file="${LIBPATH}/specs"
		gcc_specs_file=""
	else
		gcc_envd_file+="-$1"
		gcc_specs_file="${LIBPATH}/$1.specs"
	fi

	# We want to list the default ABI's LIBPATH first so libtool
	# searches that directory first.  This is a temporary
	# workaround for libtool being stupid and using .la's from
	# conflicting ABIs by using the first one in the search path
	local ldpaths mosdirs
	if tc_version_is_at_least 3.1 ; then
		local mdir mosdir abi ldpath
		for abi in $(get_all_abis TARGET) ; do
			mdir=$($(XGCC) $(get_abi_CFLAGS ${abi}) --print-multi-directory)
			ldpath=${LIBPATH}
			[[ ${mdir} != "." ]] && ldpath+="/${mdir}"
			ldpaths="${ldpath}${ldpaths:+:${ldpaths}}"

			mosdir=$($(XGCC) $(get_abi_CFLAGS ${abi}) -print-multi-os-directory)
			mosdirs="${mosdir}${mosdirs:+:${mosdirs}}"
		done
	else
		# Older gcc's didn't do multilib, so logic is simple.
		ldpaths=${LIBPATH}
	fi

	cat <<-EOF > ${gcc_envd_file}
	GCC_PATH="${BINPATH}"
	LDPATH="${ldpaths}"
	MANPATH="${DATAPATH}/man"
	INFOPATH="${DATAPATH}/info"
	STDCXX_INCDIR="${STDCXX_INCDIR##*/}"
	CTARGET="${CTARGET}"
	GCC_SPECS="${gcc_specs_file}"
	MULTIOSDIRS="${mosdirs}"
	EOF
}

create_revdep_rebuild_entry() {
	local revdep_rebuild_base="/etc/revdep-rebuild/05cross-${CTARGET}-${GCC_CONFIG_VER}"
	local revdep_rebuild_file="${ED}${revdep_rebuild_base}"

	is_crosscompile || return 0

	dodir /etc/revdep-rebuild
	cat <<-EOF > "${revdep_rebuild_file}"
	# Generated by ${CATEGORY}/${PF}
	# Ignore libraries built for ${CTARGET}, https://bugs.gentoo.org/692844.
	SEARCH_DIRS_MASK="${LIBPATH}"
	EOF
}

copy_minispecs_gcc_specs() {
	# On gcc 6, we don't need minispecs
	if tc_version_is_at_least 6.0 ; then
		return 0
	fi

	# Setup the hardenedno* specs files and the vanilla specs file.
	if hardened_gcc_works ; then
		create_gcc_env_entry hardenednopiessp
	fi
	if hardened_gcc_works pie ; then
		create_gcc_env_entry hardenednopie
	fi
	if hardened_gcc_works ssp ; then
		create_gcc_env_entry hardenednossp
	fi
	create_gcc_env_entry vanilla
	insinto ${LIBPATH#${EPREFIX}}
	doins "${WORKDIR}"/specs/*.specs || die "failed to install specs"
	# Build system specs file which, if it exists, must be a complete set of
	# specs as it completely and unconditionally overrides the builtin specs.
	if ! tc_version_is_at_least 4.4 ; then
		$(XGCC) -dumpspecs > "${WORKDIR}"/specs/specs
		cat "${WORKDIR}"/build.specs >> "${WORKDIR}"/specs/specs
		doins "${WORKDIR}"/specs/specs || die "failed to install the specs file"
	fi
}

#---->> pkg_post* <<----

toolchain_pkg_postinst() {
	is_crosscompile && do_gcc_config
	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	if ! is_crosscompile && [[ ${PN} != "kgcc64" ]] ; then
		# gcc stopped installing .la files fixer in June 2020.
		# Cleaning can be removed in June 2022.
		rm -f "${EROOT}"/sbin/fix_libtool_files.sh
		rm -f "${EROOT}"/usr/sbin/fix_libtool_files.sh
		rm -f "${EROOT}"/usr/share/gcc-data/fixlafiles.awk
	fi
}

toolchain_pkg_postrm() {
	is_crosscompile && do_gcc_config
	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi

	# Clean up the cruft left behind by cross-compilers
	if is_crosscompile ; then
		if [[ -z $(ls "${EROOT}"/etc/env.d/gcc/${CTARGET}* 2>/dev/null) ]] ; then
			einfo "Removing last cross-compiler instance. Deleting dangling symlinks."
			rm -f "${EROOT}"/etc/env.d/gcc/config-${CTARGET}
			rm -f "${EROOT}"/etc/env.d/??gcc-${CTARGET}
			rm -f "${EROOT}"/usr/bin/${CTARGET}-{gcc,{g,c}++}{,32,64}
		fi
		return 0
	fi

	# gcc stopped installing .la files fixer in June 2020.
	# Cleaning can be removed in June 2022.
	rm -f "${EROOT}"/sbin/fix_libtool_files.sh
	rm -f "${EROOT}"/usr/share/gcc-data/fixlafiles.awk
}

do_gcc_config() {
	if ! should_we_gcc_config ; then
		gcc-config --use-old --force
		return 0
	fi

	local current_gcc_config target

	current_gcc_config=$(gcc-config -c ${CTARGET} 2>/dev/null)
	if [[ -n ${current_gcc_config} ]] ; then
		local current_specs use_specs
		# Figure out which specs-specific config is active
		current_specs=$(gcc-config -S ${current_gcc_config} | awk '{print $3}')
		[[ -n ${current_specs} ]] && use_specs=-${current_specs}

		if [[ -n ${use_specs} ]] && \
		   [[ ! -e ${EROOT}/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}${use_specs} ]]
		then
			ewarn "The currently selected specs-specific gcc config,"
			ewarn "${current_specs}, doesn't exist anymore. This is usually"
			ewarn "due to enabling/disabling hardened or switching to a version"
			ewarn "of gcc that doesnt create multiple specs files. The default"
			ewarn "config will be used, and the previous preference forgotten."
			use_specs=""
		fi

		target="${CTARGET}-${GCC_CONFIG_VER}${use_specs}"
	else
		# The curent target is invalid.  Attempt to switch to a valid one.
		# Blindly pick the latest version. bug #529608
		# TODO: Should update gcc-config to accept `-l ${CTARGET}` rather than
		# doing a partial grep like this.
		target=$(gcc-config -l 2>/dev/null | grep " ${CTARGET}-[0-9]" | tail -1 | awk '{print $2}')
	fi

	gcc-config "${target}"
}

should_we_gcc_config() {
	# if the current config is invalid, we definitely want a new one
	# Note: due to bash quirkiness, the following must not be 1 line
	local curr_config
	curr_config=$(gcc-config -c ${CTARGET} 2>&1) || return 0

	# If the previously selected config has the same major.minor (branch) as
	# the version we are installing, then it will probably be uninstalled
	# for being in the same SLOT, so make sure we run gcc-config.
	local curr_config_ver=$(gcc-config -S ${curr_config} | awk '{print $2}')

	local curr_branch_ver=$(ver_cut 1-2 ${curr_config_ver})

	if [[ ${curr_branch_ver} == ${GCC_BRANCH_VER} ]] ; then
		return 0
	else
		# If we're installing a genuinely different compiler version,
		# we should probably tell the user -how- to switch to the new
		# gcc version, since we're not going to do it for them.
		#
		# We don't want to switch from say gcc-3.3 to gcc-3.4 right in
		# the middle of an emerge operation (like an 'emerge -e world'
		# which could install multiple gcc versions).
		#
		# Only warn if we're installing a pkg as we might be called from
		# the pkg_{pre,post}rm steps.  #446830
		if [[ ${EBUILD_PHASE} == *"inst" ]] ; then
			einfo "The current gcc config appears valid, so it will not be"
			einfo "automatically switched for you.  If you would like to"
			einfo "switch to the newly installed gcc version, do the"
			einfo "following:"
			echo
			einfo "gcc-config ${CTARGET}-${GCC_CONFIG_VER}"
			einfo "source /etc/profile"
			echo
		fi
		return 1
	fi
}

#---->> support and misc functions <<----

# This is to make sure we don't accidentally try to enable support for a
# language that doesnt exist. GCC 3.4 supports f77, while 4.0 supports f95, etc.
#
# Also add a hook so special ebuilds (kgcc64) can control which languages
# exactly get enabled
gcc-lang-supported() {
	grep ^language=\"${1}\" "${S}"/gcc/*/config-lang.in > /dev/null || return 1
	[[ -z ${TOOLCHAIN_ALLOWED_LANGS} ]] && return 0
	has $1 ${TOOLCHAIN_ALLOWED_LANGS}
}

_tc_use_if_iuse() {
	in_iuse $1 && use $1
}

is_ada() {
	gcc-lang-supported ada || return 1
	_tc_use_if_iuse ada
}

is_cxx() {
	gcc-lang-supported 'c++' || return 1
	_tc_use_if_iuse cxx
}

is_d() {
	gcc-lang-supported d || return 1
	_tc_use_if_iuse d
}

is_f77() {
	gcc-lang-supported f77 || return 1
	_tc_use_if_iuse f77
}

is_f95() {
	gcc-lang-supported f95 || return 1
	_tc_use_if_iuse f95
}

is_fortran() {
	gcc-lang-supported fortran || return 1
	_tc_use_if_iuse fortran
}

is_go() {
	gcc-lang-supported go || return 1
	_tc_use_if_iuse cxx && _tc_use_if_iuse go
}

is_jit() {
	gcc-lang-supported jit || return 1

	# cross-compiler does not really support jit as it has
	# to generate code for a target. On targets like avr,
	# libgcclit.so can't link at all: bug #594572
	is_crosscompile && return 1

	_tc_use_if_iuse jit
}

is_multilib() {
	tc_version_is_at_least 3.1 || return 1
	_tc_use_if_iuse multilib
}

is_objc() {
	gcc-lang-supported objc || return 1
	_tc_use_if_iuse objc
}

is_objcxx() {
	gcc-lang-supported 'obj-c++' || return 1
	_tc_use_if_iuse cxx && _tc_use_if_iuse objc++
}

# Grab a variable from the build system (taken from linux-info.eclass)
get_make_var() {
	local var=$1 makefile=${2:-${WORKDIR}/build/Makefile}
	echo -e "e:\\n\\t@echo \$(${var})\\ninclude ${makefile}" | \
		r=${makefile%/*} emake --no-print-directory -s -f - 2>/dev/null
}

XGCC() { get_make_var GCC_FOR_TARGET ; }

# The gentoo pie-ssp patches allow for 3 configurations:
# 1) PIE+SSP by default
# 2) PIE by default
# 3) SSP by default
hardened_gcc_works() {
	if [[ $1 == "pie" ]] ; then
		# $gcc_cv_ld_pie is unreliable as it simply take the output of
		# `ld --help | grep -- -pie`, that reports the option in all cases, also if
		# the loader doesn't actually load the resulting executables.

		want_pie || return 1
		_tc_use_if_iuse nopie && return 1
		hardened_gcc_is_stable pie
		return $?
	elif [[ $1 == "ssp" ]] ; then
		[[ -n ${SPECS_VER} ]] || return 1
		_tc_use_if_iuse nossp && return 1
		hardened_gcc_is_stable ssp
		return $?
	else
		# laziness ;)
		hardened_gcc_works pie || return 1
		hardened_gcc_works ssp || return 1
		return 0
	fi
}

hardened_gcc_is_stable() {
	local tocheck
	if [[ $1 == "pie" ]] ; then
		tocheck=${PIE_GLIBC_STABLE}
	elif [[ $1 == "ssp" ]] ; then
		tocheck=${SSP_STABLE}
	else
		die "hardened_gcc_stable needs to be called with pie or ssp"
	fi

	has $(tc-arch) ${tocheck} && return 0
	return 1
}

want_minispecs() {
	# On gcc 6, we don't need minispecs
	if tc_version_is_at_least 6.0 ; then
		return 0
	fi
	if tc_version_is_at_least 4.3.2 && _tc_use_if_iuse hardened ; then
		if ! want_pie ; then
			ewarn "PIE_VER or SPECS_VER is not defined in the GCC ebuild."
		elif use vanilla ; then
			ewarn "You will not get hardened features if you have the vanilla USE-flag."
		elif _tc_use_if_iuse nopie && _tc_use_if_iuse nossp ; then
			ewarn "You will not get hardened features if you have the nopie and nossp USE-flag."
		elif ! hardened_gcc_works ; then
			ewarn "Your $(tc-arch) arch is not supported."
		else
			return 0
		fi
		ewarn "Hope you know what you are doing. Hardened will not work."
		return 0
	fi
	return 1
}

want_pie() {
	! _tc_use_if_iuse hardened && [[ -n ${PIE_VER} ]] \
		&& _tc_use_if_iuse nopie && return 1
	[[ -n ${PIE_VER} ]] && [[ -n ${SPECS_VER} ]] && return 0
	tc_version_is_at_least 4.3.2 && return 1
	[[ -z ${PIE_VER} ]] && return 1
	_tc_use_if_iuse nopie || return 0
	return 1
}

has toolchain_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" toolchain_death_notice"
toolchain_death_notice() {
	if [[ -e "${WORKDIR}"/build ]] ; then
		pushd "${WORKDIR}"/build >/dev/null
		(echo '' | $(tc-getCC ${CTARGET}) ${CFLAGS} -v -E - 2>&1) > gccinfo.log
		[[ -e "${T}"/build.log ]] && cp "${T}"/build.log .
		tar jcf "${WORKDIR}"/gcc-build-logs.tar.bz2 \
			gccinfo.log build.log $(find -name config.log)
		rm gccinfo.log build.log
		eerror
		eerror "Please include ${WORKDIR}/gcc-build-logs.tar.bz2 in your bug report."
		eerror
		popd >/dev/null
	fi
}

fi

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_prepare src_configure \
	src_compile src_test src_install pkg_postinst pkg_postrm

# Note [implicitly enabled flags]
# -------------------------------
# Usually configure-based packages handle explicit feature requests
# like
#     ./configure --enable-foo
# as explicit request to check for support of 'foo' and bail out at
# configure time.
#
# GCC does not follow this pattern and instead overrides autodetection
# of the feature and enables it unconditionally.
# See bugs:
#    https://gcc.gnu.org/PR85663 (libsanitizer on mips)
#    https://bugs.gentoo.org/661252 (libvtv on powerpc64)
#
# Thus safer way to enable/disable the feature is to rely on implicit
# enabled-by-default state:
#    econf $(usex foo '' --disable-foo)

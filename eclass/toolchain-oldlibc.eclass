# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain.eclass
# @MAINTAINER:
# Toolchain Ninjas <toolchain@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common code for sys-devel/gcc ebuilds

case ${EAPI} in
	7) inherit eutils ;;
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

DESCRIPTION="The GNU Compiler Collection for libc5 or libc4"
HOMEPAGE="https://gcc.gnu.org/"

inherit fixheadtails flag-o-matic gnuconfig libtool toolchain-funcs prefix downgrade-arch-flags

case ${CATEGORY} in
dev-libc5)
	TOOL_SUFFIX="linux-gnulibc1"
	case $(tc-arch) in
	amd64|x86)
		TOOL_PREFIX="i586-legacy"
		;;
	*)
		;;
	esac
	;;
dev-libc4)
	TOOL_SUFFIX="linuxaout"
	LDFLAGS="-Wl,-O1"
	case $(tc-arch) in
	amd64|x86)
		TOOL_PREFIX="i486-legacy"
		;;
	*)
		;;
	esac
	;;
*)
	die
	;;
esac

CBUILD="${TOOL_PREFIX}-${TOOL_SUFFIX}"
CHOST=${CBUILD}
AS="${CHOST}-as"
LD="${CHOST}-ld"
AR="${CHOST}-ar"
RANLIB="${CHOST}-ranlib"

FEATURES=${FEATURES/multilib-strict/}

#---->> globals <<----

export CTARGET=${CTARGET:-${CHOST}}
: ${TARGET_ABI:=${ABI}}
: ${TARGET_MULTILIB_ABIS:=${MULTILIB_ABIS}}
: ${TARGET_DEFAULT_ABI:=${DEFAULT_ABI}}


# General purpose version check.  Without a second arg matches up to minor version (x.x.x)
tc_version_is_at_least() {
	ver_test "${2:-${GCC_RELEASE_VER}}" -ge "$1"
}

# General purpose version range check
# Note that it matches up to but NOT including the second version
tc_version_is_between() {
	tc_version_is_at_least "${1}" && ! tc_version_is_at_least "${2}"
}

GCC_PV=${TOOLCHAIN_GCC_PV:-${PV}}
GCC_PVR=${GCC_PV}
[[ ${PR} != "r0" ]] && GCC_PVR=${GCC_PVR}-${PR}

# GCC_RELEASE_VER must always match 'gcc/BASE-VER' value.
# It's an internal representation of gcc version used for:
# - versioned paths on disk
# - 'gcc -dumpversion' output. Must always match <digit>.<digit>.<digit>.
if [[ ${PN} == "egcs" ]] ; then
	GCC_PV=2.91.66
fi
GCC_RELEASE_VER=$(ver_cut 1-3 ${GCC_PV})

GCC_BRANCH_VER=$(ver_cut 1-2 ${GCC_PV})
GCCMAJOR=$(ver_cut 1 ${GCC_PV})
GCCMINOR=$(ver_cut 2 ${GCC_PV})
GCCMICRO=$(ver_cut 3 ${GCC_PV})

# Ideally this variable should allow for custom gentoo versioning
# of binary and gcc-config names not directly tied to upstream
# versioning. In practive it's hard to untangle from gcc/BASE-VER
# (GCC_RELEASE_VER) value.
GCC_CONFIG_VER=${GCC_RELEASE_VER}

PREFIX=${TOOLCHAIN_PREFIX:-${EPREFIX}/usr}

if tc_version_is_at_least 4 ; then
	die ">=gcc-4 not support libc5/libc4"
elif tc_version_is_at_least 3.4 ; then
	LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc/${CTARGET}/${GCC_CONFIG_VER}}
else
	LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc-lib/${CTARGET}/${GCC_CONFIG_VER}}
fi
INCLUDEPATH=${TOOLCHAIN_INCLUDEPATH:-${LIBPATH}/include}

BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}

DATAPATH=${TOOLCHAIN_DATAPATH:-${PREFIX}/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}}

# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR=${TOOLCHAIN_STDCXX_INCDIR:-${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}}

#---->> LICENSE+SLOT+IUSE logic <<----

if tc_version_is_at_least 3.3 ; then
	LICENSE="GPL-2+ LGPL-2.1+ FDL-1.2+"
else
	LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
fi

IUSE="test vanilla"
RESTRICT="!test? ( test )"

RESTRICT+=" strip"

TC_FEATURES=()

tc_has_feature() {
	has "$1" "${TC_FEATURES[@]}"
}

tc_version_is_at_least 2.1 && IUSE+=" +cxx"
tc_version_is_at_least 2.1 && IUSE+=" objc"
tc_version_is_between 2.9 4.0 && IUSE+=" f77"

if [[ ${PN} == "egcs" ]] ; then
	SLOT="${PV}"
else
	SLOT="${GCC_CONFIG_VER}"
fi

#---->> DEPEND <<----

BDEPEND="
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4
	test? (
		>=dev-util/dejagnu-1.4.4
		>=sys-devel/autogen-5.5.4
	)"
DEPEND="${RDEPEND}"

PDEPEND=">=sys-devel/gcc-config-2.3"

#---->> S + SRC_URI essentials <<----

S=$(
	if [[ ${PN} == "egcs" ]] ; then
		echo ${WORKDIR}/${P}
	else
		echo ${WORKDIR}/gcc-${GCC_PV}
	fi
)

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

get_gcc_src_uri() {
	if tc_version_is_at_least 3.2 ; then
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

	echo "${GCC_SRC_URI}"
}

SRC_URI=$(get_gcc_src_uri)

#---->> pkg_setup <<----

toolchain-oldlibc_pkg_setup() {
	# we dont want to use the installed compiler's specs to build gcc
	unset GCC_SPECS
	unset LANGUAGES #265283
}

git_init_src() {
	pushd "${WORKDIR}"/${P} > /dev/null
	git init && git config user.name toolchain && \
	git config user.email "toolchain@localhost" && \
	git add * && git commit -am "init" 1>/dev/null
	popd > /dev/null
}

#---->> src_unpack <<----

toolchain-oldlibc_src_unpack() {
	default_src_unpack
	#git_init_src
}

#---->> src_prepare <<----

toolchain-oldlibc_src_prepare() {
	export BRANDING_GCC_PKGVERSION="Gentoo ${GCC_PVR}"
	cd "${S}" || die

	do_gcc_gentoo_patches

	eapply_user

	# make sure the pkg config files install into multilib dirs.
	# since we configure with just one --libdir, we can't use that
	# (as gcc itself takes care of building multilibs).  #435728
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

	if tc_version_is_at_least 2.9 ; then
		gcc_version_patch
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
	if tc_version_is_between 3.0 4.8 ; then
		sed -i -e 's/\(install.*:\) install-.*recursive/\1/' "${S}"/libffi/Makefile.in || die
		sed -i -e 's/\(install-data-am:\).*/\1/' "${S}"/libffi/include/Makefile.in || die
	fi

	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# update configure files
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
	if tc_version_is_at_least 3 ; then
		sed -i 's|A-Za-z0-9|[:alnum:]|g' "${S}"/gcc/*.awk || die #215828
	fi
}

do_gcc_gentoo_patches() {
	if ! use vanilla ; then
		if [[ -n ${PATCH_VER} ]] ; then
			einfo "Applying Gentoo patches ..."
			eapply "${WORKDIR}"/patch/*.patch
			BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION} p${PATCH_VER}"
		fi
	fi
}

gcc_version_patch() {
	# gcc-4.3+ has configure flags (whoo!)
	tc_version_is_at_least 4.3 && return 0

	local version_string=${GCC_RELEASE_VER}

	einfo "patching gcc version: ${version_string} (${BRANDING_GCC_PKGVERSION})"

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

toolchain-oldlibc_src_configure() {
	downgrade_arch_flags ${GCC_BRANCH_VER}
	gcc_do_filter_flags

	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""
	einfo "LDFLAGS=\"${LDFLAGS}\""

	# Force internal zip based jar script to avoid random
	# issues with 3rd party jar implementations.  #384291
	export JAR=no

	local confgcc
	if tc_version_is_at_least 2.0 ; then
		confgcc=( --host=${CHOST} )
	else
		confgcc=( -srcdir=../${P} ${CHOST} )
	fi

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
			--oldincludedir="${INCLUDEPATH}"
			--datadir="${DATAPATH}"
			--mandir="${DATAPATH}/man"
			--infodir="${DATAPATH}/info"
			--with-gxx-include-dir="${STDCXX_INCDIR}"
		)
	fi

	### general options

	confgcc+=(
		--enable-obsolete
	)

	### language options

	local GCC_LANG="c"
	if [[ "${STAGE1}" != "yes" ]] ; then
		is_cxx && GCC_LANG+=",c++"
		if is_objc ; then
			GCC_LANG+=",objc"
		fi
		is_f77 && GCC_LANG+=",f77"
	fi

	tc_version_is_at_least 2.9 && confgcc+=( --enable-languages=${GCC_LANG} )

	if tc_version_is_at_least 2.7 ; then
		confgcc+=( --disable-werror )
	fi

	tc_version_is_at_least 2.7 && confgcc+=( --disable-nls )

	if tc_version_is_between 2.7 3.4 ; then
		confgcc+=( --disable-libunwind-exceptions )
	fi

	# Support to disable pch when building libstdcxx
	if tc_version_is_at_least 3.4 ; then
		confgcc+=( --disable-libstdcxx-pch )
	fi

	confgcc+=( --enable-threads=single )
	if tc_version_is_at_least 2.7 ; then
		confgcc+=( --disable-multilib --disable-shared )
	fi

	confgcc+=(
		--enable-clocale=generic
	)

	### arch options

	local with_abi_map=()
	case $(tc-arch) in
	x86)
		# Default arch for x86 is normally i386, lets give it a bump
		# since glibc will do so based on CTARGET anyways
		tc_version_is_at_least 3.0 && confgcc+=( --with-arch=${CTARGET%%-*} )
		;;
	esac

	tc_version_is_between 2.7 3.1 && confgcc+=( --enable-version-specific-runtime-libs )

	### library options

	if tc_version_is_between 3.0 7.0 ; then
		confgcc+=( --disable-libgcj )
	fi

	# Disable gcc info regeneration -- it ships with generated info pages
	# already.  Our custom version/urls/etc... trigger it.  #464008
	export gcc_cv_prog_makeinfo_modern=no

	# Do not let the X detection get in our way.  We know things can be found
	# via system paths, so no need to hardcode things that'll break multilib.
	# Older gcc versions will detect ac_x_libraries=/usr/lib64 which ends up
	# killing the 32bit builds which want /usr/lib.
	export ac_cv_have_x='have_x=yes ac_x_includes= ac_x_libraries='

	confgcc+=( "$@" ${EXTRA_ECONF} )

	# Nothing wrong with a good dose of verbosity
	echo
	einfo "PREFIX:          ${PREFIX}"
	einfo "BINPATH:         ${BINPATH}"
	einfo "LIBPATH:         ${LIBPATH}"
	einfo "DATAPATH:        ${DATAPATH}"
	einfo "STDCXX_INCDIR:   ${STDCXX_INCDIR}"
	echo
	einfo "Languages:       ${GCC_LANG}"
	echo
	einfo "Configuring GCC with: ${confgcc[@]//--/\n\t--}"
	echo

	# Build in a separate build tree
	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	# and now to do the actual configuration
	addwrite /dev/zero
	echo "${S}"/configure "${confgcc[@]}"
	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash.  Newer ones will auto-detect, but this is not harmful.
	CONFIG_SHELL="${EPREFIX}/bin/bash" \
	bash "${S}"/configure "${confgcc[@]}" || die "failed to run configure"

	# return to whatever directory we were in before
	popd > /dev/null
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

	# dont want to funk ourselves
	filter-flags '-mabi*' -m31 -m32 -m64

	filter-flags -frecord-gcc-switches # 490738
	filter-flags -mno-rtm -mno-htm # 506202

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
}


#----> src_compile <----

toolchain-oldlibc_src_compile() {
	touch "${S}"/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	[[ ! -x /usr/bin/perl ]] \
		&& find "${WORKDIR}"/build -name '*.[17]' -exec touch {} +

	# To compile ada library standard files special compiler options are passed
	# via ADAFLAGS in the Makefile.
	# Unset ADAFLAGS as setting this override the options
	unset ADAFLAGS

	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash.  Newer ones will auto-detect, but this is not harmful.
	# This needs to be set for compile as well, as it's used in libtool
	# generation, which will break install otherwise (at least in 3.3.6): #664486
	CONFIG_SHELL="${EPREFIX}/bin/bash" \
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
	if [[ "${STAGE1}" == "yes" ]] ; then
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET}
	else
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap}
	fi

	if [[ ${GCC_BRANCH_VER} == "3.0" ]] ; then
		STAGE1_CFLAGS=
	else
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"${CFLAGS}"}
	fi

	BOOT_CFLAGS=${BOOT_CFLAGS-"${CFLAGS}"}

	einfo "Compiling ${PN} (${GCC_MAKE_TARGET})..."

	pushd "${WORKDIR}"/build >/dev/null

	if tc_version_is_at_least 2.9 ; then
		PATH=${PREFIX}/${CHOST}/bin:${PATH} emake \
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
		PATH=${PREFIX}/${CHOST}/bin:${PATH} emake \
			CC="${CC}" \
			CXX="${CXX}" \
			LANGUAGES="${LANGUAGES}" \
			LDFLAGS="${LDFLAGS}" \
			STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
			LIBPATH="${LIBPATH}" \
			${GCC_MAKE_TARGET} \
			|| die "emake failed with ${GCC_MAKE_TARGET}"
	fi

	popd >/dev/null
}

#---->> src_test <<----

toolchain-oldlibc_src_test() {
	cd "${WORKDIR}"/build
	# 'asan' wants to be preloaded first, so does 'sandbox'.
	# To make asan tests work disable sandbox for all of test suite.
	# 'backtrace' tests also does not like 'libsandbox.so' presence.
	SANDBOX_ON=0 LD_PRELOAD= emake -k check
}

#---->> src_install <<----

toolchain-oldlibc_src_install() {
	cd "${WORKDIR}"/build

	# Don't allow symlinks in private gcc include dir as this can break the build
	find gcc/include*/ -type l -delete

	# Copy over the info pages.  We disabled their generation earlier, but the
	# build system only expects to install out of the build dir, not the source.  #464008
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
	if tc_version_is_at_least 2.9 ; then
		S="${WORKDIR}"/build PATH=${PREFIX}/${CHOST}/bin:${PATH} emake -j1 DESTDIR="${D}" install || die
	else
		S="${WORKDIR}"/build PATH=${PREFIX}/${CHOST}/bin:${PATH} emake CC="${CC}" CXX="${CXX}" LANGUAGES="${LANGUAGES}" -j1 DESTDIR="${D}" install || die
	fi

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \;
	# This one comes with binutils
	find "${ED}" -name libiberty.a -delete

	# Move the libraries to the proper location
	gcc_movelibs

	# Basic sanity check
	if tc_version_is_at_least 2.8; then
		local EXEEXT
		eval $(grep ^EXEEXT= "${WORKDIR}"/build/gcc/config.log)
		[[ -r ${D}${BINPATH}/gcc${EXEEXT} ]] || die "gcc not found in ${ED}"
	fi

	dodir /etc/env.d/gcc
	create_gcc_env_entry
	create_revdep_rebuild_entry

	dodir /usr/bin
	cd "${D}"${BINPATH}
	# Ugh: we really need to auto-detect this list.
	#      It's constantly out of date.
	for x in cpp gcc g++ c++ gcov g77 ; do
		# For some reason, g77 gets made instead of ${CTARGET}-g77...
		# this should take care of that
		if [[ -f ${x} ]] ; then
			# In case they're hardlinks, clear out the target first
			# otherwise the mv below will complain.
			rm -f ${CTARGET}-${x}
			mv ${x} ${CTARGET}-${x}
		fi

		if [[ -f ${CTARGET}-${x} ]] ; then
			# Create versioned symlinks
			dosym ${BINPATH}/${CTARGET}-${x} \
				/usr/bin/${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi

		if [[ -f ${CTARGET}-${x}-${GCC_CONFIG_VER} ]] ; then
			rm -f ${CTARGET}-${x}-${GCC_CONFIG_VER}
			ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi
	done

	${CTARGET}-strip -d -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${LIBPATH}/{*.a,*.o,32/*.a,32/*.o,n32/*.o,n32/*.a}
	${CTARGET}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${LIBPATH}/{*.so*,32/*.so*,n32/*.so*,*.dll,32/*.dll}
	${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${LIBPATH}/{cc1*,collect2,cpp*,f771,tradcpp0}
	${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${BINPATH}/*
	${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${HOSTLIBPATH}/*
	${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/{*,plugin/*}
	${CHOST}-strip -s -N __gentoo_check_ldflags__ -R .comment -R .note ${D}${LIBPATH}/plugin/*.so*

	cd "${S}" || die
	rm -rf "${ED}"/usr/share/{man,info}
	rm -rf "${D}"${DATAPATH}/{man,info}

	# portage regenerates 'dir' files on it's own: bug #672408
	# Drop 'dir' files to avoid collisions.
	if [[ -f "${D}${DATAPATH}"/info/dir ]]; then
		einfo "Deleting '${D}${DATAPATH}/info/dir'"
		rm "${D}${DATAPATH}"/info/dir || die
	fi

	# prune empty dirs left behind
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
	# dynamic & static case (libgfortran.spec). #573302
	# libgfortranbegin.la: Same as above, and it's an internal lib.
	# libmpx.la: gcc itself handles linkage correctly (libmpx.spec).
	# libmpxwrappers.la: See above.
	# libitm.la: gcc itself handles linkage correctly (libitm.spec).
	# libvtv.la: gcc itself handles linkage correctly.
	# lib*san.la: Sanitizer linkage is handled internally by gcc, and they
	# do not support static linking. #487550 #546700
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
	chown -R root:0 "${D}${LIBPATH}" 2>/dev/null

	# Installing gdb pretty-printers into gdb-specific location.
	local py gdbdir=/usr/share/gdb/auto-load${LIBPATH}
	pushd "${D}${LIBPATH}" >/dev/null
	for py in $(find . -name '*-gdb.py') ; do
		local multidir=${py%/*}
		insinto "${gdbdir}/${multidir}"
		sed -i "/^libdir =/s:=.*:= '${LIBPATH}/${multidir}':" "${py}" || die #348128
		doins "${py}" || die
		rm "${py}" || die
	done
	popd >/dev/null

	# Don't scan .gox files for executable stacks - false positives
	export QA_EXECSTACK="usr/lib*/go/*/*.gox"
	export QA_WX_LOAD="usr/lib*/go/*/*.gox"
}

# Move around the libs to the right location.  For some reason,
# when installing gcc, it dumps internal libraries into /usr/lib
# instead of the private gcc lib path
gcc_movelibs() {
	# older versions of gcc did not support --print-multi-os-directory
	tc_version_is_at_least 3.1 || return 0

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
}

# make sure the libtool archives have libdir set to where they actually
# -are-, and not where they -used- to be.  also, any dependencies we have
# on our own .la files need to be updated.
fix_libtool_libdir_paths() {
	local libpath="$1"

	pushd "${D}" >/dev/null

	pushd "./${libpath}" >/dev/null
	local dir="${PWD#${D%/}}"
	local allarchives=$(echo *.la)
	allarchives="\(${allarchives// /\\|}\)"
	popd >/dev/null

	# The libdir might not have any .la files. #548782
	find "./${dir}" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^libdir=/s:=.*:='${dir}':" {} + || die
	# Would be nice to combine these, but -maxdepth can not be specified
	# on sub-expressions.
	find "./${PREFIX}"/lib* -maxdepth 3 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die
	find "./${dir}/" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die

	popd >/dev/null
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

	dodir /etc/revdep-rebuild
	cat <<-EOF > "${revdep_rebuild_file}"
	# Generated by ${CATEGORY}/${PF}
	# Ignore libraries built for ${CTARGET}, https://bugs.gentoo.org/692844.
	SEARCH_DIRS_MASK="${LIBPATH}"
	EOF
}

#---->> pkg_post* <<----

toolchain-oldlibc_pkg_postinst() {
	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	rm -f "${EROOT}"/sbin/fix_libtool_files.sh
	rm -f "${EROOT}"/usr/sbin/fix_libtool_files.sh
	rm -f "${EROOT}"/usr/share/gcc-data/fixlafiles.awk
}

toolchain-oldlibc_pkg_postrm() {
	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi

	# gcc stopped installing .la files fixer in June 2020.
	# Cleaning can be removed in June 2022.
	rm -f "${EROOT}"/sbin/fix_libtool_files.sh
	rm -f "${EROOT}"/usr/share/gcc-data/fixlafiles.awk
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

is_cxx() {
	gcc-lang-supported 'c++' || return 1
	_tc_use_if_iuse cxx
}

is_f77() {
	gcc-lang-supported f77 || return 1
	_tc_use_if_iuse f77
}

is_objc() {
	gcc-lang-supported objc || return 1
	_tc_use_if_iuse objc
}

# Grab a variable from the build system (taken from linux-info.eclass)
get_make_var() {
	local var=$1 makefile=${2:-${WORKDIR}/build/Makefile}
	echo -e "e:\\n\\t@echo \$(${var})\\ninclude ${makefile}" | \
		r=${makefile%/*} emake --no-print-directory -s -f - 2>/dev/null
}

XGCC() { get_make_var GCC_FOR_TARGET ; }


has toolchain-oldlibc_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" toolchain-oldlibc_death_notice"
toolchain-oldlibc_death_notice() {
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

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure \
	src_compile src_test src_install pkg_postinst pkg_postrm


# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# Maintainer: Toolchain Ninjas <toolchain@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
#
# We install binutils into CTARGET-VERSION specific directories.  This lets
# us easily merge multiple versions for multiple targets (if we wish) and
# then switch the versions on the fly (with `binutils-config`).

inherit libtool flag-o-matic gnuconfig strip-linguas toolchain-funcs downgrade-arch-flags
case ${EAPI:-0} in
7|8)
	EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_test src_install pkg_postinst pkg_postrm ;;
*) die "unsupported EAPI ${EAPI}" ;;
esac

DESCRIPTION="Tools necessary to build programs"
HOMEPAGE="https://sourceware.org/binutils/"

if [[ ${CATEGORY} != cross-* ]] ; then
	case ${CATEGORY} in
	dev-libc5)
		OLDLIBC="yes"
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
		OLDLIBC="yes"
		TOOL_SUFFIX="linuxaout"
		case $(tc-arch) in
		amd64|x86)
			TOOL_PREFIX="i486-legacy"
			;;
		*)
			;;
		esac
		;;
	*)
		;;
	esac

	if [[ ${TOOL_PREFIX} != "" ]]; then
		CTARGET="${TOOL_PREFIX}-${TOOL_SUFFIX}"
	fi
fi

#
# The cross-compile logic
#
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_djgpp() { [[ ${CTARGET} == *-msdosdjgpp* ]] ; }
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }
is_oldlibc() { [[ ${OLDLIBC} == "yes" ]] ; }

BVER=${PV}
SLOT="${BVER}"

# General purpose version check.  Without a second arg matches up to minor version (x.x.x)
BINUTILS_RELEASE_VER=$(ver_cut 1-3 ${BVER})
tc_version_is_at_least() {
	ver_test "${2:-${BINUTILS_RELEASE_VER}}" -ge "$1"
}
if tc_version_is_at_least 2.28.1 ; then
	SRC_URI="https://mirrors.ustc.edu.cn/gnu/binutils/binutils-${BVER}.tar.xz"
elif tc_version_is_at_least 2.12 ; then
	SRC_URI="https://mirrors.ustc.edu.cn/gnu/binutils/binutils-${BVER}.tar.bz2"
else
	SRC_URI="https://mirrors.ustc.edu.cn/gnu/binutils/binutils-${BVER}.tar.gz"
fi
if tc_version_is_at_least 2.18 ; then
	LICENSE="|| ( GPL-3 LGPL-3 )"
else
	LICENSE="|| ( GPL-2 LGPL-2 )"
fi
IUSE="+cxx doc multitarget nls static-libs test"
if tc_version_is_at_least 2.21 ; then
	IUSE+=" gold"
fi
if tc_version_is_at_least 2.39 ; then
	IUSE+=" gprofng"
fi

#
# The dependencies
#
RDEPEND="
	>=sys-devel/binutils-config-3
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	doc? ( sys-apps/texinfo )
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )
	sys-devel/flex
"
RESTRICT="!test? ( test )"

if is_cross && ! is_oldlibc ; then
	# The build assumes the host has libiberty and such when cross-compiling
	# its build tools.  We should probably make binutils itself build a local
	# copy to use, but until then, be lazy.
	DEPEND+=" >=sys-libs/binutils-libs-${PV}"
fi

MY_BUILDDIR=${WORKDIR}/build

toolchain-binutils_src_unpack() {
	case ${PV} in
		9999)
			git-r3_src_unpack;
			;;
		*)
			default
			;;
	esac
	mkdir -p "${MY_BUILDDIR}"
}

toolchain-binutils_src_prepare() {
	if [[ ! -z ${PATCH_VER} ]] ; then
		PATCH_BINUTILS_VER=${PATCH_BINUTILS_VER:-${BVER}}
		einfo "Applying binutils-${PATCH_BINUTILS_VER} patchset ${PATCH_VER}"
		tar -pxf ${FILESDIR}/binutils-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz -C ${WORKDIR}/ || die
		if [[ ${CTARGET} == mips* ]] ; then
			rm -rfv ${WORKDIR}/patch/77_all_generate-gnu-hash.patch
		fi
		eapply "${WORKDIR}/patch"/*.patch
	fi

	# Make sure our explicit libdir paths don't get clobbered, bug #562460
	sed -i \
		-e 's:@bfdlibdir@:@libdir@:g' \
		-e 's:@bfdincludedir@:@includedir@:g' \
		{bfd,opcodes}/Makefile.in || die

	# Fix locale issues if possible, bug #122216
	if [[ -e ${FILESDIR}/binutils-configure-LANG.patch ]] ; then
		einfo "Fixing misc issues in configure files"
		for f in $(find "${S}" -name configure -exec grep -l 'autoconf version 2.13' {} +) ; do
			ebegin "  Updating ${f/${S}\/}"
			patch "${f}" "${FILESDIR}"/binutils-configure-LANG.patch >& "${T}"/configure-patch.log \
				|| eerror "Please file a bug about this"
			eend $?
		done
	fi

	# Fix conflicts with newer glibc #272594
	if ! tc_version_is_at_least 2.39 ; then
		if [[ -e libiberty/testsuite/test-demangle.c ]] ; then
			sed -i 's:\<getline\>:get_line:g' libiberty/testsuite/test-demangle.c
		fi
	fi

	# Fix po Makefile generators
	if ! tc_version_is_at_least 2.30 && tc_version_is_at_least 2.10 ; then
		sed -i \
			-e '/^datadir = /s:$(prefix)/@DATADIRNAME@:@datadir@:' \
			-e '/^gnulocaledir = /s:$(prefix)/share:$(datadir):' \
			*/po/Make-in || die "sed po's failed"
	fi

	# Apply things from PATCHES and user dirs
	default

	# Run misc portage update scripts
	gnuconfig_update
	elibtoolize --portage --no-uclibc
}

# Intended for ebuilds to override to set their own versioning information.
toolchain-binutils_bugurl() {
	printf "https://bugs.gentoo.org/"
}
toolchain-binutils_pkgversion() {
	printf "Gentoo ${BVER}"
	[[ -n ${PATCH_VER} ]] && printf " p${PATCH_VER}"
}

toolchain-binutils_src_configure() {
	# portage-3.0.67 not export CC/CXX
	export CC=${CC}
	export CXX=${CXX}

	# See https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html
	# Avoid really confusing logs from subconfigure spam, makes logs far
	# more legible.
	if tc_version_is_at_least 2.38 ; then
		MAKEOPTS="--output-sync=line ${MAKEOPTS}"
	fi

	# Setup some paths
	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${BVER}
	INCPATH=${LIBPATH}/include
	DATAPATH=/usr/share/binutils-data/${CTARGET}/${BVER}
	if is_cross && ! is_oldlibc ; then
		TOOLPATH=/usr/${CHOST}/${CTARGET}
	else
		TOOLPATH=/usr/${CTARGET}
	fi
	BINPATH=${TOOLPATH}/binutils-bin/${BVER}

	# Make sure we filter $LINGUAS so that only ones that
	# actually work make it through, bug #42033
	strip-linguas -u */po

	# Keep things sane
	strip-flags

	local x
	echo
	for x in CATEGORY CBUILD CHOST CTARGET CFLAGS LDFLAGS ; do
		einfo "$(printf '%10s' ${x}:) ${!x}"
	done
	echo

	cd "${MY_BUILDDIR}" || die
	local myconf=()

	# enable gold (installed as ld.gold) and ld's plugin architecture
	if in_iuse gold && use gold ; then
		myconf+=( --enable-gold )
	fi

	if use cxx ; then
		myconf+=( --enable-plugins )
	fi

	if use nls ; then
		myconf+=( --without-included-gettext )
	else
		myconf+=( --disable-nls )
	fi

	if tc_version_is_at_least 2.26 ; then
		myconf+=( --with-system-zlib )
	fi

	# For bi-arch systems, enable a 64bit bfd. This matches the bi-arch
	# logic in toolchain.eclass. bug #446946
	#
	# We used to do it for everyone, but it's slow on 32bit arches. bug #438522
	case $(tc-arch) in
		ppc|sparc|x86) myconf+=( --enable-64-bit-bfd ) ;;
	esac

	use multitarget && myconf+=( --enable-targets=all --enable-64-bit-bfd )

	[[ -n ${CBUILD} ]] && myconf+=( --build=${CBUILD} )

	is_cross && myconf+=(
		--with-sysroot="${EPREFIX}"/usr/${CTARGET}
		--enable-poison-system-directories
	)

	myconf+=( --enable-secureplt )

	myconf+=(
		--prefix="${EPREFIX}"/usr
		--host=${CHOST}
		--target=${CTARGET}
		--datadir="${EPREFIX}"${DATAPATH}
		--infodir="${EPREFIX}"${DATAPATH}/info
		--mandir="${EPREFIX}"${DATAPATH}/man
		--bindir="${EPREFIX}"${BINPATH}
		--libdir="${EPREFIX}"${LIBPATH}
		--libexecdir="${EPREFIX}"${LIBPATH}
		--includedir="${EPREFIX}"${INCPATH}
		--disable-werror
		$(use_enable static-libs static)
		# Disable modules that are in a combined binutils/gdb tree, bug #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
	)

	if ! is_djgpp ; then
		myconf+=( 
			--enable-shared
			--enable-threads
			# Newer versions (>=2.27) offer a configure flag now.
			--enable-relro
			# Newer versions (>=2.24) make this an explicit option, bug #497268
			--enable-install-libiberty
		)
	fi

	if tc_version_is_at_least 2.18 ; then
		myconf+=( 
			--with-bugurl="$(toolchain-binutils_bugurl)"
			--with-pkgversion="$(toolchain-binutils_pkgversion)"
		)
	fi

	if tc_version_is_at_least 2.30 ; then
		# mips can't do hash-style=gnu ...
		if [[ $(tc-arch) != mips ]] && ! is_djgpp ; then
			myconf+=( --enable-default-hash-style=gnu )
		fi

		myconf+=( 
			--datarootdir="${EPREFIX}"${DATAPATH}
			# Change SONAME to avoid conflict across
			# {native,cross}/binutils, binutils-libs, bug #666100
			--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}-$(usex multitarget mt st)
		)
	fi

	if tc_version_is_at_least 2.34 ; then
		# avoid automagic dependency on (currently prefix) systems
		# systems with debuginfod library, bug #754753
		myconf+=( 
			--without-debuginfod
		)
	fi

	if tc_version_is_at_least 2.35 ; then
		# Available from 2.35 on
		myconf+=( 
			--enable-textrel-check=warning
		)
	fi

	if tc_version_is_at_least 2.37 ; then
		# These hardening options are available from 2.39+ but
		# they unconditionally enable the behaviour even on arches
		# where e.g. execstacks can't be avoided.
		# See https://sourceware.org/bugzilla/show_bug.cgi?id=29592.
		#--enable-warn-execstack
		#--enable-warn-rwx-segments
		#--disable-default-execstack (or is it --enable-default-execstack=no? docs are confusing)

		# Things to think about
		#--enable-deterministic-archives

		# Works better than vapier's patch, bug #808787
		myconf+=( 
			--enable-new-dtags
		)
	fi

	if ! tc_version_is_at_least 2.39 && tc_version_is_at_least 2.38 ; then
		# (--disable-silent-rules should get passed automatically w/ econf which we use
		# in >= 2.39, so can drop it then.)
		myconf+=( 
			--disable-silent-rules
		)
	fi

	if tc_version_is_at_least 2.39 ; then
		myconf+=( 
			--disable-jansson
			# Avoid automagic dev-libs/msgpack dep, bug #865875
			--without-msgpack
			# We can enable this by default in future, but it's brand new
			# in 2.39 with several bugs:
			# - Doesn't build on musl (https://sourceware.org/bugzilla/show_bug.cgi?id=29477)
			# - No man pages (https://sourceware.org/bugzilla/show_bug.cgi?id=29521)
			# - Broken at runtime without Java (https://sourceware.org/bugzilla/show_bug.cgi?id=29479)
			# - binutils-config (and this ebuild?) needs adaptation first (https://bugs.gentoo.org/865113)
			$(use_enable gprofng)
		)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}" || die

	# Prevent makeinfo from running if doc is unset.
	if ! use doc ; then
		sed -i \
			-e '/^MAKEINFO/s:=.*:= true:' \
			Makefile || die
	fi
}

toolchain-binutils_src_compile() {
	cd "${MY_BUILDDIR}" || die
	# see Note [tooldir hack for ldscripts]
	emake tooldir="${EPREFIX}${TOOLPATH}" all

	# only build info pages if the user wants them
	if use doc ; then
		emake info
	fi

	# we nuke the manpages when we're left with junk
	# (like when we bootstrap, no perl -> no manpages)
	find . -name '*.1' -a -size 0 -delete
}

toolchain-binutils_src_test() {
	cd "${MY_BUILDDIR}" || die

	# bug #637066
	filter-flags -Wall -Wreturn-type
	emake -k V=1 check
}

toolchain-binutils_src_install() {
	local x d

	cd "${MY_BUILDDIR}" || die
	# see Note [tooldir hack for ldscripts]
	emake DESTDIR="${D}" tooldir="${EPREFIX}${LIBPATH}" install
	rm -rf "${ED}"/${LIBPATH}/bin || die
	use static-libs || find "${ED}" -name '*.la' -delete

	# Newer versions of binutils get fancy with ${LIBPATH}, bug #171905
	cd "${ED}"/${LIBPATH} || die
	for d in ../* ; do
		[[ ${d} == ../${BVER} ]] && continue
		mv ${d}/* . || die
		rmdir ${d} || die
	done

	# Now we collect everything intp the proper SLOT-ed dirs
	# When something is built to cross-compile, it installs into
	# /usr/$CHOST/ by default ... we have to 'fix' that :)
	if is_cross ; then
		cd "${ED}"/${BINPATH} || die
		for x in * ; do
			mv ${x} ${x/${CTARGET}-} || die
		done

		if [[ -d ${ED}/usr/${CHOST}/${CTARGET} ]] && ! is_oldlibc ; then
			mv "${ED}"/usr/${CHOST}/${CTARGET}/include "${ED}"/${INCPATH}
			mv "${ED}"/usr/${CHOST}/${CTARGET}/lib/* "${ED}"/${LIBPATH}/
			rm -r "${ED}"/usr/${CHOST}/{include,lib}
		fi
	fi

	insinto ${INCPATH}
	if tc_version_is_at_least 2.12 ; then
		local libiberty_headers=(
			# Not all the libiberty headers.  See libiberty/Makefile.in:install_to_libdir.
			demangle.h
			dyn-string.h
			fibheap.h
			hashtab.h
			libiberty.h
			objalloc.h
			splay-tree.h
		)
		doins "${libiberty_headers[@]/#/${S}/include/}"
	fi
	if [[ -d ${ED}/${LIBPATH}/lib ]] ; then
		mv "${ED}"/${LIBPATH}/lib/* "${ED}"/${LIBPATH}/ || die
		rm -r "${ED}"/${LIBPATH}/lib || die
	fi

	# Generate an env.d entry for this binutils
	insinto /etc/env.d/binutils
	cat <<-EOF > "${T}"/env.d
		TARGET="${CTARGET}"
		VER="${BVER}"
		LIBPATH="${EPREFIX}${LIBPATH}"
	EOF
	newins "${T}"/env.d ${CTARGET}-${BVER}

	# Remove shared info pages
	rm -f "${ED}"/${DATAPATH}/info/{dir,configure.info,standards.info}
	if is_cross; then
		rm -rf "${ED}"/usr/share/
	fi

	# Trim all empty dirs
	find "${ED}" -depth -type d -exec rmdir {} + 2>/dev/null
}

toolchain-binutils_pkg_postinst() {
	# Make sure this ${CTARGET} has a binutils version selected
	[[ -e ${EROOT}/etc/env.d/binutils/config-${CTARGET} ]] && return 0
	binutils-config ${CTARGET}-${BVER}
}

toolchain-binutils_pkg_postrm() {
	local current_profile=$(binutils-config -c ${CTARGET})

	# If no other versions exist, then uninstall for this
	# target ... otherwise, switch to the newest version
	# Note: only do this if this version is unmerged.  We
	#       rerun binutils-config if this is a remerge, as
	#       we want the mtimes on the symlinks updated (if
	#       it is the same as the current selected profile)
	if [[ ! -e ${EPREFIX}${BINPATH}/ld ]] && [[ ${current_profile} == ${CTARGET}-${BVER} ]] ; then
		local choice=$(binutils-config -l | grep ${CTARGET} | awk '{print $2}')
		choice=${choice//$'\n'/ }
		choice=${choice/* }
		if [[ -z ${choice} ]] ; then
			binutils-config -u ${CTARGET}
		else
			binutils-config ${choice}
		fi
	elif [[ $(CHOST=${CTARGET} binutils-config -c) == ${CTARGET}-${BVER} ]] ; then
		binutils-config ${CTARGET}-${BVER}
	fi
}

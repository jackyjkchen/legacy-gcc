# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PATCH_VER=5

inherit toolchain-funcs multilib-minimal

MY_PN="binutils"
MY_P="${MY_PN}-${PV}"
PATCH_BINUTILS_VER=${PATCH_BINUTILS_VER:-${PV}}
PATCH_DEV=${PATCH_DEV:-slyfox}

DESCRIPTION="Core binutils libraries (libbfd, libopcodes, libiberty) for external packages"
HOMEPAGE="https://sourceware.org/binutils/"
SRC_URI="https://mirrors.ustc.edu.cn/gnu/binutils/binutils-${PV}.tar.xz"

LICENSE="|| ( GPL-3 LGPL-3 )"
# The shared lib SONAMEs use the ${PV} in them.
# -r1 is a one-off subslot bump where SONAME changed for bug #666100
SLOT="0/${PV}-r1"
KEYWORDS="amd64 x86"
IUSE="64-bit-bfd multitarget nls"

COMMON_DEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	>=sys-apps/texinfo-4.7
	nls? ( sys-devel/gettext )"
# Need a newer binutils-config that'll reset include/lib symlinks for us.
RDEPEND="${COMMON_DEPEND}
	>=sys-devel/binutils-config-5
	nls? ( !<sys-devel/gdb-7.10-r1[nls] )"

CC="gcc-4.9.4"
CXX="g++-4.9.4"
BDEPEND="sys-devel/gcc:4.9.4"

S="${WORKDIR}/${MY_P}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bfd.h
)

src_prepare() {
	if [[ ! -z ${PATCH_VER} ]] ; then
		einfo "Applying binutils-${PATCH_BINUTILS_VER} patchset ${PATCH_VER}"
		tar -pxf ${FILESDIR}/binutils-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz -C ${WORKDIR}/ || die
		if [[ ${CTARGET} == mips* ]] ; then
			rm -rfv ${WORKDIR}/patch/77_all_generate-gnu-hash.patch
		fi
		eapply "${WORKDIR}/patch"/*.patch
	fi
	default
}

pkgversion() {
	printf "Gentoo ${PVR}"
	[[ -n ${PATCHVER} ]] && printf " p${PATCHVER}"
}

multilib_src_configure() {
	local myconf=(
		--enable-obsolete
		--disable-shared
		--enable-static
		--enable-threads
		# Newer versions (>=2.24) make this an explicit option. #497268
		--enable-install-libiberty
		--disable-werror
		--with-bugurl="https://bugs.gentoo.org/"
		--with-pkgversion="$(pkgversion)"
		# The binutils eclass enables this flag for all bi-arch builds,
		# but other tools often don't care about that support.  Put it
		# beyond a flag if people really want it, but otherwise leave
		# it disabled as it can slow things down on 32bit arches. #438522
		$(use_enable 64-bit-bfd)
		# This only disables building in the zlib subdir.
		# For binutils itself, it'll use the system version. #591516
		--without-zlib
		--with-system-zlib
		# We only care about the libs, so disable programs. #528088
		--disable-{binutils,etc,ld,gas,gold,gprof}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
		# We pull in all USE-flags that change ABI in an incompatible
		# way. #666100
		# USE=multitarget change size of global arrays
		# USE=64-bit-bfd changes data structures of exported API 
		--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}-$(usex multitarget mt st)-$(usex 64-bit-bfd 64 def)
	)

	# mips can't do hash-style=gnu ...
	if [[ $(tc-arch) != mips ]] ; then
		myconf+=( --enable-default-hash-style=gnu )
	fi

	use multitarget && myconf+=( --enable-targets=all --enable-64-bit-bfd )

	use nls \
		&& myconf+=( --without-included-gettext ) \
		|| myconf+=( --disable-nls )

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_install() {
	default
	# Provide libiberty.h directly.
	dosym libiberty/libiberty.h /usr/include/libiberty.h
}

multilib_src_install_all() {
	find "${ED}"/usr -name '*.la' -delete
}

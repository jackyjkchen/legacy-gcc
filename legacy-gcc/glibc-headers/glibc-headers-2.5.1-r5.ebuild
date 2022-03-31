# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${PV}.tar.bz2
		https://mirrors.ustc.edu.cn/gnu/glibc/glibc-ports-2.5.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
KEYWORDS="alpha amd64 m68k mips ppc s390 sh sparc x86"
CC="gcc-4.4.7"
CXX="g++-4.4.7"
case ${ARCH} in
	amd64)
		TOOL_PREFIX="x86_64-legacy"
		TOOL32_PREFIX="i686-legacy"
		;;
	x86)
		TOOL_PREFIX="i686-legacy"
		;;
	alpha|m68k)
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	mips|sparc)
		TOOL_PREFIX="${PROFILE_ARCH}-legacy"
		TOOL32_PREFIX="${PROFILE_ARCH/64/}-legacy"
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
SLOT="2.2"

DEPEND="
	legacy-gcc/linux-headers
	legacy-gcc/binutils-wrapper"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gcc:4.4.7"

CHOST="${TOOL_PREFIX}-linux-gnu"

S=${WORKDIR}/glibc-${PV}

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_glibc-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_glibc-${PV}-workaround-for-old-gcc.patch
	pushd "${WORKDIR}"/glibc-ports-2.5 > /dev/null
	eapply "${FILESDIR}"/${PV}/02_glibc-ports-workaround-for-old-gcc.patch
	[[ ${ARCH} == "m68k" ]] && eapply "${FILESDIR}"/${PV}/03_glibc-ports-m68k-nptl-headers.patch
	popd > /dev/null
}

src_configure() {
	downgrade_arch_flags 4.4.7
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--enable-kernel=2.6.0
		--with-headers=/usr/${CHOST}/include
		--prefix=${ED}/usr/${CHOST}
		--enable-shared
		--enable-nptl
		--enable-add-ons=nptl,../glibc-ports-2.5
		--with-tls
		--with-__thread
		--enable-sim
		--without-cvs
		--without-selinux
		--disable-werror
		--enable-bind-now
		--disable-profile
		--without-gd
		--enable-crypt
		--disable-nscd
		--disable-sanity-checks
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	"${S}"/configure "${econfargs[@]}" libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes || die "failed to run configure"

	popd > /dev/null
}

src_compile() {
	einfo "Do nothing."
}

src_install() {
	pushd "${WORKDIR}"/build >/dev/null
	emake install-headers || die
	touch  ${ED}/usr/${CHOST}/include/gnu/stubs.h || die
	cp -v bits/stdio_lim.h ${ED}/usr/${CHOST}/include/bits || die
	rm -rv ${ED}/usr/${CHOST}/include/scsi || die
	if [[ ${TOOL32_PREFIX} != "" ]] && [[ ${TOOL32_PREFIX} != ${TOOL_PREFIX} ]] ; then
		TARGET32_PREFIX="${TOOL32_PREFIX}-linux-gnu"
		mkdir -p ${ED}/usr/${TARGET32_PREFIX} || die
		ln -sv ../${CHOST}/include ${ED}/usr/${TARGET32_PREFIX}/include || die
	fi
	popd > /dev/null
}


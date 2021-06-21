# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${PV}.tar.bz2
		https://mirrors.ustc.edu.cn/gnu/glibc/glibc-ports-2.5.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
KEYWORDS="alpha amd64 mips ppc s390 sparc x86"
CC="gcc-4.4.7"
CXX="g++-4.4.7"
case ${ARCH} in
	amd64|x86)
		CC="${CC} ${CFLAGS_x86}"
		CXX="${CXX} ${CFLAGS_x86}"
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

DEPEND="
	sys-devel/gcc:4.4.7
	legacy-gcc/linux-headers:${TOOL_SLOT}
	legacy-gcc/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

S=${WORKDIR}/glibc-${PV}

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_glibc-${PV}.patch || die
	eapply "${FILESDIR}"/${PV}/01_glibc-${PV}-workaround-for-old-gcc.patch || die
	pushd "${WORKDIR}"/glibc-ports-2.5 > /dev/null
	eapply "${FILESDIR}"/${PV}/02_glibc-ports-workaround-for-old-gcc.patch || die
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
	popd > /dev/null
}


# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${PV}.tar.bz2"

inherit downgrade-arch-flags gnuconfig

LICENSE=""
KEYWORDS="amd64 x86"
case ${ARCH} in
	amd64|x86)
		TOOL_SLOT="i686-legacy"
		;;
	*)
		TOOL_SLOT="invalid"
		;;
esac
SLOT="${TOOL_SLOT}"

DEPEND="
	sys-devel/gcc:3.4.6
	sys-kernel/linux-headers:${TOOL_SLOT}
	sys-devel/binutils-wrapper:${TOOL_SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${TOOL_SLOT}-linux-gnu"

case ${ARCH} in
	amd64)
		CC="gcc-3.4.6 -m32"
		CXX="g++-3.4.6 -m32"
		;;
	x86)
		CC="gcc-3.4.6"
		CXX="g++-3.4.6"
		;;
esac

S=${WORKDIR}/glibc-${PV}

src_prepare() {
	default
	gnuconfig_update
	eapply "${FILESDIR}"/${PV}/00_glibc-${PV}.patch || die
	eapply "${FILESDIR}"/${PV}/01_glibc-${PV}-workaround-for-old-gcc.patch || die
}

src_configure() {
	downgrade_arch_flags 3.4.6
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
		--target=${CHOST}
		--enable-kernel=2.6.0
		--with-headers=/usr/${CHOST}/include
		--prefix=${ED}/usr/${CHOST}
		--enable-shared
		--enable-nptl
		--enable-add-ons
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


# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${PV}.tar.bz2"

inherit downgrade_arch_flags

LICENSE=""
SLOT="i686-legacy"
KEYWORDS="amd64 x86"

DEPEND="
	sys-devel/gcc:4.4.7
	legacy-gcc/linux-headers:i686-legacy
	legacy-gcc/binutils-wrapper:i686-legacy"
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_PREFIX="${SLOT}-linux-gnu"

case ${ARCH} in
	amd64)
		CC="gcc-4.4.7 -m32"
		CXX="g++-4.4.7 -m32"
		;;
	x86)
		CC="gcc-4.4.7"
		CXX="g++-4.4.7"
		;;
esac

src_unpack() {
	default
	ln -sv "${WORKDIR}"/glibc-${PV} "${WORKDIR}"/${P}
}

src_prepare() {
	default
	tar -pxf ${FILESDIR}/glibc-2.19-patches-9.tar.bz2 -C ${WORKDIR}/ || die
	eapply "${WORKDIR}"/patches/*.patch || die
	eapply "${FILESDIR}"/${PV}/00_glibc-${PV}.patch || die
}

src_configure() {
	downgrade_arch_flags 4.4
	local econfargs=(
		--build=${TARGET_PREFIX}
		--host=${TARGET_PREFIX}
		--enable-kernel=2.6.32
		--with-headers=/usr/${TARGET_PREFIX}/include
		--prefix=${ED}/usr/${TARGET_PREFIX}
		--enable-shared
		--enable-add-ons
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
	touch  ${ED}/usr/${TARGET_PREFIX}/include/gnu/stubs.h || die
	rm -rv ${ED}/usr/${TARGET_PREFIX}/include/scsi || die
	popd > /dev/null
}


# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${PV}.tar.bz2"

inherit downgrade_arch_flags

LICENSE=""
SLOT="i486-legacy"
KEYWORDS="amd64 x86"

DEPEND="
	sys-devel/gcc:3.4.6
	legacy-gcc/linux-headers:i486-legacy
	legacy-gcc/binutils-wrapper:i486-legacy"
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_PREFIX="${SLOT}-linux-gnu"

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


src_unpack() {
	default
	ln -sv "${WORKDIR}"/glibc-${PV} "${WORKDIR}"/${P}
}

src_prepare() {
	default
	eapply "${FILESDIR}"/${PV}/00_glibc-${PV}.patch || die
	eapply "${FILESDIR}"/${PV}/01_glibc-${PV}-workaround-for-old-gcc.patch || die
}

src_configure() {
	downgrade_arch_flags 2.9
	local econfargs=(
		--build=${TARGET_PREFIX}
		--host=${TARGET_PREFIX}
		--enable-kernel=2.4.37
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
	cp -v bits/stdio_lim.h ${ED}/usr/${TARGET_PREFIX}/include/bits || die
	rm -rv ${ED}/usr/${TARGET_PREFIX}/include/scsi || die
	popd > /dev/null
}


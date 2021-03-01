# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${PV}.tar.bz2"

inherit downgrade-arch-flags

LICENSE=""
SLOT="i686-legacy"
KEYWORDS="amd64 x86"

DEPEND="
	sys-devel/gcc:3.4.6
	legacy-gcc/linux-headers:i686-legacy
	legacy-gcc/binutils-wrapper:i686-legacy"
RDEPEND="${DEPEND}"
BDEPEND=""

CHOST="${SLOT}-linux-gnu"

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
	downgrade_arch_flags 3.4.6
	cat <<-_EOF_ > config.cache || die
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_386_tls=yes
_EOF_
	local econfargs=(
		--build=${CHOST}
		--host=${CHOST}
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
		--disable-sanity-checks --cache-file=config.cache
	)

	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	echo "${S}"/configure "${econfargs[@]}"

	"${S}"/configure "${econfargs[@]}" || die "failed to run configure"

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


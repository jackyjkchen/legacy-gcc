# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CBUILD='i686-legacy-linux-gnu'
CHOST=${CBUILD}
CHOST_x86=${CBUILD}
ABI='x86'
DEFAULT_ABI='x86'
ABI_X86='32'
AS="${CHOST}-as"
LD="${CHOST}-ld"
AR="${CHOST}-ar"
RANLIB="${CHOST}-ranlib"
CFLAGS_x86=""

inherit toolchain

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gcc:2.95.3
	legacy-gcc/linux-headers:i686-legacy
	legacy-gcc/glibc-headers:i686-legacy
	legacy-gcc/binutils-wrapper:i686-legacy"

CC="gcc-2.95.3"
CXX="g++-2.95.3"

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/${PV}/00_egcs-${PV}.patch
	eapply "${FILESDIR}"/${PV}/01_workaround-for-new-glibc.patch
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/08-${CHOST}-egcs-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/2.91.66
_EOF_
}
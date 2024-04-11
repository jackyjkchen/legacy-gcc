# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="amd64 m68k x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}-gentoo-install-path.patch
	eapply "${FILESDIR}"/${PV}/02_gcc-${PV}-workaround-for-new-glibc.patch
}

src_install() {
	toolchain_src_install
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/14-${CHOST}-gcc-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/${GCC_CONFIG_VER}
_EOF_
}

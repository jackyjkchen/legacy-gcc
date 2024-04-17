# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 m68k ppc sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_egcs-${PV}.patch
	toolchain_src_prepare

	eapply "${FILESDIR}"/${PV}/01_workaround-for-new-glibc.patch
	eapply "${FILESDIR}"/${PV}/02_sjlj-exception-default.patch

	if ! _tc_use_if_iuse cxx; then
		rm -r libstdc++ libio gcc/cp || die
	fi
	if ! _tc_use_if_iuse objc; then
		rm -r gcc/objc || die
	fi
	if ! _tc_use_if_iuse f77; then
		rm -r libf2c gcc/f || die
	fi
	touch -r gcc/README gcc/configure.in || die

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch
}

src_install() {
	toolchain_src_install
	rm -rf "${ED}"/usr/share/locale
	mkdir -p ${ED}/etc/ld.so.conf.d/ || die
	cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/12-${CHOST}-egcs-${SLOT}.conf || die
/usr/lib/gcc-lib/${CHOST}/2.91.66
_EOF_
}

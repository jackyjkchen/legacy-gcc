# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-oldlibc

KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${CATEGORY}/binutils
	${CATEGORY}/libc"
BDEPEND="sys-devel/gcc:2.95.3"

if [[ -f /usr/bin/${CTARGET}-gcc-2.95.3 ]] ; then
	CC="${CTARGET}-gcc-2.95.3"
	CXX="${CTARGET}-g++-2.95.3"
else
	STAGE1='yes'
	CC="gcc-2.95.3"
	CXX="g++-2.95.3"
fi

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-2.95.4-without-change-version.patch
	eapply "${FILESDIR}"/${PV}/01_gcc-${PV}.patch
	toolchain-oldlibc_src_prepare

	eapply "${FILESDIR}"/${PV}/02_workaround-for-legacy-glibc-in-non-system-dir.patch
	eapply "${FILESDIR}"/${PV}/05_fix-crash-00204.patch
	eapply "${FILESDIR}"/${PV}/06_sjlj-exception-default.patch
	eapply "${FILESDIR}"/${PV}/10_fix-for-libc5.patch
	eapply "${FILESDIR}"/${PV}/11_fix-for-libc4.patch
	touch -r gcc/README gcc/configure.in || die

	rm -rf libstdc++ gcc/testsuite/g++*

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch
}

src_install() {
	toolchain-oldlibc_src_install
	if [[ $STAGE1 != 'yes' ]] ; then
		cp -ax "${WORKDIR}"/build/${CTARGET}/libio/libio*.a "${ED}"/usr/lib/gcc-lib/${CHOST}/${PV}/ || die
	fi
}

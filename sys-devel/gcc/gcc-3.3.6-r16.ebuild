# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="alpha amd64 hppa m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	[[ ${TOOL_PREFIX} != "" ]] && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	case $(tc-arch) in
		mips)
			eapply "${FILESDIR}"/${PV}/02_support-mips64.patch
			# c++ coredump on n64 and more testcase fail on n32
			# [[ ${DEFAULT_ABI} == "n64" || ${DEFAULT_ABI} == "n32" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n32-abi.patch
			;;
		ppc64|ppc)
			eapply "${FILESDIR}"/${PV}/04_workaround-for-ppc64-ppc.patch
			;;
		hppa)
			eapply "${FILESDIR}"/${PV}/05_hppa-fix-build.patch
			;;
		sh)
			eapply "${FILESDIR}"/${PV}/06_fix-for-sh4.patch
			;;
	esac

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/02_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/03_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/04_pr25572.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
	is_crosscompile || rm -rf libstdc++-v3/testsuite/27_io/{filebuf_members.cc,filebuf_virtuals.cc,ostream_inserter_arith.cc,streambuf_members.cc,stringbuf_virtuals.cc}
}

src_install() {
	toolchain_src_install
	if [[ ${TOOL_PREFIX} != "" ]]; then
		mkdir -p ${ED}/etc/ld.so.conf.d/ || die
		case ${TOOL_PREFIX} in
			x86_64-legacy|sparc64-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
/usr/lib/gcc-lib/${CHOST}/${PV}/32
_EOF_
				;;
			mips64*-legacy)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
/usr/lib/gcc-lib/${CHOST}/${PV}/32
/usr/lib/gcc-lib/${CHOST}/${PV}/n32
_EOF_
				;;
			*)
				cat <<-_EOF_ > "${ED}"/etc/ld.so.conf.d/07-${CHOST}-gcc-${PV}.conf || die
/usr/lib/gcc-lib/${CHOST}/${PV}
_EOF_
				;;
		esac
	fi
}
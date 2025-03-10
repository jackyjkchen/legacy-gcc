# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 hppa m68k mips ppc ppc64 s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain_src_prepare

	! is_crosscompile && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	case $(tc-arch) in
		mips)
			eapply "${FILESDIR}"/${PV}/02_support-mips64.patch
			# coredump on n64 and more testcase fail on n32
			# [[ ${DEFAULT_ABI} == "n64" || ${DEFAULT_ABI} == "n32" ]] && eapply "${FILESDIR}"/${PV}/02_mips64-default-n32-abi.patch
			;;
		hppa)
			eapply "${FILESDIR}"/${PV}/04_hppa-fix-build.patch
			;;
	esac

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/000_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr25572.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr24915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr35317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr15759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr24103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr29295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr13041.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr7566.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr19005.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr12799.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		rm -rf libstdc++-v3/testsuite/27_io/{filebuf_members.cc,filebuf_virtuals.cc,ostream_inserter_arith.cc,streambuf_members.cc,stringbuf_virtuals.cc}
	fi
}

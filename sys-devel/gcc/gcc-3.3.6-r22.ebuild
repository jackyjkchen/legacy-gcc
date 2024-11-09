# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="alpha amd64 hppa m68k mips ppc ppc64 s390 sh sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gentoo-patchset.patch
	toolchain_src_prepare

	! is_crosscompile && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
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
	eapply "${FILESDIR}"/${PV}/postrelease/000_pr13685.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr26729.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr24969.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr25572.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr31419.patch
	eapply "${FILESDIR}"/${PV}/postrelease/006_pr29236-30897.patch
	eapply "${FILESDIR}"/${PV}/postrelease/007_pr24915.patch
	eapply "${FILESDIR}"/${PV}/postrelease/008_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/009_pr19983.patch
	eapply "${FILESDIR}"/${PV}/postrelease/010_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/011_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/012_pr24683.patch
	eapply "${FILESDIR}"/${PV}/postrelease/013_pr35317.patch
	eapply "${FILESDIR}"/${PV}/postrelease/014_pr24950.patch
	eapply "${FILESDIR}"/${PV}/postrelease/015_pr24315.patch
	eapply "${FILESDIR}"/${PV}/postrelease/016_pr15759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/017_pr24103.patch
	eapply "${FILESDIR}"/${PV}/postrelease/018_pr24278.patch
	eapply "${FILESDIR}"/${PV}/postrelease/019_pr29295.patch
	eapply "${FILESDIR}"/${PV}/postrelease/020_pr29978-35264.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
		rm -rf libstdc++-v3/testsuite/27_io/{filebuf_members.cc,filebuf_virtuals.cc,ostream_inserter_arith.cc,streambuf_members.cc,stringbuf_virtuals.cc}
	fi
}

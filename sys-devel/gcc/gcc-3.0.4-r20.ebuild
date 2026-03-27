# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain

KEYWORDS="alpha amd64 m68k mips ppc s390 sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}/00_gcc-${PV}.patch
	toolchain_src_prepare

	! is_crosscompile && eapply "${FILESDIR}"/${PV}/01_workaround-for-legacy-glibc-in-non-system-dir.patch
	[[ $(tc-arch) == "alpha" ]] && eapply "${FILESDIR}"/${PV}/02_alpha-debian.patch
	[[ $(tc-arch) == "m68k" ]] && eapply "${FILESDIR}"/${PV}/03_m68k-debian.patch
	[[ $(tc-arch) == "sparc" ]] && eapply "${FILESDIR}"/${PV}/04_sparc-debian.patch
	[[ $(tc-arch) == "sparc" ]] && eapply "${FILESDIR}"/${PV}/05_sparc-build-hang.patch
	eapply "${FILESDIR}"/${PV}/06_add-__LP64__.patch

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/000_pr45262.patch
	eapply "${FILESDIR}"/${PV}/postrelease/001_pr18681.patch
	eapply "${FILESDIR}"/${PV}/postrelease/002_pr24449.patch
	eapply "${FILESDIR}"/${PV}/postrelease/003_pr42466.patch
	eapply "${FILESDIR}"/${PV}/postrelease/004_pr15759.patch
	eapply "${FILESDIR}"/${PV}/postrelease/005_pr24103.patch

	if use test ; then
		eapply "${FILESDIR}"/${PV}/postrelease/900_fix-known-test-fail.patch
	fi
}

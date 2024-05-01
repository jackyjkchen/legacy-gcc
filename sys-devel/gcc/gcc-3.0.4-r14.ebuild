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

	use vanilla && return 0
	eapply "${FILESDIR}"/${PV}/postrelease/00_pr45262.patch

	eapply "${FILESDIR}"/${PV}/postrelease/90_fix-known-test-fail.patch
}

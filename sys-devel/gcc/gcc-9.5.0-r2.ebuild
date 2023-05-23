# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="1"

inherit toolchain

# Don't keyword live ebuilds
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

if [[ ${CATEGORY} == cross-* ]] ; then
	BDEPEND="${BDEPEND} sys-devel/gcc:9.5.0"
	CC="gcc-9.5.0"
	CXX="g++-9.5.0"
fi

src_prepare() {
	local p upstreamed_patches=(
		# add them here
	)
	for p in "${upstreamed_patches[@]}"; do
		rm -v "${WORKDIR}/patch/${p}" || die
	done

	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/25_all_disable-riscv32-ABIs.patch" || die
	fi

	toolchain_src_prepare
	use vanilla && return 0

	eapply "${FILESDIR}"/${PV}/00_workaround-for-gcc12-host.patch
	eapply "${FILESDIR}"/${PV}/01_riscv-fix-multilib.patch

	eapply "${FILESDIR}"/${PV}/postrelease/00_pr90320.patch
	eapply "${FILESDIR}"/${PV}/postrelease/01_pr106513.patch

	is_crosscompile || eapply "${FILESDIR}"/${PV}/postrelease/99_fix-known-test-fail.patch
}

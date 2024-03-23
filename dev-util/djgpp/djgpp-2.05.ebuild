# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://mirror.koddos.net/djgpp/current/v2/djcrx205.zip"

LICENSE=""
SLOT="0"
KEYWORDS="x86"
RESTRICT="strip"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

S=${WORKDIR}/djgpp-${PV}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_unpack() {
	mkdir -p "${S}" || die
	pushd "${S}" > /dev/null
	unzip -a "${DISTDIR}"/djcrx205.zip || die
	popd > /dev/null
}

src_prepare() {
	pushd "${S}" > /dev/null
	default
	eapply "${FILESDIR}"/00_djcxr205.patch
	popd > /dev/null
}

src_configure() {
	pushd "${S}" > /dev/null
	popd > /dev/null
}

src_compile() {
	pushd "${S}" > /dev/null
	mkdir bin || die
	cc -O2 -s src/stub/stubedit.c -o bin/stubedit
	cc -O2 -s src/stub/stubify.c -o bin/stubify
	popd > /dev/null
}

src_install() {
	pushd "${S}" > /dev/null
	mkdir -p "${ED}"/usr/${CTARGET}/dev/env/DJDIR/ || die
	cp -ax bin include lib "${ED}"/usr/${CTARGET}/ || die
	ln -sv include "${ED}"/usr/${CTARGET}/sys-include || die
	ln -sv ../../../include "${ED}"/usr/${CTARGET}/dev/env/DJDIR/include || die
	popd > /dev/null
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64"

DEPEND="sys-devel/binutils"
RDEPEND="${DEPEND}"
BDEPEND=""

HOST_PREFIX="x86_64-pc-linux-gnu"
TARGET_PREFIX="i686-pc-linux-gnu"
UNIX_PREFIX="/usr"
REL_PATH="../.."

src_unpack(){
	default
	mkdir -p "${WORKDIR}"/${P} || die
}

src_install() {
	mkdir -p "${ED}"${UNIX_PREFIX}/bin || die
	mkdir -p "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin || die
	ln -sv ${HOST_PREFIX}-addr2line "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-addr2line || die
	ln -sv ${HOST_PREFIX}-ar "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ar || die
	cat <<-_EOF_ > "${ED}${UNIX_PREFIX}/bin/${TARGET_PREFIX}-as" || die
#!/bin/sh
${HOST_PREFIX}-as --32 "\$@"
_EOF_
	chmod +x "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-as || die
	ln -sv ${HOST_PREFIX}-c++filt "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-c++filt || die
	ln -sv ${HOST_PREFIX}-dwp "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-dwp || die
	ln -sv ${HOST_PREFIX}-elfedit "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-elfedit || die
	ln -sv ${HOST_PREFIX}-gprof "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-gprof || die
	cat <<-_EOF_ > "${ED}${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld" || die
#!/bin/sh
${HOST_PREFIX}-ld -m elf_i386 "\$@"
_EOF_
	chmod +x "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld || die
	ln -sv ${TARGET_PREFIX}-ld "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.bfd || die
	cat <<-_EOF_ > "${ED}${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.gold" || die
#!/bin/sh
${HOST_PREFIX}-ld.gold -m elf_i386 "\$@"
_EOF_
	chmod +x "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.gold || die
	ln -sv ${HOST_PREFIX}-nm "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-nm || die
	ln -sv ${HOST_PREFIX}-objcopy "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-objcopy || die
	ln -sv ${HOST_PREFIX}-objdump "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-objdump || die
	ln -sv ${HOST_PREFIX}-ranlib "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ranlib || die
	ln -sv ${HOST_PREFIX}-readelf "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-readelf || die
	ln -sv ${HOST_PREFIX}-size "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-size || die
	ln -sv ${HOST_PREFIX}-strings "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-strings || die
	ln -sv ${HOST_PREFIX}-strip "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-strip || die

	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-addr2line "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/addr2line || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ar "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ar || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-as "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/as || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-c++filt "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/c++filt || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-dwp "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/dwp || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-elfedit "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/elfedit || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-gprof "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/gprof || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ld "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ld || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ld.bfd "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ld.bfd || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ld.gold "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ld.gold || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-nm "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/nm || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-objcopy "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/objcopy || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-objdump "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/objdump || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ranlib "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ranlib || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-readelf "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/readelf || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-size "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/size || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-strings "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/strings || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-strip "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/strip || die
}

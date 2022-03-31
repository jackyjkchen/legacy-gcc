# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE=""
KEYWORDS="alpha amd64 m68k mips ppc s390 sh sparc x86"
case ${ARCH} in
	amd64)
		TOOL_PREFIX="x86_64-legacy"
		TOOL32_PREFIX="i686-legacy"
		AS_PARAMS="--32"
		LD_PARAMS="-m elf_i386"
		;;
	x86)
		TOOL_PREFIX="i686-legacy"
		;;
	alpha|m68k)
		TOOL_PREFIX="${ARCH}-legacy"
		;;
	mips)
		TOOL_PREFIX="${PROFILE_ARCH}-legacy"
		TOOL32_PREFIX="${PROFILE_ARCH/64/}-legacy"
		if [[ ${TOOL32_PREFIX} == mipsel-legacy ]] ; then
			AS_PARAMS="-EL -mabi=32"
			LD_PARAMS="-EL -melf32ltsmip"
		elif [[ ${TOOL32_PREFIX} == mips-legacy ]] ; then
			AS_PARAMS="-EB -mabi=32"
			LD_PARAMS="-EB -melf32btsmip"
		fi
		;;
	ppc)
		TOOL_PREFIX="powerpc-legacy"
		;;
	ppc64)
		TOOL_PREFIX="powerpc64-legacy"
		;;
	s390)
		TOOL_PREFIX="s390x-legacy"
		;;
	sh)
		TOOL_PREFIX="sh4-legacy"
		;;
	sparc)
		TOOL_PREFIX="${PROFILE_ARCH}-legacy"
		TOOL32_PREFIX="${PROFILE_ARCH/64/}-legacy"
		AS_PARAMS="-32"
		LD_PARAMS="-m elf32_sparc"
		;;
	*)
		;;
esac
SLOT="0"

DEPEND="sys-devel/binutils"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack(){
	default
	mkdir -p "${WORKDIR}"/${P} || die
}

src_install() {
	HOST_PREFIX="${CHOST}"
	TARGET_PREFIX="${TOOL_PREFIX}-linux-gnu"
	UNIX_PREFIX="/usr"
	REL_PATH="../.."
	mkdir -p "${ED}"${UNIX_PREFIX}/bin || die
	mkdir -p "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin || die
	ln -sv ${HOST_PREFIX}-addr2line "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-addr2line || die
	ln -sv ${HOST_PREFIX}-ar "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ar || die
	ln -sv ${HOST_PREFIX}-as "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-as || die
	ln -sv ${HOST_PREFIX}-c++filt "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-c++filt || die
	ln -sv ${HOST_PREFIX}-elfedit "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-elfedit || die
	ln -sv ${HOST_PREFIX}-gprof "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-gprof || die
	ln -sv ${HOST_PREFIX}-ld "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld || die
	ln -sv ${TARGET_PREFIX}-ld "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.bfd || die
	if [[ -f ${UNIX_PREFIX}/bin/${HOST_PREFIX}-ld.gold ]]; then
		ln -sv ${HOST_PREFIX}-ld.gold "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.gold || die
	fi
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
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-elfedit "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/elfedit || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-gprof "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/gprof || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ld "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ld || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ld.bfd "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ld.bfd || die
	if [[ -f ${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.gold ]]; then
		ln -sv "${ED}"${UNIX_PREFIX}/bin/${TARGET_PREFIX}-ld.gold "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ld.gold || die
	fi
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-nm "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/nm || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-objcopy "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/objcopy || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-objdump "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/objdump || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-ranlib "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/ranlib || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-readelf "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/readelf || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-size "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/size || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-strings "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/strings || die
	ln -sv ${REL_PATH}/bin/${TARGET_PREFIX}-strip "${ED}"${UNIX_PREFIX}/${TARGET_PREFIX}/bin/strip || die

	if [[ ${TOOL32_PREFIX} != "" ]] && [[ ${TOOL32_PREFIX} != ${TOOL_PREFIX} ]] ; then
		TARGET32_PREFIX="${TOOL32_PREFIX}-linux-gnu"
		mkdir -p "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin || die
		ln -sv ${HOST_PREFIX}-addr2line "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-addr2line || die
		ln -sv ${HOST_PREFIX}-ar "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ar || die
		cat <<-_EOF_ > "${ED}${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-as" || die
#!/bin/sh
${HOST_PREFIX}-as ${AS_PARAMS} "\$@"
_EOF_
		chmod +x "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-as || die
		ln -sv ${HOST_PREFIX}-c++filt "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-c++filt || die
		ln -sv ${HOST_PREFIX}-elfedit "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-elfedit || die
		ln -sv ${HOST_PREFIX}-gprof "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-gprof || die
		cat <<-_EOF_ > "${ED}${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld" || die
#!/bin/sh
${HOST_PREFIX}-ld ${LD_PARAMS} "\$@"
_EOF_
		chmod +x "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld || die
		ln -sv ${TARGET32_PREFIX}-ld "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld.bfd || die
		if [[ -f ${UNIX_PREFIX}/bin/${HOST_PREFIX}-ld.gold ]]; then
			cat <<-_EOF_ > "${ED}${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld.gold" || die
#!/bin/sh
${HOST_PREFIX}-ld.gold ${LD_PARAMS} "\$@"
_EOF_
			chmod +x "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld.gold || die
		fi
		ln -sv ${HOST_PREFIX}-nm "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-nm || die
		ln -sv ${HOST_PREFIX}-objcopy "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-objcopy || die
		ln -sv ${HOST_PREFIX}-objdump "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-objdump || die
		ln -sv ${HOST_PREFIX}-ranlib "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ranlib || die
		ln -sv ${HOST_PREFIX}-readelf "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-readelf || die
		ln -sv ${HOST_PREFIX}-size "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-size || die
		ln -sv ${HOST_PREFIX}-strings "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-strings || die
		ln -sv ${HOST_PREFIX}-strip "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-strip || die

		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-addr2line "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/addr2line || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-ar "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/ar || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-as "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/as || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-c++filt "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/c++filt || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-elfedit "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/elfedit || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-gprof "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/gprof || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-ld "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/ld || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-ld.bfd "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/ld.bfd || die
		if [[ -f ${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld.gold ]]; then
			ln -sv "${ED}"${UNIX_PREFIX}/bin/${TARGET32_PREFIX}-ld.gold "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/ld.gold || die
		fi
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-nm "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/nm || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-objcopy "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/objcopy || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-objdump "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/objdump || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-ranlib "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/ranlib || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-readelf "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/readelf || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-size "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/size || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-strings "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/strings || die
		ln -sv ${REL_PATH}/bin/${TARGET32_PREFIX}-strip "${ED}"${UNIX_PREFIX}/${TARGET32_PREFIX}/bin/strip || die
	fi

}

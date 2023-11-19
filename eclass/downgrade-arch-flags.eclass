# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: downgrade_arch_flags.eclass
# @MAINTAINER:
# jiakang.cjk <jiakang.cjk@alibaba-inc.com>
# @AUTHOR:
# jiakang.cjk <jiakang.cjk@alibaba-inc.com>
# @BLURB: 
# @DESCRIPTION:

inherit flag-o-matic

# General purpose version check.  Without a second arg matches up to minor version (x.x.x)
tc_version_is_at_least() {
	ver_test "${2}" -ge "$1"
}

# General purpose version range check
# Note that it matches up to but NOT including the second version
tc_version_is_between() {
	tc_version_is_at_least "${1}" && ! tc_version_is_at_least "${2}"
}

# Replace -m flags unsupported by the version being built with the best
# available equivalent
downgrade_arch_flags() {
	local arch bver i isa myarch mytune rep ver

	bver=${1}

	if [[ $(tc-arch) != amd64 && $(tc-arch) != x86 ]] ; then
		strip-unsupported-flags
		if ! tc_version_is_at_least 3.1 ${bver} ; then
			strip-flags
			CFLAGS="-O2 -pipe"
			CXXFLAGS="-O2 -pipe"
			FFLAGS="-O2 -pipe"
			FCFLAGS="-O2 -pipe"
		fi
	fi
	case $(tc-arch) in
	alpha)
		if ! tc_version_is_at_least 2.9 ${bver}; then
			filter-flags '-mcpu=*' '-mtune=*'
			append-flags '-mcpu=ev5'
		elif ! tc_version_is_at_least 3.0 ${bver}; then
			filter-flags '-mcpu=*' '-mtune=*'
			append-flags '-mcpu=ev6'
		fi
		;;
	m68k)
		if ! tc_version_is_at_least 4.3 ${bver} ; then
			filter-flags '-march=*' '-mtune=*' '-mcpu=*'
			append-flags '-m68020'
		fi
		;;
	mips)
		if ! tc_version_is_at_least 4.4 ${bver} ; then
			filter-flags '-march=*' '-mtune=*' '-mips*'
			if ! tc_version_is_at_least 3.1 ${bver} ; then
				append-flags '-mips2'
			elif ! tc_version_is_at_least 3.3 ${bver} ; then
				if [[ ${ABI} == "n64" || ${ABI} == "n32" ]]; then
					append-flags '-mips3'
				else
					append-flags '-mips2'
				fi
			elif ! tc_version_is_at_least 3.4 ${bver} ; then
				if [[ ${ABI} == "n64" || ${ABI} == "n32" ]]; then
					append-flags '-march=mips64' '-mtune=mips64'
				else
					append-flags '-march=mips32' '-mtune=mips32'
				fi
			else
				if [[ ${ABI} == "n64" || ${ABI} == "n32" ]]; then
					append-flags '-march=mips64' '-mtune=mips64'
				else
					append-flags '-march=mips32r2' '-mtune=mips32r2'
				fi
			fi
		fi
		;;
	ppc64)
		if ! tc_version_is_at_least 6 ${bver} ; then
			replace-cpu-flags power9 power8
		fi
		;;
	sparc)
		if ! tc_version_is_at_least 3.1 ${bver} ; then
			filter-flags '-mcpu=*' '-mtune=*'
			if [[ ${ABI} == "sparc64" ]]; then
				append-flags '-mcpu=v9'
			else
				append-flags '-mcpu=v8'
			fi
		fi
		;;
	*)
		;;
	esac
	[[ $(tc-arch) != amd64 && $(tc-arch) != x86 ]] && return 0

	myarch=$(get-flag march)
	mytune=$(get-flag mtune)

	# If -march=native isn't supported we have to tease out the actual arch
	if [[ ${myarch} == native || ${mytune} == native ]] ; then
		if ! tc_version_is_at_least 4.2 ${bver}; then
			arch=$($(tc-getCC) -march=native -v -E -P - </dev/null 2>&1 \
				| sed -rn "/cc1.*-march/s:.*-march=([^ ']*).*:\1:p")
			replace-cpu-flags native ${arch}
		fi
	fi

	# Handle special -mtune flags
	[[ ${mytune} == intel ]] && ! tc_version_is_at_least 4.9 ${bver} && replace-cpu-flags intel generic
	[[ ${mytune} == generic ]] && ! tc_version_is_at_least 4.2 ${bver} && filter-flags '-mtune=*'
	[[ ${mytune} == x86-64 ]] && filter-flags '-mtune=*'
	tc_version_is_at_least 3.4 ${bver} || filter-flags '-mtune=*'

	# "added" "arch" "replacement"
	local archlist=(
		12.3  znver4 znver3
		11  sapphirerapids icelake-server
		11  rocketlake cannonlake
		11  alderlake skylake
		10  znver3 znver2
		10  tigerlake icelake-server
		10  cooperlake cascadelake
		9   znver2 znver1
		9   cascadelake skylake-avx512
		9   tremont silvermont
		9   goldmont-plus silvermont
		9   goldmont silvermont
		8   icelake-server skylake-avx512
		8   icelake-client skylake-avx512
		8   cannonlake skylake-avx512
		8   knm knl
		6   znver1 bdver4
		6   skylake-avx512 broadwell
		6   skylake broadwell
		5   knl broadwell
		4.9 bdver4 bdver3
		4.9 bonnell atom
		4.9 broadwell core-avx2
		4.9 haswell core-avx2
		4.9 ivybridge core-avx-i
		4.9 nehalem corei7
		4.9 sandybridge corei7-avx
		4.9 silvermont corei7
		4.9 westmere corei7
		4.8 bdver3 bdver2
		4.8 btver2 btver1
		4.7 bdver2 bdver1
		4.7 core-avx2 core-avx-i
		4.6 bdver1 amdfam10
		4.6 btver1 amdfam10
		4.6 core-avx-i core2
		4.6 corei7 core2
		4.6 corei7-avx core2
		4.5 atom core2
		4.3 amdfam10 k8
		4.3 athlon64-sse3 k8
		4.3 barcelona k8
		4.3 core2 nocona
		4.3 geode k6-2 # gcc.gnu.org/PR41989#c22
		4.3 k8-sse3 k8
		4.3 opteron-sse3 k8
		3.4 athlon-fx x86-64
		3.4 athlon64 x86-64
		3.4 c3-2 c3
		3.4 k8 x86-64
		3.4 opteron x86-64
		3.4 pentium-m pentium4
		3.4 pentium3m pentium3
		3.4 pentium4m pentium4
		3.3 prescott pentium4
		3.3 nocona pentium4
		3.3 x86-64 pentium4
		3.1 athlon-mp athlon
		3.1 athlon-xp athlon
		3.1 athlon-tbird athlon
		3.1 pentium4 i686
		3.1 pentium3 i686
		3.1 pentium2 i686
		3.1 k6-3 k6
		3.1 k6-2 k6
		3.0 athlon k6
	)

	for ((i = 0; i < ${#archlist[@]}; i += 3)) ; do
		myarch=$(get-flag march)
		mytune=$(get-flag mtune)

		ver=${archlist[i]}
		arch=${archlist[i + 1]}
		rep=${archlist[i + 2]}

		[[ ${myarch} != ${arch} && ${mytune} != ${arch} ]] && continue

		if ! tc_version_is_at_least ${ver} ${bver}; then
			einfo "Downgrading '${myarch}' (added in gcc ${ver}) with '${rep}'..."
			[[ ${myarch} == ${arch} ]] && replace-cpu-flags ${myarch} ${rep}
			[[ ${mytune} == ${arch} ]] && replace-cpu-flags ${mytune} ${rep}
			case ${arch} in
				znver*)
					filter-flags -mno-sse4a
					;;
				bdver*)
					filter-flags -mno-sse4a -mno-tbm -mno-fma4 -mno-lwp -mno-xop
					;;
				btver*)
					filter-flags -mno-sse4a
					;;
				amdfam10|barcelona)
					filter-flags -mno-sse4a -mno-3dnow
					;;
				k8*|opteron*|athlon*|k6-*)
					filter-flags -mno-3dnow
					;;
			esac
			case ${rep} in
				znver*)
					append-flags -mno-sse4a
					;;
				bdver*)
					append-flags -mno-sse4a -mno-tbm -mno-fma4 -mno-lwp -mno-xop
					;;
				btver*)
					append-flags -mno-sse4a
					;;
				amdfam10|barcelona)
					append-flags -mno-sse4a -mno-3dnow
					;;
				k8*|opteron*|athlon*|k6-*)
					append-flags -mno-3dnow
					;;
			esac
			continue
		else
			break
		fi
	done

	# we only check -mno* here since -m* get removed by strip-flags later on
	local isalist=(
		4.9 -mno-sha
		4.9 -mno-avx512pf
		4.9 -mno-avx512f
		4.9 -mno-avx512er
		4.9 -mno-avx512cd
		4.8 -mno-xsaveopt
		4.8 -mno-xsave
		4.8 -mno-rtm
		4.8 -mno-fxsr
		4.7 -mno-lzcnt
		4.7 -mno-bmi2
		4.7 -mno-avx2
		4.6 -mno-tbm
		4.6 -mno-rdrnd
		4.6 -mno-fsgsbase
		4.6 -mno-f16c
		4.6 -mno-bmi
		4.5 -mno-xop
		4.5 -mno-movbe
		4.5 -mno-lwp
		4.5 -mno-fma4
		4.4 -mno-pclmul
		4.4 -mno-fma
		4.4 -mno-avx
		4.4 -mno-aes
		4.3 -mno-ssse3
		4.3 -mno-sse4a
		4.3 -mno-sse4
		4.3 -mno-sse4.2
		4.3 -mno-sse4.1
		4.3 -mno-popcnt
		4.3 -mno-abm
		3.3 -mno-sse3
		3.1 -mno-sse2
		3.1 -mno-sse
		3.1 -mno-3dnow
	)

	for ((i = 0; i < ${#isalist[@]}; i += 2)) ; do
		ver=${isalist[i]}
		isa=${isalist[i + 1]}
		tc_version_is_at_least ${ver} ${bver} || filter-flags ${isa} ${isa/-m/-mno-}
	done

	strip-unsupported-flags

	if ! tc_version_is_at_least 3.1 ${bver} ; then
		strip-flags
		CFLAGS="-O2 -pipe"
		CXXFLAGS="-O2 -pipe"
		FFLAGS="-O2 -pipe"
		FCFLAGS="-O2 -pipe"
		if tc_version_is_at_least 2.8 ${bver} ; then
			append-flags -march=i686
		elif tc_version_is_at_least 2.0 ${bver} ; then
			append-flags -m486
		fi
		return 0
	fi
}


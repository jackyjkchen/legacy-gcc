#!/bin/sh
for i in /var/lib/layman/legacy-gcc/sys-devel/gcc/files/$1/postrelease/*_pr*.patch
do
	patch -p1 < $i
	if [[ $? != 0 ]] ; then
		echo "patch failed!"
		exit -1
	fi
	git add . && git diff HEAD > $i && git clean -dfx && git commit -m "$(basename $i)"
done

#!/bin/sh
mkdir -p /etc/portage/profile/package.use.force
find /etc/portage/ | grep 'cross-' | xargs rm -v
for i in `find etc/portage/ | grep 'cross-' | grep -v gcc `;do ln -sv /var/lib/layman/legacy-gcc/$i /`dirname $i`/;done

#!/bin/sh
mount --bind /etc/resolv.conf etc/resolv.conf
mount --rbind /dev dev
mount --rbind /proc proc
mount --rbind /sys sys
mount --rbind /var/db/repos/gentoo var/db/repos/gentoo
mount --rbind /var/cache/distfiles var/cache/distfiles
mount --rbind /var/cache/binpkgs var/cache/binpkgs
mount -t tmpfs tmpfs run
mount -t tmpfs tmpfs tmp
mount -omode=0755 -t tmpfs tmpfs var/log
mount -t tmpfs tmpfs var/tmp
mount -t tmpfs tmpfs var/cache/edb
mount --bind /var/lib/layman var/lib/layman

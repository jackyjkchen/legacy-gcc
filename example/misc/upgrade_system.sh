#!/bin/sh
emerge -juDN --changed-deps world && emerge --depclean

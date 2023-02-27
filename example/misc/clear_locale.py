#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import glob

os.system("for i in usr/share/*-data/*/*/locale/*;do if [[ $(basename $i) != 'zh_CN' ]]; then rm -rfv $i;fi;done")

contents = glob.glob('var/db/pkg/sys-devel/gcc-*/CONTENTS')
contents.extend(glob.glob('var/db/pkg/sys-devel/binutils-*/CONTENTS'))
for e in contents:
    cn = []
    co =  open(e).read().split('\n');
    for l in co:
        if l:
            ll = l.split(' ')
            if os.path.lexists(ll[1].lstrip('/')):
                cn.append(l)
        else:
            cn.append(l)
    open(e, 'w').write('\n'.join(cn))

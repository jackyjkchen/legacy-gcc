# 这是什么

legacy-gcc是一个gentoo的自定义overlay repo，启用该repo，可以在最新的gentoo系统中安装从gcc-2.0一直到最新版本的gcc，并且链接同一个glibc，做到开箱即用，不用调整工具链参数。

[支持gcc版本](https://github.com/jackyjkchen/legacy-gcc/tree/master/sys-devel/gcc)

最新的两个gcc版本由gentoo官方repo支持，本repo不收录


# 使用方法

本overlay repo可以使用layman管理

```
emerge -a app-portage/layman
wget https://raw.githubusercontent.com/jackyjkchen/legacy-gcc/master/etc/layman/overlays/legacy-gcc.xml \
     -O /etc/layman/overlays/legacy-gcc.xml
layman -L
layman -a legacy-gcc
```

现在你可以安装旧版本gcc了，比如于1992年发布，本来不支持linux，也不支持elf文件格式的gcc-2.0，现在可以正常在最新的kernel+glibc运行环境下运行
```
emerge -1a sys-devel/gcc:2.0
```

亦可采用如下方式安装全套legacy-gcc（所有gcc版本），并启用c c++ objc objc++ fortran语言
```
mkdir /etc/portage/sets /etc/portage/package.use
wget https://raw.githubusercontent.com/jackyjkchen/legacy-gcc/master/etc/portage/sets/legacy-gcc \
     -O /etc/portage/sets/legacy-gcc
wget https://raw.githubusercontent.com/jackyjkchen/legacy-gcc/master/etc/portage/package.use/legacy-gcc \
     -O /etc/portage/package.use/legacy-gcc
echo @legacy-gcc >> /var/lib/portage/world_sets
emerge -1a @legacy-gcc
```

对于已经启用过本overlay repo的用户，可以使用如下命令更新repo
```
layman -S
```

所有可安装版本的gcc均为bootstrap构建，即3遍构建，自己编译自己，这是验证编译器移植后可用性的重要保证。

USE参数可使用equery u sys-devel/gcc:${slot}查询

全部版本支持c语言

2.8.1以上版本支持c++和objective-c

4.1.2以上版本支持objective-c++

2.95.3-3.4.6版本支持f77

4.0.4以上版本支持f95/fortran


# 非x86系统支持

只有x86平台（包括amd64和i386）可以支持gcc-2.x的老版本。

在非x86系统上，本overlay repo仍然可以使用，但支持的gcc版本不会像x86那么老，已测试平台支持的最低gcc按本如下：

* alpha：gcc-3.4.6及以上（gcc-4.7.4有bug，bootstrap失败）
* arm64：gcc-4.8.5及以上
* armel：gcc-4.1.2及以上
* armhf：gcc-4.7.4及以上
* ppc：gcc-3.4.6及以上
* ppc64：gcc-3.4.6及以上
* ppc64le：gcc-4.8.5及以上
* s390x：gcc-3.3.6及以上


# 原理

gcc的历史很久远，对可执行文件格式和CPU架构的支持发生过大量变化，比如：

* gcc-2.3，开始支持Linux目标
* gcc-2.5，开始支持ELF可执行文件格式，之前一直都只支持传统的aout文件格式
* gcc-2.7，开始支持Linux + ELF + libc6（glibc2）
* gcc-3.0，开始全面支持C99标准
* gcc-3.1，开始支持x86-64
* gcc-3.4，gcc自身源码才基本脱离非标准的K&R C格式，全面采用C99标准

因此若想在最新的linux kernel + glibc上运行gcc，尤其是gcc-3.1以下版本，需要打大量补丁解决诸如：标准C支持问题，glibc兼容问题，工具链路径问题，gentoo安装脚本兼容问题等等。


以gcc-3.1.1为分界线，将gcc分为“现代”和“传统”两组，选择gcc-3.1.1作为分界原因如下：

* gcc-3.1开始对C99支持基本完善，大部分GNU扩展的支持也基本成型，通常不容易出现不兼容新版本glibc的情况
* gcc-3.1首次支持x86-64，对于工具链来说是个天然的分界点，在x86-64系统上，3.1以下版本必须调整工具链（i686-legacy-linux-gnu）
* 虽然实际经过实验，目前最新版本的glibc（2.32+）可以支持低至gcc-2.5的gcc bootstrap。但gcc-2.8.1/2.95.3的libstdc++无法在最新glibc下构建。gcc-3.0虽然在新glibc上大体没有问题，但出于前两点考虑，仍将分界点定为gcc-3.1

所有版本的gcc打过补丁后均运行在系统自带的libc.so.6上，glibc从2.x版本开始即保证ABI向下兼容，只要libc.so.6的版本号不变，本项目构建方案就不会break。因为对于编译器敏感的glibc header和linux header部分，传统组gcc采用与系统独立的版本。


## 现代组gcc（3.1.1版本及以上）

该组大部分版本gcc无须太多补丁即可支持bootstrap

3.2.3-4.0.4，以及4.2.4和以上版本，只应用了gentoo官方patchset

4.1.2，针对系统的新版本mpfr库做了适配

3.1.1有较多fix，包括
* libstdc++在新版本glibc下的兼容修正
* backport -print-multi-os-directory参数用于支持gentoo的multilib安装逻辑
* 支持make DESTDIR=PATH install方式安装到非prefix路径，gentoo安装逻辑需要（以下所有更低版本都有这个修改，不再单独说明）
* 作为首次支持x86-64的版本，64与32位的multilib不成熟，调整到3.2版本之后的行为


## 传统组gcc（3.0.4版本及以下）

该组gcc工具链调整为i686-legacy-linux-gnu，依赖如下三个软件包（自动依赖，无须手工安装）

legacy-gcc/binutils-wrapper:i686-legacy

legacy-gcc/linux-headers:i686-legacy

legacy-gcc/glibc-headers:i686-legacy

binutils-wrapper利用x86-64版本binutils的multiarch能力，大部分直接软链接到系统版本即可使用，as和ld则通过指定参数支持32位

linux-headers版本2.6.32.71，方便传统组gcc能调用kernel 2.6+版本的现代系统调用（如epoll）

glibc-headers版本2.5.1，应用RHEL5的兼容性补丁并删除所有不兼容gcc-2.4及以下版本的GNU扩展__attribute__ ((__const))

各版本gcc主要修改点

3.0.4：
* libstdc++在新版本glibc下的兼容修正
* 将bootstrap的依赖调整到工具链i686-legacy-linux-gnu

2.95.3：
* 将bootstrap的依赖调整到工具链i686-legacy-linux-gnu
* 该版本以及更低版本，g++不能完整支持C++98标准，gcc不能完整支持C99标准

2.0-2.8.1：
* 将编译器内exit调用换成_exit，因为gcc 2.0-2.8.1的堆栈使用方式，在新版本glibc使用特定优化选项时使用exit()方式直接退出程序可能会coredump。

2.0-2.7.2.3：
* glibc已使用strerror替代sys_nerr/sys_errlist，适配gcc内相应代码

2.0-2.6.3：
* 因不支持linux + ELF + libc6，新增支持代码
* 使用2.7.2.3的stdarg.h和stddef.h，避免和宿主编译器的冲突

2.0-2.5.8
* 使用标准C的可变参数支持，替代gcc自带的非标准C版本，避免和宿主编译器的冲突

2.0-2.3.3
* 因gcc driver不支持系统路径之外引用headers和cpp cc1，引入支持，用于使用独立的i686-legacy-linux-gnu工具链

2.0-2.1
* 修复过时的头文件引用，修复造成coredump的gcc自身bug


# 是否影响gentoo的全局FLAGS优化？

低版本gcc确实会对march等优化选项有限制，不过用户放心，本项目提供了完善的gcc flags降级机制，任意x86的march、mtune选项均可自动安全降级。[参见](https://github.com/jackyjkchen/legacy-gcc/blob/master/eclass/downgrade-arch-flags.eclass)


# TODO

gcc-1.42，他代码结构非常古老和gcc-2.x有大量结构上的差异，预期会有一定修改量

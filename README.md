# 这是什么

legacy-gcc是一个gentoo的自定义overlay repo，启用该repo，可以在最新的gentoo系统中安装从gcc-1.42一直到最新版本的gcc，并且链接同一个glibc，做到开箱即用，不用调整工具链参数。

[支持gcc版本](https://github.com/jackyjkchen/legacy-gcc/tree/master/sys-devel/gcc)。

尚未EOL的gcc版本由gentoo官方repo支持，本repo不收录。

# 项目目标

本项目旨在现代化的Linux运行时环境上可以原生的使用旧版本gcc，并且在修改量有限，保持原版本gcc核心特性的基础上。

x86与非x86均为本项目的目标，x86已经可以基于系统glibc原生运行gcc-1.42版本，其他平台已在适配中。

各平台目前支持情况如下：

Linux glibc本地工具链——
* x86：>=gcc-1.42
* amd64：>=gcc-3.1.1
* amd64-x32：>=gcc-4.7.4
* alpha：>=gcc-2.8.1
* aarch64：>=gcc-4.8.5
* armel：>=gcc-4.1.2
* armhf：>=gcc-4.4.7
* hppa1.1：>=gcc-3.1.1
* loongarch：gcc-8.5.0，gcc-9.5.0，>=gcc-12
* m68k：>=gcc-2.2.2
* mips：>=gcc-2.95.3
* mipsel：>=gcc-2.95.3
* mips64：>=gcc-3.1.1
* mips64el：>=gcc-3.1.1
* ppc：>=gcc-2.8.1
* ppc64：>=gcc-3.1.1
* ppc64le：>=gcc-4.8.5
* riscv：>=gcc-7.5.0
* s390x：>=gcc-3.0.4
* sh4：>=gcc-3.3.6
* sparc：>=gcc-2.8.1
* sparc64：>=gcc-2.95.3

其中amd64/x86/x32，mips64el/mipsel，mips64/mips，sparc64/sparc已测试支持multilib。

Windows/MSDOS交叉工具链——
* mingw-w64：>=gcc-4.5.4
* mingw-legacy：gcc-3.3.6 - gcc-8.5.0（建议gcc-4.7及以上版本使用mingw-w64）
* cygwin64：>=gcc-4.8.5
* cygwin：>=gcc-4.5.4
* cygwin-legacy：gcc-3.4.6，gcc-4.3.6 - gcc-4.7.4（建议gcc-4.5及以上版本使用cygwin）
* djgpp：gcc-3.0.4 - gcc-10.5.0


mingw-w64支持multilib，64位使用SEH异常机制（4.8以上版本），32位使用SJLJ异常机制（包括4.8以下的64位版本），保障与Windows系统DLL的最佳兼容性。

mingw-legacy仅支持32位，使用SJLJ异常机制，与mingw官方二进制发布一致。

cygwin64/cygwin/cygwin-legacy不支持multilib，异常机制与cygwin官方二进制发布一致（cygwin64使用SEH，cygwin/cygwin-legacy使用DWARF-2）。cygwin64/cygwin支持NT6.1（cygwin-3.4.6，限cygwin64），NT6.0（cygwin-3.3.6），NT5.1（cygiwn-2.5.2，XP限SP3）。cygwin-legacy支持Win2k（cygwin-1.7.18），Win9x（cygwin-1.5.25，限<=gcc-4.4.7）。

提供额外的libc5/libc4静态工具链，可与标准glibc(libc6)工具链共存，以本地工具链形式bootstrap——
* libc5: gcc-1.42 - gcc-3.4.6
* libc4: gcc-1.42 - gcc-2.95.3

libc5为ELF格式，libc4为a.out格式，a.out格式依赖内核模块ia32_aout，仅5.0以下内核支持，对于5.0或以上内核，可使用example/ia32_aout自行编译内核模块。

所有可安装版本的gcc均为bootstrap构建，即3遍构建，自己编译自己，这是验证编译器移植后可用性的重要保证。

USE参数可使用equery u sys-devel/gcc:${slot}查询。

全部版本支持c语言。

2.1以上版本支持c++和objective-c。

4.1.2以上版本支持objective-c++。

2.95.3-3.4.6版本支持f77。

4.0.4以上版本支持f95/fortran。

4.7.4以上版本支持go（USE=go默认关闭）。

本项目提供可选的dev-libs/stlport用于增强gcc-2.6.3 - gcc-2.95.3的STL，目前仅支持x86/ppc/m68k，gcc-3.0之后的C++标准库libstdc++-v3已兼容C++98标准，无需STLPort。

dev-libs/stlport:5.2.1用于sys-devel/gcc:2.95.3。

dev-libs/stlport:4.6.2用于sys-devel/egcs:1.1.2。

dev-libs/stlport:3.12.3用于sys-devel/gcc:2.8.1和sys-devel/gcc:2.7.2。

dev-libs/stlport:2.033用于sys-devel/gcc:2.6.3，注意gcc-2.6.3不支持weak符号，因此不支持STL多目标文件编译。

gcc-2.5.8或更低版本，其C++编译器无法支持STLPort。

# 原理

本章多处描述以x86平台为例，对于非x86平台情况相似但略有差异。

gcc的历史很久远，对可执行文件格式和CPU架构的支持发生过大量变化，比如：

* gcc-2.3，开始支持Linux目标
* gcc-2.5，开始支持ELF可执行文件格式，之前一直都只支持传统的aout文件格式
* gcc-2.7，开始支持Linux + ELF + libc6（glibc2）
* gcc-3.0，开始基本支持C99标准
* gcc-3.1，开始支持x86-64
* gcc-3.4，gcc自身源码才基本脱离非标准的K&R C格式

因此若想在最新的linux kernel + glibc上运行gcc，尤其是gcc-3.1以下版本，需要打大量补丁解决诸如：标准C支持问题，glibc兼容问题，工具链路径问题，gentoo安装脚本兼容问题等等。


以gcc-3.1.1为分界线，将gcc分为“现代”和“传统”两组，选择gcc-3.1.1作为分界原因如下：

* gcc-3.1开始对C99支持基本完善，大部分GNU扩展的支持也基本成型，通常不容易出现不兼容新版本glibc的情况。
* gcc-3.1首次支持x86-64，对于工具链来说是个天然的分界点，在x86-64系统上，3.1以下版本必须调整工具链（i686-legacy-linux-gnu）。出于跨平台实践和C++标准库考虑，legacy-gcc项目中gcc-3.x都使用了legacy工具链。
* 虽然实际经过实验，目前最新版本的glibc（2.32+）可以支持低至gcc-2.5的gcc bootstrap。但gcc-2.8.1/2.95.3的libstdc++无法在最新glibc下构建。gcc-3.0虽然在新glibc上大体没有问题，但出于前两点考虑，仍将分界点定为gcc-3.1。

所有版本的gcc打过补丁后均运行在系统自带的libc.so.6上，glibc从2.x版本开始即保证ABI向下兼容，只要libc.so.6的版本号不变，本项目构建方案就不会break。因为对于编译器敏感的glibc header和linux header部分，传统组gcc采用与系统独立的版本。


## 现代组gcc（3.1.1版本及以上）

该组大部分版本gcc无须太多补丁即可支持bootstrap。

3.2.3-4.0.4，以及4.2.4和以上版本，只应用了gentoo官方patchset。

4.1.2，针对系统的新版本mpfr库做了适配。

3.1.1有较多fix，包括：
* libstdc++在新版本glibc下的兼容修正。
* backport -print-multi-os-directory参数用于支持gentoo的multilib安装逻辑。
* 支持make DESTDIR=PATH install方式安装到非prefix路径，gentoo安装逻辑需要（以下所有更低版本都有这个修改，不再单独说明）。
* 作为首次支持x86-64的版本，64与32位的multilib不成熟，调整到3.2版本之后的行为。


## 传统组gcc（3.0.4版本及以下）

该组gcc工具链调整为i686-legacy-linux-gnu（后因其他平台兼容性考虑，gcc-3.4.6及以下版本均使用legacy工具链），依赖如下三个软件包（自动依赖，无须手工安装）：

legacy-gcc/binutils-wrapper

legacy-gcc/linux-headers

legacy-gcc/glibc-headers

binutils-wrapper版本2.38，并利用binutils的multiarch能力使用参数指定字长。

linux-headers版本2.6.32.71，方便传统组gcc能调用kernel 2.6+版本的现代系统调用（如epoll）。

glibc-headers版本2.5.1，应用RHEL5的兼容性补丁并删除所有不兼容gcc-2.4及以下版本的GNU扩展如__attribute__ ((__const))。

各版本gcc主要修改点——

3.0.4：
* libstdc++在新版本glibc下的兼容修正。
* 将bootstrap的依赖调整到工具链i686-legacy-linux-gnu。

2.95.3：
* 将bootstrap的依赖调整到工具链i686-legacy-linux-gnu。

2.0-2.7.2.3：
* glibc已使用strerror替代sys_nerr/sys_errlist，适配gcc内相应代码。

2.0-2.6.3：
* 因不支持linux + ELF + libc6，新增支持代码。

2.0-2.5.8：
* 使用标准C的可变参数支持，替代gcc自带的非标准C版本，避免和宿主编译器的冲突。

2.0-2.3.3：
* 因gcc driver不支持系统路径之外引用headers和cpp cc1，引入支持，用于使用独立的i686-legacy-linux-gnu工具链。

2.0-2.2.2：
* fix stdarg.h以适配glibc。

2.0-2.1：
* 修复过时的头文件引用，修复造成coredump的gcc自身bug。

1.42:
* 大量修复，并且目前存在一定的硬编码以解决调用路径问题

# 是否影响gentoo的全局FLAGS优化？

低版本gcc确实会对march等优化选项有限制，不过用户放心，本项目提供了完善的gcc flags降级机制，任意x86的march、mtune选项均可自动安全降级。[参见](https://github.com/jackyjkchen/legacy-gcc/blob/master/eclass/downgrade-arch-flags.eclass)。

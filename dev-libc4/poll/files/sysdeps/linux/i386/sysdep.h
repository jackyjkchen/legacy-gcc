/* Copyright (C) 1992, 1993, 1994 Free Software Foundation, Inc.
This file is part of the GNU C Library.

The GNU C Library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public License as
published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

The GNU C Library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with the GNU C Library; see the file COPYING.LIB.  If
not, write to the Free Software Foundation, Inc., 675 Mass Ave,
Cambridge, MA 02139, USA.  */

#include <sysdeps/linux/sysdep.h>

#if defined(__i486__) || defined(i486)
#define ALIGN 4
#else
#define ALIGN 2
#endif

#ifdef __ELF__
#define SYMBOL_NAME(X) X
#define SYMBOL_NAME_LABEL(X) X##:
#else
#define SYMBOL_NAME(X) _##X
#define SYMBOL_NAME_LABEL(X) _##X##:
#endif

#ifdef __ELF__
#define	ENTRY(name)							      \
  .globl SYMBOL_NAME(name);						      \
  .align ALIGN;								      \
  SYMBOL_NAME_LABEL(name)
#else
#define	ENTRY(name)							      \
  .globl _##name##;							      \
  .align ALIGN;								      \
  SYMBOL_NAME_LABEL(name)
#endif

/* Use this for the different syntaxes for local assembler labels */
#ifdef __ELF__
#define L(X) .L##X
#define LF(X) .L##X
#define LL(X) .L##X##:
#else
#define L(X) X
#define LF(X) X##f
#define LL(X) X##:
#endif

#ifdef PTHREAD_KERNEL

#ifdef __SVR4_I386_ABI_L1__

#define	PSEUDO(name, syscall_name, args)				      \
  .text;								      \
  ENTRY (name)								      \
    movl $(SYS_##syscall_name), %eax;					      \
    lcall $0x7,$0;

#else /* __SVR4_I386_ABI_L1__ */

#define	PSEUDO(name, syscall_name, args)				      \
  .text;								      \
  ENTRY (name)								      \
    pushl %ebp;								      \
    movl %esp,%ebp;							      \
    PUSH_##args								      \
    movl $(SYS_##syscall_name), %eax;					      \
    MOVE_##args								      \
    int $0x80;								      \
    POP_##args								      \
    movl %ebp,%esp;							      \
    popl %ebp;
 
#endif /* __SVR4_I386_ABI_L1__ */

#else /* PTHREAD_KERNEL */

/* In case of returning a memory address, negative values may not mean
   error. */
#ifdef	__CHECK_RETURN_ADDR
#define	check_error	cmpl $-4096,%edx; jbe
#else
#define	check_error	test %edx,%edx; jge
#endif

#define ERRNO_LOCATION SYMBOL_NAME(__errno_location)

#if defined(__PIC__) || defined (__pic__)

#ifdef __SVR4_I386_ABI_L1__

#define	PSEUDO(name, syscall_name, args)				      \
  .text;								      \
  ENTRY (name)								      \
    movl $(SYS_##syscall_name), %eax;					      \
    lcall $0x7,$0;							      \
    movl %eax,%edx;							      \
    check_error L(Lexit);						      \
    negl %edx;								      \
    pushl %edx;								      \
    call L(L4);								      \
   LL(L4)								      \
    popl %ebx;								      \
    addl $_GLOBAL_OFFSET_TABLE_+[.-L(L4)],%ebx;				      \
    call ERRNO_LOCATION@PLT;						      \
    popl %edx;								      \
    movl %edx,(%eax);							      \
    movl $-1,%eax;							      \
   LL(Lexit)

#else /* __SVR4_I386_ABI_L1__ */

#define	PSEUDO(name, syscall_name, args)				      \
  .text;								      \
  ENTRY (name)								      \
    pushl %ebp;								      \
    movl %esp,%ebp;							      \
    PUSH_##args								      \
    movl $SYS_##syscall_name, %eax;					      \
    MOVE_##args								      \
    int $0x80;								      \
    movl %eax,%edx;							      \
    check_error L(Lexit);						      \
    negl %edx;								      \
    pushl %edx;								      \
    call L(L4);								      \
   LL(L4)								      \
    popl %ebx;								      \
    addl $_GLOBAL_OFFSET_TABLE_+[.-L(L4)],%ebx;				      \
    call ERRNO_LOCATION@PLT;						      \
    popl %edx;								      \
    movl %edx,(%eax);							      \
    movl $-1,%eax;							      \
   LL(Lexit)								      \
    POP_##args 								      \
    movl %ebp,%esp;							      \
    popl %ebp;

#endif /* __SVR4_I386_ABI_L1__ */

#else /* PIC */

#ifdef __SVR4_I386_ABI_L1__

#define	PSEUDO(name, syscall_name, args)				      \
  .text;								      \
  ENTRY (name)								      \
    movl $(SYS_##syscall_name), %eax;					      \
    lcall $0x7,$0;							      \
    movl %eax,%edx;							      \
    check_error L(Lexit);						      \
    negl %edx;								      \
    pushl %edx;								      \
    call ERRNO_LOCATION;						      \
    popl %edx;								      \
    movl %edx,(%eax);							      \
    movl $-1,%eax;							      \
   LL(Lexit)

#else /* __SVR4_I386_ABI_L1__ */

#ifndef __GPROF__

#define	PSEUDO(name, syscall_name, args)				      \
  .text;								      \
  ENTRY (name)								      \
    pushl %ebp;								      \
    movl %esp,%ebp;							      \
    PUSH_##args								      \
    movl $(SYS_##syscall_name), %eax;					      \
    MOVE_##args								      \
    int $0x80;								      \
    movl %eax,%edx;							      \
    check_error L(Lexit);						      \
    negl %edx;								      \
    pushl %edx;								      \
    call ERRNO_LOCATION;						      \
    popl %edx;								      \
    movl %edx,(%eax);							      \
    movl $-1,%eax;							      \
   LL(Lexit)								      \
    POP_##args								      \
    movl %ebp,%esp;							      \
    popl %ebp;
 
#else 

#define	PSEUDO(name, syscall_name, args)				      \
  .data;							   	      \
    .align 4;								      \
  LL(Lprof);								      \
    .long 0;								      \
  .text;								      \
  ENTRY (name)								      \
    pushl %ebp;								      \
    movl %esp,%ebp;							      \
    movl L(Lprof),%edx;							      \
    call mcount;	    					              \
    PUSH_##args								      \
    movl $(SYS_##syscall_name), %eax;					      \
    MOVE_##args								      \
    int $0x80;								      \
    movl %eax,%edx;							      \
    check_error L(Lexit);						      \
    negl %edx;								      \
    pushl %edx;								      \
    call ERRNO_LOCATION;						      \
    popl %edx;								      \
    movl %edx,(%eax);							      \
    movl $-1,%eax;							      \
   LL(Lexit)								      \
    POP_##args								      \
    movl %ebp,%esp;							      \
    popl %ebp;
 
#endif /* __GPROF__ */

#endif /* __SVR4_I386_ABI_L1__ */

#endif /* PIC */

#endif /* PTHREAD_KERNEL */

/* Linux takes system call arguments in registers:
	0: %eax	This is the system call number.
   	1: %ebx This is the first argument.
	2: %ecx
	3: %edx
	4: %esi
	5: %edi
 */

#if defined(__PIC__) || defined (__pic__)
#define PUSH_0	pushl %ebx;
#else
#define PUSH_0	/* No arguments to push.  */
#endif
#define PUSH_1	pushl %ebx;
#define PUSH_2	PUSH_1
#define PUSH_3	PUSH_1
#define PUSH_4	pushl %esi; PUSH_3
#define PUSH_5	pushl %edi; PUSH_4

#define	MOVE_0	/* No arguments to move.  */
#define	MOVE_1	movl 8(%ebp),%ebx;
#define	MOVE_2	MOVE_1 movl 12(%ebp),%ecx;
#define	MOVE_3	MOVE_2 movl 16(%ebp),%edx;
#define	MOVE_4	MOVE_3 movl 20(%ebp),%esi;
#define	MOVE_5	MOVE_4 movl 24(%ebp),%edi;

#if defined(__PIC__) || defined (__pic__)
#define POP_0	popl %ebx;
#else
#define POP_0	/* No arguments to pop.  */
#endif
#define POP_1	popl %ebx;
#define POP_2	POP_1
#define POP_3	POP_1
#define POP_4	POP_3 popl %esi;
#define POP_5	POP_4 popl %edi;

/* Linux doesn't use it. */
#if 0
#define	r0	%eax
#define	r1	%edx
#define MOVE(x,y)	movl x , y
#endif

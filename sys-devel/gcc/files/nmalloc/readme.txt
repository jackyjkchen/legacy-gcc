This is intended to be prepared via the makefile.

To create a testable debug version, enter "make tnmalloc".

To create an object module for use in actual systems, enter 
"make malloc.o".  This will have the normal names, malloc, free,
realloc.

To create a version for profiling, enter "make tmallocp".  The
module mallocp.o created is generally suitable for profiling, 
and has the usual names.

To create a cross-reference, enter "make xrf" (under DOS boxes
only)

The various compile time flags are set up appropriately.  In
particular malloc.o should be immediately ready for inclusion
in a library.  It may be desirable to "strip" debugging
information from the module.

"make all" creates everything, "make clean" wipes them out.

The little test 'evilalgo' can be linked to either the stock
malloc system, or to the malloc.o generated above.  Then time
execution for an argument of 200000.  The original library will
probably fail where nmalloc will succeed, and nmalloc will do it
a lot faster.

To create the modules for the malloc_debug system, enter
"make tmalldbg.exe".  Once this is done other systems with the
debug mechanism can be created by linking malldbg and hookmem 
(.o) ahead of the normal runtime library.  The system using it
must #include malldbg.h.

make zip doesn't work properly.

The integration of the malldbg system is not complete, but
should function correctly.  Future changes are expected to be
fairly cosmetic, and improve performance slightly.  The
hookmem.h file will disappear and the sysquery action will be 
modified.

2003-05-01

The malldbg system now appears complete.  Documentation in
info source form is included in nmalloc.txh.  I find the 
following command useful for creating a viewable or printable
(but imperfect) .htm doc file:

makeinfo --force --no-split --no-validate --html
         -o nmalloc.htm nmalloc.txh
         
(Above is all one line)         


Bug reports to cbfalconer@worldnet.att.net.

# nmalloc makefile
# This makefile was tested under W98 and DJGPP 2.03/gcc 2.953
# and is a mess.  Feel free to create a better one.

objects = nmalloc.o cokusmt.o
sources = tnmalloc.c nmalloc.c nmalloc.h nmalloc.lst \
          cokusmt.c cokusmt.h fakesbrk.h sysquery.h \
          malldbg.c malldbg.h tmalldbg.c \
	  makefile evilalgo.c nmalloc.txh
utils   = xref.exe

CFLAGS  = -W -Wall -gstabs+ -Dinline= 

tnmalloc.exe : $(objects) tnmalloc.o
	gcc -o tnmalloc.exe tnmalloc.o $(objects)
	
# this shows up all use of magic numbers	
nmalloc.xrf : nmalloc.lst nmalloc.c nmalloc.h sysquery.h \
              malldbg.h malldbg.c tmalldbg.c tnmalloc.c
	xref -cfn8 nmalloc.lst nmalloc.xrf

# profileable version. 50% slowdown
mallocp.o   : nmalloc.c sysquery.h
	gcc -W -Wall -pg -gstabs+ -O2 -o mallocp.o \
	    -c nmalloc.c

# production version	
malloc.o    : nmalloc.c sysquery.h
	gcc -W -Wall -gstabs+ -O2 -o malloc.o \
	    -c nmalloc.c
	    
# production debug system
malldbg.o   : malldbg.c sysquery.h malldbg.h
	gcc -W -Wall -O1 -gstabs+ -c malldbg.c
	
# testing production debug version
tmalldbg.o  : tmalldbg.c sysquery.h malldbg.h
	gcc -W -Wall -gstabs+ -O1 -c tmalldbg.c
	
# testing production debug version
tmalldbg.exe : tmalldbg.o malldbg.o malloc.o
	gcc -o tmalldbg.exe tmalldbg.o malldbg.o malloc.o

# profilable	
tmallocp.o : tnmalloc.c nmalloc.h fakesbrk.h sysquery.h
	gcc -W -Wall -pg -gstabs+ -O2 -o tmallocp.o \
	    -c tnmalloc.c
	
# Use this to profile malloc under various tests. 50% slowdown
tmallocp.exe : tmallocp.o cokusmt.o mallocp.o
	gcc -pg -o tmallocp.exe tmallocp.o cokusmt.o mallocp.o

tnmalloc.o  : tnmalloc.c cokusmt.h nmalloc.h fakesbrk.h sysquery.h
cokusmt.o   : cokusmt.c cokusmt.h
evilalgo.o  : evilalgo.c malloc.o

# Development debug version
nmalloc.o   : nmalloc.c nmalloc.h fakesbrk.h sysquery.h
	gcc -W -Wall -DNEWMALLDBG -gstabs+ -O1 -c nmalloc.c

# pack it all up for shipping
nmalloc.zip   : $(sources) $(utils) readme.txt
	zip -o -u nmalloc.zip $(sources) $(utils) readme.txt
	
#create a profile
profile	: tmallocp.exe
	tmallocp 5 100000 quiet > profile
	gprof -b tmallocp.exe >> profile

.PHONY : clean zip tnmalloc tmallocp tmalldbg all xrf

clean :
	rm -f tnmalloc.exe $(objects) tnmalloc.o malloc.o \
	      mallocp.o nmalloc.xrf tmallocp.exe tmallocp.o \
	      gmon.out evilalgo.o

zip : nmalloc.zip

tnmalloc : tnmalloc.exe

tmallocp : tmallocp.exe

tmalldbg : tmalldbg.exe

# elide "zip" from this, to avoid destroying a backup
all : tnmalloc malloc.o mallocp.o tmallocp tmalldbg

xrf : nmalloc.xrf

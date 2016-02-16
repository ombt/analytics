LIBADT_OBJS = \
	mylist.o

libadt.so:	$(LIBADT_OBJS)
	CC -G ${LIBADT_OBJS) -o libadt.so

mylist.o:	mylist.c
	

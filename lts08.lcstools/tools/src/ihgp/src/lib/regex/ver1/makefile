DEBUG = -DDEBUG -DUSESTATIC -compat=4 -xildoff
HDRS = debug.h fa.h linkList.h regExpr.h returns.h set.h setState.h
OBJS = t2.o regExpr.o fa.o setState.o linkList.o set.o

t2:	$(OBJS)
	CC $(DEBUG) -g -o t2 $(OBJS)

t2.o:	t2.c $(HDRS)
	CC $(DEBUG) -c -g t2.c 

regExpr.o:	regExpr.c $(HDRS)
	CC $(DEBUG) -c -g regExpr.c 

fa.o:	fa.c $(HDRS)
	CC $(DEBUG) -c -g fa.c 

setState.o:	setState.c $(HDRS)
	CC $(DEBUG) -c -g setState.c 

linkList.o:	linkList.c $(HDRS)
	CC $(DEBUG) -c -g linkList.c 

set.o:	set.c $(HDRS)
	CC $(DEBUG) -c -g set.c 

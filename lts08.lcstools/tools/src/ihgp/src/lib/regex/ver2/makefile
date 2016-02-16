DEBUG = -DDEBUG -DUSESTATIC
HDRS = debug.h returns.h set.h regExpr.h setState.h fsm.h regx.h
OBJS = regxmain.o regExpr.o set.o setState.o fsm.o regx.o

regx:	$(OBJS)
	CC $(DEBUG) -g -o regx $(OBJS)

regxmain.o:	regxmain.c $(HDRS)
	CC $(DEBUG) -c -g regxmain.c 

regExpr.o:	regExpr.c $(HDRS)
	CC $(DEBUG) -c -g regExpr.c 

set.o:	set.c $(HDRS)
	CC $(DEBUG) -c -g set.c 

setState.o:	setState.c $(HDRS)
	CC $(DEBUG) -c -g setState.c 

fsm.o:	fsm.c $(HDRS)
	CC $(DEBUG) -c -g fsm.c 

regx.o:	regx.c $(HDRS)
	CC $(DEBUG) -c -g regx.c 



.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = -g -DDEBUG -DUSEEXCEPTION
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g -DDEBUG -DUSEEXCEPTION
INCLDIRS = 
CC = CC
LPRFLAGS = 
AR = /usr/ccs/bin/ar
LPR = mycpr2on1
ENDLIST = 

.c.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<
.C.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<
.cpp.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<
.CPP.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<

all:		t1 \
		t2 \
		$(ENDLIST)
		touch all

t1:		t1.o \
		fsem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o t1 \
			t1.o \
			fsem.o \
			$(ENDLIST)

t2:		t2.o \
		vsem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o t2 \
			t2.o \
			vsem.o \
			$(ENDLIST)

t1.o:	t1.c \
		./fsem.h \
		./debug.h \
		./returns.h \
		./vshm5.h \
		$(ENDLIST)

t2.o:	t2.c \
		./vsem.h \
		./debug.h \
		./returns.h \
		./vshm5.h \
		$(ENDLIST)

fsem.o:	fsem.c \
		./fsem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

vsem.o:	vsem.c \
		./vsem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-rm -f t1
		-rm -f t2
		-rm -f t1.o
		-rm -f t2.o
		-rm -f fsem.o
		-rm -f vsem.o

backup:		t1.c \
		t2.c \
		fsem.c \
		vsem.c \
		./debug.h \
		./vsem.h \
		./returns.h \
		./fsem.h \
		./vshm5.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp t1.c $(BACKUPDIR)/t1.c
		cp t2.c $(BACKUPDIR)/t2.c
		cp fsem.c $(BACKUPDIR)/fsem.c
		cp vsem.c $(BACKUPDIR)/vsem.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./vsem.h ./$(BACKUPDIR)/vsem.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./fsem.h ./$(BACKUPDIR)/fsem.h
		cp ./vshm5.h ./$(BACKUPDIR)/vshm5.h
		touch backup

print:		t1.c \
		t2.c \
		fsem.c \
		vsem.c \
		./debug.h \
		./vsem.h \
		./returns.h \
		./fsem.h \
		./vshm5.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			t1.c \
			t2.c \
			fsem.c \
			vsem.c \
			./debug.h \
			./vsem.h \
			./returns.h \
			./fsem.h \
			./vshm5.h \
			$(ENDLIST)

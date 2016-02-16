
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = -g -DDEBUG -DUSEEXCEPTION -features=except
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g -DDEBUG -DUSEEXCEPTION -features=except
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

all:		tfsem2 \
		tfsem \
		tvsem \
		tpsem \
		tvsem2 \
		$(ENDLIST)
		touch all

tfsem2:		tfsem2.o \
		fsem2.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tfsem2 \
			tfsem2.o \
			fsem2.o \
			$(ENDLIST)

tfsem:		tfsem.o \
		fsem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tfsem \
			tfsem.o \
			fsem.o \
			$(ENDLIST)

tvsem:		tvsem.o \
		vsem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvsem \
			tvsem.o \
			vsem.o \
			$(ENDLIST)

tpsem:		tpsem.o \
		psem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tpsem \
			tpsem.o \
			psem.o \
			-lposix4 \
			$(ENDLIST)

tvsem2:		tvsem2.o \
		vsem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvsem2 \
			tvsem2.o \
			vsem.o \
			$(ENDLIST)

tfsem2.o:	tfsem2.c \
		./fsem2.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tfsem.o:	tfsem.c \
		./fsem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

fsem2.o:	fsem2.c \
		./fsem2.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

fsem.o:	fsem.c \
		./fsem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tpsem.o:	tpsem.c \
		./psem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvsem2.o:	tvsem2.c \
		./vsem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvsem.o:	tvsem.c \
		./vsem.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

psem.o:	psem.c \
		./psem.h \
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
		-rm -f tfsem2
		-rm -f tfsem
		-rm -f tvsem
		-rm -f tpsem
		-rm -f tvsem2
		-rm -f tfsem2.o
		-rm -f tfsem.o
		-rm -f fsem2.o
		-rm -f fsem.o
		-rm -f tpsem.o
		-rm -f tvsem2.o
		-rm -f tvsem.o
		-rm -f psem.o
		-rm -f vsem.o

backup:		tfsem2.c \
		tfsem.c \
		fsem2.c \
		fsem.c \
		tpsem.c \
		tvsem2.c \
		tvsem.c \
		psem.c \
		vsem.c \
		./debug.h \
		./vsem.h \
		./fsem2.h \
		./returns.h \
		./fsem.h \
		./psem.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp tfsem2.c $(BACKUPDIR)/tfsem2.c
		cp tfsem.c $(BACKUPDIR)/tfsem.c
		cp fsem2.c $(BACKUPDIR)/fsem2.c
		cp fsem.c $(BACKUPDIR)/fsem.c
		cp tpsem.c $(BACKUPDIR)/tpsem.c
		cp tvsem2.c $(BACKUPDIR)/tvsem2.c
		cp tvsem.c $(BACKUPDIR)/tvsem.c
		cp psem.c $(BACKUPDIR)/psem.c
		cp vsem.c $(BACKUPDIR)/vsem.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./vsem.h ./$(BACKUPDIR)/vsem.h
		cp ./fsem2.h ./$(BACKUPDIR)/fsem2.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./fsem.h ./$(BACKUPDIR)/fsem.h
		cp ./psem.h ./$(BACKUPDIR)/psem.h
		touch backup

print:		tfsem2.c \
		tfsem.c \
		fsem2.c \
		fsem.c \
		tpsem.c \
		tvsem2.c \
		tvsem.c \
		psem.c \
		vsem.c \
		./debug.h \
		./vsem.h \
		./fsem2.h \
		./returns.h \
		./fsem.h \
		./psem.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			tfsem2.c \
			tfsem.c \
			fsem2.c \
			fsem.c \
			tpsem.c \
			tvsem2.c \
			tvsem.c \
			psem.c \
			vsem.c \
			./debug.h \
			./vsem.h \
			./fsem2.h \
			./returns.h \
			./fsem.h \
			./psem.h \
			$(ENDLIST)

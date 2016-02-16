
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = -g -DDEBUG
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g -DDEBUG
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

all:		semunlink \
		semwait \
		semgetvalue \
		semcreate \
		sempost \
		$(ENDLIST)
		touch all

semunlink:		semunlink.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o semunlink \
			semunlink.o \
			-lposix4 \
			$(ENDLIST)

semwait:		semwait.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o semwait \
			semwait.o \
			-lposix4 \
			$(ENDLIST)

semgetvalue:		semgetvalue.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o semgetvalue \
			semgetvalue.o \
			-lposix4 \
			$(ENDLIST)

semcreate:		semcreate.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o semcreate \
			semcreate.o \
			-lposix4 \
			$(ENDLIST)

sempost:		sempost.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o sempost \
			sempost.o \
			-lposix4 \
			$(ENDLIST)

semunlink.o:	semunlink.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)

semgetvalue.o:	semgetvalue.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)

semcreate.o:	semcreate.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)

sempost.o:	sempost.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)

semwait.o:	semwait.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-rm -f semunlink
		-rm -f semwait
		-rm -f semgetvalue
		-rm -f semcreate
		-rm -f sempost
		-rm -f semunlink.o
		-rm -f semgetvalue.o
		-rm -f semcreate.o
		-rm -f sempost.o
		-rm -f semwait.o

backup:		semunlink.c \
		semgetvalue.c \
		semcreate.c \
		sempost.c \
		semwait.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp semunlink.c $(BACKUPDIR)/semunlink.c
		cp semgetvalue.c $(BACKUPDIR)/semgetvalue.c
		cp semcreate.c $(BACKUPDIR)/semcreate.c
		cp sempost.c $(BACKUPDIR)/sempost.c
		cp semwait.c $(BACKUPDIR)/semwait.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		touch backup

print:		semunlink.c \
		semgetvalue.c \
		semcreate.c \
		sempost.c \
		semwait.c \
		./debug.h \
		./returns.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			semunlink.c \
			semgetvalue.c \
			semcreate.c \
			sempost.c \
			semwait.c \
			./debug.h \
			./returns.h \
			$(ENDLIST)

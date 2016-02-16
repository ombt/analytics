
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = -g -DKILLPGRP
LD = cc
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g -DKILLPGRP
INCLDIRS = 
CC = cc
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

all:		tsys \
		$(ENDLIST)
		touch all

tsys:		tsys.o \
		tsystem.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tsys \
			tsys.o \
			tsystem.o \
			$(ENDLIST)

tsystem.o:	tsystem.c \
		$(ENDLIST)

tsys.o:	tsys.c \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-rm -f tsys
		-rm -f tsystem.o
		-rm -f tsys.o

backup:		tsystem.c \
		tsys.c \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp tsystem.c $(BACKUPDIR)/tsystem.c
		cp tsys.c $(BACKUPDIR)/tsys.c
		touch backup

print:		tsystem.c \
		tsys.c \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			tsystem.c \
			tsys.c \
			$(ENDLIST)

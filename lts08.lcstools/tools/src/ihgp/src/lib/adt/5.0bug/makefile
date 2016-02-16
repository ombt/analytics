
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = -g
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -DDEBUG -g
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

all:		tlist \
		$(ENDLIST)
		touch all

tlist:		tlist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tlist \
			tlist.o \
			$(ENDLIST)

tlist.o:	tlist.c \
		./mylist.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f tlist
		-rm -f tlist.o

backup:		tlist.c \
		./debug.h \
		./absIterator.h \
		./mylist.h \
		./returns.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp tlist.c $(BACKUPDIR)/tlist.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./absIterator.h ./$(BACKUPDIR)/absIterator.h
		cp ./mylist.h ./$(BACKUPDIR)/mylist.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		touch backup

print:		tlist.c \
		./debug.h \
		./absIterator.h \
		./mylist.h \
		./returns.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			tlist.c \
			./debug.h \
			./absIterator.h \
			./mylist.h \
			./returns.h \
			$(ENDLIST)

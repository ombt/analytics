
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
CCFLAGS = -g
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

all:		tepsilon \
		$(ENDLIST)
		touch all

tepsilon:		tepsilon.o \
		epsilon.o \
		mycomplex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tepsilon \
			tepsilon.o \
			epsilon.o \
			mycomplex.o \
			-lm \
			$(ENDLIST)

mycomplex.o:	mycomplex.c \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

epsilon.o:	epsilon.c \
		./epsilon.h \
		$(ENDLIST)

tepsilon.o:	tepsilon.c \
		./epsilon.h \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f tepsilon
		-rm -f mycomplex.o
		-rm -f epsilon.o
		-rm -f tepsilon.o

backup:		mycomplex.c \
		epsilon.c \
		tepsilon.c \
		./debug.h \
		./mycomplex.h \
		./returns.h \
		./epsilon.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp mycomplex.c $(BACKUPDIR)/mycomplex.c
		cp epsilon.c $(BACKUPDIR)/epsilon.c
		cp tepsilon.c $(BACKUPDIR)/tepsilon.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./mycomplex.h ./$(BACKUPDIR)/mycomplex.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./epsilon.h ./$(BACKUPDIR)/epsilon.h
		touch backup

print:		mycomplex.c \
		epsilon.c \
		tepsilon.c \
		./debug.h \
		./mycomplex.h \
		./returns.h \
		./epsilon.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			mycomplex.c \
			epsilon.c \
			tepsilon.c \
			./debug.h \
			./mycomplex.h \
			./returns.h \
			./epsilon.h \
			$(ENDLIST)

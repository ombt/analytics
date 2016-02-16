
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

all:		tcomplex \
		$(ENDLIST)
		touch all

tcomplex:		tcomplex.o \
		mycomplex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tcomplex \
			tcomplex.o \
			mycomplex.o \
			-lm \
			$(ENDLIST)

mycomplex.o:	mycomplex.c \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tcomplex.o:	tcomplex.c \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f tcomplex
		-rm -f mycomplex.o
		-rm -f tcomplex.o

backup:		mycomplex.c \
		tcomplex.c \
		./debug.h \
		./mycomplex.h \
		./returns.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp mycomplex.c $(BACKUPDIR)/mycomplex.c
		cp tcomplex.c $(BACKUPDIR)/tcomplex.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./mycomplex.h ./$(BACKUPDIR)/mycomplex.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		touch backup

print:		mycomplex.c \
		tcomplex.c \
		./debug.h \
		./mycomplex.h \
		./returns.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			mycomplex.c \
			tcomplex.c \
			./debug.h \
			./mycomplex.h \
			./returns.h \
			$(ENDLIST)


.SUFFIXES:		.o .c

LEXFLAGS = -n
YACC = yacc
YACCFLAGS = -d -v
LEX = lex
MAKE = make
LDFLAGS = -g -xildoff -DDEBUG
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g -xildoff -DDEBUG
INCLDIRS = 
CC = CC
LPRFLAGS = 
AR = ar
LPR = mycpr2on1
ENDLIST = 

.c.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<

all:		tstring2 \
		tstring \
		$(ENDLIST)
		touch all

tstring2:		tstring2.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstring2 \
			tstring2.o \
			mystring.o \
			$(ENDLIST)

tstring:		tstring.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstring \
			tstring.o \
			mystring.o \
			$(ENDLIST)

mystring.o:	mystring.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tstring2.o:	tstring2.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tstring.o:	tstring.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-rm -f tstring2
		-rm -f tstring
		-rm -f mystring.o
		-rm -f tstring2.o
		-rm -f tstring.o

backup:		mystring.c \
		tstring2.c \
		tstring.c \
		./debug.h \
		./mystring.h \
		./returns.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp mystring.c $(BACKUPDIR)/mystring.c
		cp tstring2.c $(BACKUPDIR)/tstring2.c
		cp tstring.c $(BACKUPDIR)/tstring.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./mystring.h ./$(BACKUPDIR)/mystring.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		touch backup

print:		mystring.c \
		tstring2.c \
		tstring.c \
		./debug.h \
		./mystring.h \
		./returns.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			mystring.c \
			tstring2.c \
			tstring.c \
			./debug.h \
			./mystring.h \
			./returns.h \
			$(ENDLIST)

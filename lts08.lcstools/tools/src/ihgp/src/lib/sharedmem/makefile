
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

all:		tvshm \
		tvshm2 \
		tvshm3 \
		tvshm4 \
		tvshm5 \
		$(ENDLIST)
		touch all

tvshm:		tvshm.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvshm \
			tvshm.o \
			$(ENDLIST)

tvshm2:		tvshm2.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvshm2 \
			tvshm2.o \
			$(ENDLIST)

tvshm3:		tvshm3.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvshm3 \
			tvshm3.o \
			$(ENDLIST)

tvshm4:		tvshm4.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvshm4 \
			tvshm4.o \
			$(ENDLIST)

tvshm5:		tvshm5.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvshm5 \
			tvshm5.o \
			$(ENDLIST)

tvshm3.o:	tvshm3.c \
		./vshm3.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvshm.o:	tvshm.c \
		./vshm.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvshm4.o:	tvshm4.c \
		./vshm4.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvshm5.o:	tvshm5.c \
		./vshm5.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvshm2.o:	tvshm2.c \
		./vshm2.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-rm -f tvshm
		-rm -f tvshm2
		-rm -f tvshm3
		-rm -f tvshm4
		-rm -f tvshm5
		-rm -f tvshm3.o
		-rm -f tvshm.o
		-rm -f tvshm4.o
		-rm -f tvshm5.o
		-rm -f tvshm2.o

backup:		tvshm3.c \
		tvshm.c \
		tvshm4.c \
		tvshm5.c \
		tvshm2.c \
		./debug.h \
		./vshm2.h \
		./vshm3.h \
		./vshm.h \
		./vshm4.h \
		./returns.h \
		./vshm5.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp tvshm3.c $(BACKUPDIR)/tvshm3.c
		cp tvshm.c $(BACKUPDIR)/tvshm.c
		cp tvshm4.c $(BACKUPDIR)/tvshm4.c
		cp tvshm5.c $(BACKUPDIR)/tvshm5.c
		cp tvshm2.c $(BACKUPDIR)/tvshm2.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./vshm2.h ./$(BACKUPDIR)/vshm2.h
		cp ./vshm3.h ./$(BACKUPDIR)/vshm3.h
		cp ./vshm.h ./$(BACKUPDIR)/vshm.h
		cp ./vshm4.h ./$(BACKUPDIR)/vshm4.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./vshm5.h ./$(BACKUPDIR)/vshm5.h
		touch backup

print:		tvshm3.c \
		tvshm.c \
		tvshm4.c \
		tvshm5.c \
		tvshm2.c \
		./debug.h \
		./vshm2.h \
		./vshm3.h \
		./vshm.h \
		./vshm4.h \
		./returns.h \
		./vshm5.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			tvshm3.c \
			tvshm.c \
			tvshm4.c \
			tvshm5.c \
			tvshm2.c \
			./debug.h \
			./vshm2.h \
			./vshm3.h \
			./vshm.h \
			./vshm4.h \
			./returns.h \
			./vshm5.h \
			$(ENDLIST)

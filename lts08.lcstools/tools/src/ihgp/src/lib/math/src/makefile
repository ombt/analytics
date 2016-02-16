
.SUFFIXES:		.o .c

LEXFLAGS = -n
YACC = yacc
YACCFLAGS = -d -v
LEX = lex
MAKE = make
LDFLAGS = -g -compat=4 -pta -xildoff
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -DDEBUG -g -compat=4 -pta -xildoff
INCLDIRS = 
CC = CC
LPRFLAGS = 
AR = ar
LPR = mycpr2on1
ENDLIST = 

.c.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<

all:		tvector \
		tmatrix \
		tgausslup2 \
		tgausslup \
		tcomplex \
		tmatrixops \
		$(ENDLIST)
		touch all

tvector:		tvector.o \
		myvector.o \
		mycomplex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvector \
			tvector.o \
			myvector.o \
			mycomplex.o \
			-lm \
			$(ENDLIST)

tmatrix:		tmatrix.o \
		matrix.o \
		myvector.o \
		mycomplex.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tmatrix \
			tmatrix.o \
			matrix.o \
			myvector.o \
			mycomplex.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tgausslup2:		tgausslup2.o \
		gausslup.o \
		matrix.o \
		myvector.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tgausslup2 \
			tgausslup2.o \
			gausslup.o \
			matrix.o \
			myvector.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tgausslup:		tgausslup.o \
		gausslup.o \
		matrix.o \
		myvector.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tgausslup \
			tgausslup.o \
			gausslup.o \
			matrix.o \
			myvector.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tcomplex:		tcomplex.o \
		mycomplex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tcomplex \
			tcomplex.o \
			mycomplex.o \
			-lm \
			$(ENDLIST)

tmatrixops:		tmatrixops.o \
		matrixops.o \
		matrix.o \
		myvector.o \
		mycomplex.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tmatrixops \
			tmatrixops.o \
			matrixops.o \
			matrix.o \
			myvector.o \
			mycomplex.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tmatrixops.o:	tmatrixops.c \
		./matrix.h \
		./debug.h \
		./epsilon.h \
		./myvector.h \
		./returns.h \
		./matrixops.h \
		./mycomplex.h \
		$(ENDLIST)

tgausslup2.o:	tgausslup2.c \
		./gausslup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./myvector.h \
		./returns.h \
		$(ENDLIST)

mycomplex.o:	mycomplex.c \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

myvector.o:	myvector.c \
		./myvector.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

gausslup.o:	gausslup.c \
		./gausslup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./myvector.h \
		./returns.h \
		$(ENDLIST)

matrixops.o:	matrixops.c \
		./matrixops.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./myvector.h \
		./returns.h \
		$(ENDLIST)

tgausslup.o:	tgausslup.c \
		./gausslup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./myvector.h \
		./returns.h \
		$(ENDLIST)

tmatrix.o:	tmatrix.c \
		./matrix.h \
		./debug.h \
		./epsilon.h \
		./myvector.h \
		./returns.h \
		./mycomplex.h \
		$(ENDLIST)

epsilon.o:	epsilon.c \
		./epsilon.h \
		$(ENDLIST)

matrix.o:	matrix.c \
		./matrix.h \
		./debug.h \
		./epsilon.h \
		./myvector.h \
		./returns.h \
		$(ENDLIST)

tcomplex.o:	tcomplex.c \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvector.o:	tvector.c \
		./mycomplex.h \
		./debug.h \
		./returns.h \
		./myvector.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-rm -f tvector
		-rm -f tmatrix
		-rm -f tgausslup2
		-rm -f tgausslup
		-rm -f tcomplex
		-rm -f tmatrixops
		-rm -f tmatrixops.o
		-rm -f tgausslup2.o
		-rm -f mycomplex.o
		-rm -f myvector.o
		-rm -f gausslup.o
		-rm -f matrixops.o
		-rm -f tgausslup.o
		-rm -f tmatrix.o
		-rm -f epsilon.o
		-rm -f matrix.o
		-rm -f tcomplex.o
		-rm -f tvector.o

backup:		tmatrixops.c \
		tgausslup2.c \
		mycomplex.c \
		myvector.c \
		gausslup.c \
		matrixops.c \
		tgausslup.c \
		tmatrix.c \
		epsilon.c \
		matrix.c \
		tcomplex.c \
		tvector.c \
		./debug.h \
		./mycomplex.h \
		./myvector.h \
		./gausslup.h \
		./returns.h \
		./matrixops.h \
		./epsilon.h \
		./matrix.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp tmatrixops.c $(BACKUPDIR)/tmatrixops.c
		cp tgausslup2.c $(BACKUPDIR)/tgausslup2.c
		cp mycomplex.c $(BACKUPDIR)/mycomplex.c
		cp myvector.c $(BACKUPDIR)/myvector.c
		cp gausslup.c $(BACKUPDIR)/gausslup.c
		cp matrixops.c $(BACKUPDIR)/matrixops.c
		cp tgausslup.c $(BACKUPDIR)/tgausslup.c
		cp tmatrix.c $(BACKUPDIR)/tmatrix.c
		cp epsilon.c $(BACKUPDIR)/epsilon.c
		cp matrix.c $(BACKUPDIR)/matrix.c
		cp tcomplex.c $(BACKUPDIR)/tcomplex.c
		cp tvector.c $(BACKUPDIR)/tvector.c
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./mycomplex.h ./$(BACKUPDIR)/mycomplex.h
		cp ./myvector.h ./$(BACKUPDIR)/myvector.h
		cp ./gausslup.h ./$(BACKUPDIR)/gausslup.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./matrixops.h ./$(BACKUPDIR)/matrixops.h
		cp ./epsilon.h ./$(BACKUPDIR)/epsilon.h
		cp ./matrix.h ./$(BACKUPDIR)/matrix.h
		touch backup

print:		tmatrixops.c \
		tgausslup2.c \
		mycomplex.c \
		myvector.c \
		gausslup.c \
		matrixops.c \
		tgausslup.c \
		tmatrix.c \
		epsilon.c \
		matrix.c \
		tcomplex.c \
		tvector.c \
		./debug.h \
		./mycomplex.h \
		./myvector.h \
		./gausslup.h \
		./returns.h \
		./matrixops.h \
		./epsilon.h \
		./matrix.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			tmatrixops.c \
			tgausslup2.c \
			mycomplex.c \
			myvector.c \
			gausslup.c \
			matrixops.c \
			tgausslup.c \
			tmatrix.c \
			epsilon.c \
			matrix.c \
			tcomplex.c \
			tvector.c \
			./debug.h \
			./mycomplex.h \
			./myvector.h \
			./gausslup.h \
			./returns.h \
			./matrixops.h \
			./epsilon.h \
			./matrix.h \
			$(ENDLIST)

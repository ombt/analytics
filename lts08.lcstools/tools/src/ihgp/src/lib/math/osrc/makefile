
.SUFFIXES:		.o .c

LEXFLAGS = -n
YACC = yacc
YACCFLAGS = -d -v
LEX = lex
MAKE = make
LDFLAGS = -g
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g
INCLDIRS = 
CC = CC
AR = ar
ENDLIST = 

.c.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<

all:		tcroutlup \
		tvector \
		tmatrix \
		tgausslup \
		tcomplex \
		tlup \
		tepsilon \
		tmatrixops \
		$(ENDLIST)
		touch all

tcroutlup:		tcroutlup.o \
		croutlup.o \
		matrix.o \
		vector.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tcroutlup \
			tcroutlup.o \
			croutlup.o \
			matrix.o \
			vector.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tvector:		tvector.o \
		vector.o \
		complex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tvector \
			tvector.o \
			vector.o \
			complex.o \
			-lm \
			$(ENDLIST)

tmatrix:		tmatrix.o \
		matrix.o \
		vector.o \
		complex.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tmatrix \
			tmatrix.o \
			matrix.o \
			vector.o \
			complex.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tgausslup:		tgausslup.o \
		gausslup.o \
		matrix.o \
		vector.o \
		epsilon.o \
		complex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tgausslup \
			tgausslup.o \
			gausslup.o \
			matrix.o \
			vector.o \
			epsilon.o \
			complex.o \
			-lm \
			$(ENDLIST)

tcomplex:		tcomplex.o \
		complex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tcomplex \
			tcomplex.o \
			complex.o \
			-lm \
			$(ENDLIST)

tlup:		tlup.o \
		lup.o \
		matrix.o \
		vector.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tlup \
			tlup.o \
			lup.o \
			matrix.o \
			vector.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tepsilon:		tepsilon.o \
		epsilon.o \
		complex.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tepsilon \
			tepsilon.o \
			epsilon.o \
			complex.o \
			-lm \
			$(ENDLIST)

tmatrixops:		tmatrixops.o \
		matrixops.o \
		matrix.o \
		vector.o \
		complex.o \
		epsilon.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tmatrixops \
			tmatrixops.o \
			matrixops.o \
			matrix.o \
			vector.o \
			complex.o \
			epsilon.o \
			-lm \
			$(ENDLIST)

tmatrixops.o:	tmatrixops.c \
		./complex.h \
		./debug.h \
		./returns.h \
		./matrix.h \
		./epsilon.h \
		./vector.h \
		./matrixops.h \
		$(ENDLIST)

tcroutlup.o:	tcroutlup.c \
		./lup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

vector.o:	vector.c \
		./vector.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

lup.o:	lup.c \
		./lup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

gausslup.o:	gausslup.c \
		./gausslup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

matrixops.o:	matrixops.c \
		./matrixops.h \
		./debug.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

tgausslup.o:	tgausslup.c \
		./gausslup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

tlup.o:	tlup.c \
		./lup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

tmatrix.o:	tmatrix.c \
		./matrix.h \
		./debug.h \
		./epsilon.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

epsilon.o:	epsilon.c \
		./epsilon.h \
		$(ENDLIST)

tepsilon.o:	tepsilon.c \
		./complex.h \
		./debug.h \
		./returns.h \
		./epsilon.h \
		$(ENDLIST)

croutlup.o:	croutlup.c \
		./lup.h \
		./debug.h \
		./epsilon.h \
		./matrix.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

matrix.o:	matrix.c \
		./matrix.h \
		./debug.h \
		./epsilon.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

complex.o:	complex.c \
		./complex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tcomplex.o:	tcomplex.c \
		./complex.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tvector.o:	tvector.c \
		./complex.h \
		./debug.h \
		./returns.h \
		./vector.h \
		$(ENDLIST)

clean:
		-rm -rf Templates.DB
		-rm -f tcroutlup
		-rm -f tvector
		-rm -f tmatrix
		-rm -f tgausslup
		-rm -f tcomplex
		-rm -f tlup
		-rm -f tepsilon
		-rm -f tmatrixops
		-rm -f tmatrixops.o
		-rm -f tcroutlup.o
		-rm -f vector.o
		-rm -f lup.o
		-rm -f gausslup.o
		-rm -f matrixops.o
		-rm -f tgausslup.o
		-rm -f tlup.o
		-rm -f tmatrix.o
		-rm -f epsilon.o
		-rm -f tepsilon.o
		-rm -f croutlup.o
		-rm -f matrix.o
		-rm -f complex.o
		-rm -f tcomplex.o
		-rm -f tvector.o

backup:		tmatrixops.c \
		tcroutlup.c \
		vector.c \
		lup.c \
		gausslup.c \
		matrixops.c \
		tgausslup.c \
		tlup.c \
		tmatrix.c \
		epsilon.c \
		tepsilon.c \
		croutlup.c \
		matrix.c \
		complex.c \
		tcomplex.c \
		tvector.c \
		./complex.h \
		./debug.h \
		./vector.h \
		./lup.h \
		./gausslup.h \
		./returns.h \
		./matrixops.h \
		./epsilon.h \
		./matrix.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp tmatrixops.c $(BACKUPDIR)/tmatrixops.c
		cp tcroutlup.c $(BACKUPDIR)/tcroutlup.c
		cp vector.c $(BACKUPDIR)/vector.c
		cp lup.c $(BACKUPDIR)/lup.c
		cp gausslup.c $(BACKUPDIR)/gausslup.c
		cp matrixops.c $(BACKUPDIR)/matrixops.c
		cp tgausslup.c $(BACKUPDIR)/tgausslup.c
		cp tlup.c $(BACKUPDIR)/tlup.c
		cp tmatrix.c $(BACKUPDIR)/tmatrix.c
		cp epsilon.c $(BACKUPDIR)/epsilon.c
		cp tepsilon.c $(BACKUPDIR)/tepsilon.c
		cp croutlup.c $(BACKUPDIR)/croutlup.c
		cp matrix.c $(BACKUPDIR)/matrix.c
		cp complex.c $(BACKUPDIR)/complex.c
		cp tcomplex.c $(BACKUPDIR)/tcomplex.c
		cp tvector.c $(BACKUPDIR)/tvector.c
		cp ./complex.h ./$(BACKUPDIR)/complex.h
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./vector.h ./$(BACKUPDIR)/vector.h
		cp ./lup.h ./$(BACKUPDIR)/lup.h
		cp ./gausslup.h ./$(BACKUPDIR)/gausslup.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./matrixops.h ./$(BACKUPDIR)/matrixops.h
		cp ./epsilon.h ./$(BACKUPDIR)/epsilon.h
		cp ./matrix.h ./$(BACKUPDIR)/matrix.h
		touch backup

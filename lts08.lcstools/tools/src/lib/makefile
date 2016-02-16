
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = 
TCLBIN = $(HOME)/bin
LD = cc
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/tools/lib
ARFLAGS = -r -v
CCFLAGS = -g
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

all:		logging \
		checkretval \
		getoptval \
		local \
		mgcips \
		lcstelnet \
		lock \
		lcsftp \
		chooseone \
		checkenv \
		db \
		debug \
		$(ENDLIST)
		touch all

logging:		logging.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/logging
		-cp logging.sh logging
		chmod +x logging
		cp logging $(SHELLBIN)/logging

checkretval:		checkretval.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/checkretval
		-cp checkretval.sh checkretval
		chmod +x checkretval
		cp checkretval $(SHELLBIN)/checkretval

getoptval:		getoptval.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/getoptval
		-cp getoptval.sh getoptval
		chmod +x getoptval
		cp getoptval $(SHELLBIN)/getoptval

local:		local.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/local
		-cp local.sh local
		chmod +x local
		cp local $(SHELLBIN)/local

mgcips:		mgcips.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/mgcips
		-cp mgcips.sh mgcips
		chmod +x mgcips
		cp mgcips $(SHELLBIN)/mgcips

lcstelnet:		lcstelnet.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/lcstelnet
		-cp lcstelnet.sh lcstelnet
		chmod +x lcstelnet
		cp lcstelnet $(SHELLBIN)/lcstelnet

lock:		lock.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/lock
		-cp lock.sh lock
		chmod +x lock
		cp lock $(SHELLBIN)/lock

lcsftp:		lcsftp.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/lcsftp
		-cp lcsftp.sh lcsftp
		chmod +x lcsftp
		cp lcsftp $(SHELLBIN)/lcsftp

chooseone:		chooseone.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/chooseone
		-cp chooseone.sh chooseone
		chmod +x chooseone
		cp chooseone $(SHELLBIN)/chooseone

checkenv:		checkenv.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/checkenv
		-cp checkenv.sh checkenv
		chmod +x checkenv
		cp checkenv $(SHELLBIN)/checkenv

db:		db.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/db
		-cp db.sh db
		chmod +x db
		cp db $(SHELLBIN)/db

debug:		debug.sh \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/debug
		-cp debug.sh debug
		chmod +x debug
		cp debug $(SHELLBIN)/debug

clean:
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f logging
		-rm -f checkretval
		-rm -f getoptval
		-rm -f local
		-rm -f mgcips
		-rm -f lcstelnet
		-rm -f lock
		-rm -f lcsftp
		-rm -f chooseone
		-rm -f checkenv
		-rm -f db
		-rm -f debug

backup:		lcstelnet.sh \
		lcsftp.sh \
		getoptval.sh \
		checkretval.sh \
		mgcips.sh \
		logging.sh \
		local.sh \
		checkenv.sh \
		debug.sh \
		chooseone.sh \
		lock.sh \
		db.sh \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp lcstelnet.sh $(BACKUPDIR)/lcstelnet.sh
		cp lcsftp.sh $(BACKUPDIR)/lcsftp.sh
		cp getoptval.sh $(BACKUPDIR)/getoptval.sh
		cp checkretval.sh $(BACKUPDIR)/checkretval.sh
		cp mgcips.sh $(BACKUPDIR)/mgcips.sh
		cp logging.sh $(BACKUPDIR)/logging.sh
		cp local.sh $(BACKUPDIR)/local.sh
		cp checkenv.sh $(BACKUPDIR)/checkenv.sh
		cp debug.sh $(BACKUPDIR)/debug.sh
		cp chooseone.sh $(BACKUPDIR)/chooseone.sh
		cp lock.sh $(BACKUPDIR)/lock.sh
		cp db.sh $(BACKUPDIR)/db.sh
		touch backup

backupd:		lcstelnet.sh \
		lcsftp.sh \
		getoptval.sh \
		checkretval.sh \
		mgcips.sh \
		logging.sh \
		local.sh \
		checkenv.sh \
		debug.sh \
		chooseone.sh \
		lock.sh \
		db.sh \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		backup -d
		touch backupd

mymk:
		mymk

print:		lcstelnet.sh \
		lcsftp.sh \
		getoptval.sh \
		checkretval.sh \
		mgcips.sh \
		logging.sh \
		local.sh \
		checkenv.sh \
		debug.sh \
		chooseone.sh \
		lock.sh \
		db.sh \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			lcstelnet.sh \
			lcsftp.sh \
			getoptval.sh \
			checkretval.sh \
			mgcips.sh \
			logging.sh \
			local.sh \
			checkenv.sh \
			debug.sh \
			chooseone.sh \
			lock.sh \
			db.sh \
			$(ENDLIST)

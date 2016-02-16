
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = 
TCLBIN = $(LCSHUGLIB)
LD = cc
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
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

all:		checkenv.tcl \
		getoptval.tcl \
		logging.tcl \
		$(ENDLIST)
		touch all

checkenv.tcl:		checkenv.TCL \
		$(ENDLIST)
		-rm -f $(TCLBIN)/checkenv.tcl
		-cp checkenv.TCL checkenv.tcl
		chmod +x checkenv.tcl
		cp checkenv.tcl $(TCLBIN)/checkenv.tcl
		auto_mkindex $(LCSHUGLIB) '*.tcl'

getoptval.tcl:		getoptval.TCL \
		$(ENDLIST)
		-rm -f $(TCLBIN)/getoptval.tcl
		-cp getoptval.TCL getoptval.tcl
		chmod +x getoptval.tcl
		cp getoptval.tcl $(TCLBIN)/getoptval.tcl
		auto_mkindex $(LCSHUGLIB) '*.tcl'

logging.tcl:		logging.TCL \
		$(ENDLIST)
		-rm -f $(TCLBIN)/logging.tcl
		-cp logging.TCL logging.tcl
		chmod +x logging.tcl
		cp logging.tcl $(TCLBIN)/logging.tcl
		auto_mkindex $(LCSHUGLIB) '*.tcl'

clean:
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f checkenv.tcl
		-rm -f getoptval.tcl
		-rm -f logging.tcl

backup:		getoptval.TCL \
		logging.TCL \
		checkenv.TCL \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp getoptval.TCL $(BACKUPDIR)/getoptval.TCL
		cp logging.TCL $(BACKUPDIR)/logging.TCL
		cp checkenv.TCL $(BACKUPDIR)/checkenv.TCL
		touch backup

print:		getoptval.TCL \
		logging.TCL \
		checkenv.TCL \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			getoptval.TCL \
			logging.TCL \
			checkenv.TCL \
			$(ENDLIST)

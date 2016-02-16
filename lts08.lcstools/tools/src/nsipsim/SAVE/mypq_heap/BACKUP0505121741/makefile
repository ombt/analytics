
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = 
LD = cc
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/tools/bin
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

all:		tpq \
		mypqueue.pm \
		mytimer.pm \
		tpq2 \
		nsipsim \
		$(ENDLIST)
		touch all

tpq:		tpq.PL \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/tpq
		-cp tpq.PL tpq
		chmod +x tpq
		cp tpq $(SHELLBIN)/tpq

mypqueue.pm:		mypqueue.PM \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/mypqueue.pm
		-cp mypqueue.PM mypqueue.pm
		chmod +x mypqueue.pm
		cp mypqueue.pm $(SHELLBIN)/mypqueue.pm
		-(rcp mypqueue.PM root@135.1.235.58:/NSIPSIM/src)

mytimer.pm:		mytimer.PM \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/mytimer.pm
		-cp mytimer.PM mytimer.pm
		chmod +x mytimer.pm
		cp mytimer.pm $(SHELLBIN)/mytimer.pm
		-(rcp mytimer.PM root@135.1.235.58:/NSIPSIM/src)

tpq2:		tpq2.PL \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/tpq2
		-cp tpq2.PL tpq2
		chmod +x tpq2
		cp tpq2 $(SHELLBIN)/tpq2

nsipsim:		nsipsim.PL \
		$(ENDLIST)
		-rm -f $(SHELLBIN)/nsipsim
		-cp nsipsim.PL nsipsim
		chmod +x nsipsim
		cp nsipsim $(SHELLBIN)/nsipsim
		-(sed "s?/opt/exp/bin/perl?/opt/OV/bin/Perl/bin/perl?" nsipsim.PL >/tmp/remotensipsim.PL)
		-(sed "s?/home/lcstools/tools/bin?/NSIPSIM/bin?" /tmp/remotensipsim.PL >/tmp/remotensipsim2.PL)
		-(rcp /tmp/remotensipsim2.PL root@135.1.235.58:/NSIPSIM/src/nsipsim.PL)

clean:
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f tpq
		-rm -f mypqueue.pm
		-rm -f mytimer.pm
		-rm -f tpq2
		-rm -f nsipsim

backup:		nsipsim.PL \
		tpq.PL \
		mytimer.PM \
		tpq2.PL \
		mypqueue.PM \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp nsipsim.PL $(BACKUPDIR)/nsipsim.PL
		cp tpq.PL $(BACKUPDIR)/tpq.PL
		cp mytimer.PM $(BACKUPDIR)/mytimer.PM
		cp tpq2.PL $(BACKUPDIR)/tpq2.PL
		cp mypqueue.PM $(BACKUPDIR)/mypqueue.PM
		touch backup

print:		nsipsim.PL \
		tpq.PL \
		mytimer.PM \
		tpq2.PL \
		mypqueue.PM \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			nsipsim.PL \
			tpq.PL \
			mytimer.PM \
			tpq2.PL \
			mypqueue.PM \
			$(ENDLIST)

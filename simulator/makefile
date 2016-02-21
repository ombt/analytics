#
# LNB simulator make file.
#

ifndef LNB_SIM_ROOT
$(error LNB_SIM_ROOT is not set)
endif

ifndef LNB_SIM_SRC
$(error LNB_SIM_SRC is not set)
endif

ifndef LNB_SIM_BIN
$(error LNB_SIM_BIN is not set)
endif

ifndef LNB_SIM_LIBSRC
$(error LNB_SIM_LIBSRC is not set)
endif

ifndef LNB_SIM_LIB
$(error LNB_SIM_LIB is not set)
endif

bin/%.pl : src/%.PL
	cp $< $@
	chmod 755 $@

lib/%.pm : libsrc/%.PM
	cp $< $@
	chmod 755 $@

all:	bin/lnbsim.pl lib/mypqueue.pm lib/mytimer.pm

bin/lnbsim.pl:		src/lnbsim.PL

lib/mypqueue.pm:	libsrc/mypqueue.PM

lib/mytimer.pm:		libsrc/mytimer.PM

clean:
	-(rm bin/*);
	-(rm lib/*);

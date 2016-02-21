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

$(LNB_SIM_BIN)/%.pl : src/%.PL
	cp $< $@
	chmod 755 $@

$(LNB_SIM_LIB)/%.pm : libsrc/%.PM
	cp $< $@
	chmod 755 $@

all:	\
	$(LNB_SIM_BIN)/lnbsim.pl \
	$(LNB_SIM_LIB)/mypqueue.pm \
	$(LNB_SIM_LIB)/mytimer.pm

$(LNB_SIM_BIN)/lnbsim.pl:	src/lnbsim.PL

$(LNB_SIM_LIB)/mypqueue.pm:	libsrc/mypqueue.PM

$(LNB_SIM_LIB)/mytimer.pm:	libsrc/mytimer.PM

clean:
	-(rm -f $(LNB_SIM_BIN)/*);
	-(rm -f $(LNB_SIM_LIB)/*);

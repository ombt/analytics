#!/usr/bin/perl -w
#
# LNB simulator using log files as input
#
########################################################################
#
use strict;
#
########################################################################
#
# set up include paths to all the modules used in simulator.
#
BEGIN {
    die $! unless (exists($ENV{LNB_SIM_LIB}));
    unshift @INC, $ENV{LNB_SIM_LIB};
    die $! unless (exists($ENV{LNB_SIM_BIN}));
    unshift @INC, $ENV{LNB_SIM_BIN};
}
#
# include perl mods
#
use Getopt::Std;
#
# include sim mods
#
use mytimer;
use mypqueue;
#
########################################################################
#
########################################################################
#
exit 0;


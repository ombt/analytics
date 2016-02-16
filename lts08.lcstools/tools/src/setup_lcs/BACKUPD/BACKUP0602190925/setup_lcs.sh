#
# set up environment for LCS in lab.
#
export LCSTOOLS=/home/lcstools
export LCSINTEG=/home/lcsinteg
#
export LCSTOOLSBIN=$LCSTOOLS/tools/bin
export LCSTOOLSTL1SCRIPTS=$LCSTOOLS/tools/tl1scripts
export LCSTOOLSLIB=$LCSTOOLS/tools/lib
export LCSTOOLSQ=$LCSTOOLS/tools/queue
export SIPSIMHOME=$LCSTOOLS/tools
#
# case "$(/usr/bin/logname)" in
# lcstools)
	export LCSTOOLSDATA=$LCSTOOLS/tools/data
	# ;;
# *)
	# export LCSTOOLSDATA=$LCSINTEG/data
	# ;;
# esac
#
echo
echo "LCSTOOLS=$LCSTOOLS"
echo "LCSTOOLSBIN=$LCSTOOLSBIN"
echo "LCSTOOLSTL1SCRIPTS=$LCSTOOLSTL1SCRIPTS"
echo "LCSTOOLSDATA=$LCSTOOLSDATA"
echo "LCSTOOLSLIB=$LCSTOOLSLIB"
echo "LCSTOOLSQ=$LCSTOOLSQ"
#
export LCSTEXT=/lcsl100/text
export LCSBASESCRIPTS=/lcsl100/basescripts
export LCSBASETEMPLATES=/lcsl100/basetemplates
export LCSSCRIPTS=/lcsl100/scripts
export LCSHWSCRIPTS=/lcsl100/hwscripts
export LCSDATA=/lcsl100/data
#
echo
echo "LCSTEXT=$LCSTEXT"
echo "LCSBASESCRIPTS=$LCSBASESCRIPTS"
echo "LCSSCRIPTS=$LCSSCRIPTS"
echo "LCSHWSCRIPTS=$LCSHWSCRIPTS"
echo "LCSBASETEMPLATES=$LCSBASETEMPLATES"
echo "LCSDATA=$LCSDATA"
#
export LCSHUGLIB=$LCSTOOLSLIB/hug
export LCSHUGBIN=$LCSTOOLSBIN/hug
export LCSHUGDATA=$LCSTOOLSDATA/hug
export LCSHUGLOGFILES=$LCSTOOLS/tools/src/hug/logfiles
#
echo
echo "LCSHUGLIB=$LCSHUGLIB"
echo "LCSHUGBIN=$LCSHUGBIN"
echo "LCSHUGDATA=$LCSHUGDATA"
echo "LCSHUGLOGFILES=$LCSHUGLOGFILES"
#
export TOOLS=~exptools
export EXPTOOLS=~exptools
export PATH=$LCSTOOLS/tools/bin:$LCSTOOLS/tools/bin/hug:/usr/sbin:$PATH:~exptools/bin:~exptools/lib/unity/bin
#
echo
echo "PATH=$PATH"
#

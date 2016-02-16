#
# set up environment for LCS in lab.
#
export LCSTOOLS=/home/lcstools
export LCSINTEG=/home/lcsinteg
#
export LCSTOOLSBIN=$LCSTOOLS/tools/bin
export LCSTOOLSLYNXBIN=$LCSTOOLS/tools/lynx/bin
export LCSTOOLSTL1SCRIPTS=$LCSTOOLS/tools/tl1scripts
export LCSTOOLSLIB=$LCSTOOLS/tools/lib
export LCSTOOLSQ=$LCSTOOLS/tools/queue
export SIPSIMHOME=$LCSTOOLS/tools
#
export LCSTOOLSFPATH=$LCSTOOLS/tools/fbin
FPATH="${FPATH}:${LCSTOOLSFPATH}"
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
echo "LCSTOOLSLYNXBIN=$LCSTOOLSLYNXBIN"
echo "LCSTOOLSTL1SCRIPTS=$LCSTOOLSTL1SCRIPTS"
echo "LCSTOOLSDATA=$LCSTOOLSDATA"
echo "LCSTOOLSLIB=$LCSTOOLSLIB"
echo "LCSTOOLSQ=$LCSTOOLSQ"
echo "LCSTOOLSFPATH=$LCSTOOLSFPATH"
#
export LCSTEXT=/lcsl100/text
export LCSBASESCRIPTS=/lcsl100/basescripts
export LCSBASETEMPLATES=/lcsl100/basetemplates
export LCSSCRIPTS=/lcsl100/scripts
export LCSHWSCRIPTS=/lcsl100/hwscripts
export LCSDATA=/lcsl100/data
export LCSTMP=/lcsl100/tmp
#
echo
echo "LCSTEXT=$LCSTEXT"
echo "LCSBASESCRIPTS=$LCSBASESCRIPTS"
echo "LCSSCRIPTS=$LCSSCRIPTS"
echo "LCSHWSCRIPTS=$LCSHWSCRIPTS"
echo "LCSBASETEMPLATES=$LCSBASETEMPLATES"
echo "LCSDATA=$LCSDATA"
#
export LCSHUGLIB=$LCSTOOLS/tools/hug/lib
export LCSHUGBIN=$LCSTOOLS/tools/hug/bin
#
# do this for now since for HUG testing I need the lab data.
#
# export LCSHUGDATA=$LCSTOOLS/tools/hug/data
# 
export LCSHUGDATA=$LCSTOOLSDATA
#
export LCSHUGLOGFILES=$LCSTOOLS/tools/hug/logfiles
export LCSHUGQ=$LCSTOOLS/tools/hug/queue
export LCSHUGSCRIPTS=$LCSTOOLS/tools/src/hug/scripts
export LCSHUGTMP=/lcsl100/tmp
#
echo
echo "LCSHUGLIB=$LCSHUGLIB"
echo "LCSHUGBIN=$LCSHUGBIN"
echo "LCSHUGDATA=$LCSHUGDATA"
echo "LCSHUGLOGFILES=$LCSHUGLOGFILES"
echo "LCSHUGTMP=$LCSHUGTMP"
#
export TOOLS=~exptools
export EXPTOOLS=~exptools
export PATH=$LCSTOOLS/tools/bin:$LCSHUGBIN:/usr/sbin:$PATH:~exptools/bin:~exptools/lib/unity/bin
#
echo
echo "PATH=$PATH"
#

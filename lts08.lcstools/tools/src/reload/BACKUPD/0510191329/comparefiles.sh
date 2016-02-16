#!/usr/bin/ksh
# set -x
#
# compare local files in a CPU load with what is on the SP.
#
#####################################################################
#
# local 
#
tfile="/tmp/t$$"
ttfile="/tmp/tt$$"
rfiles="/tmp/r$$"
lfiles="/tmp/l$$"
llfiles="/tmp/ll$$"
dfiles="/tmp/d$$"
#
# remote data
#
labid="${1}"
sp="${2}"
cpuload="${3}"
remotefile="${4}"
audtype="${5}"
verbose="${6}"
#
echo
echo "Lab ID is ${labid}."
echo "SP is ${sp}."
echo "CPU Load is ${cpuload}."
echo "Remote File is ${remotefile}."
echo "Audit Type is ${audtype}."
#
# filter remote data into a useable form.
#
cat $remotefile |
cut -c20-33,47- | 
sed 's/^  *//g; s/  */ /g;' | 
nawk '{ print $2 " " $1; }' |
sort +0 -1 | 
uniq >$rfiles
#
# get list of local files associated with the CPU load.
#
if [[ -z "$LCSTOOLSDATA" ]]
then
	echo
	echo "LCSTOOLSDATA not set."
	exit 2
fi
if [[ ! -d "$LCSTOOLSDATA" ]]
then
	echo
	echo "LCSTOOLSDATA $LCSTOOLSDATA is not a directory."
	exit 2
fi
#
cd $LCSTOOLSDATA
#
branch=$(uprintf -q -f"%s\n" branch in labloads where cpuload leq "$cpuload" and labid leq "$labid")
if [[ -z "$branch" ]]
then
	echo
	echo "Unable to determine BRANCH for CPU load $cpuload."
	exit 2
fi
echo
echo "Branch is $branch."
#
uprintf -q -f"%s %s\n" type name in images where cpuload leq "$cpuload" and branch leq "$branch" >$tfile
#
case "${audtype}" in
cpu)
	grep cpu $tfile >$ttfile
	mv $ttfile $tfile
	;;
iom)
	grep -v cpu $tfile >$ttfile
	mv $ttfile $tfile
	;;
esac
#
>$lfiles
#
cat $tfile |
while read stype fname
do
	fpath="/lcsl100/text/$branch/$stype/$fname"
	tocfdir="/lcsl100/toc/$branch/$stype"
	tocfpath="/lcsl100/toc/$branch/$stype/$fname.toc"
	#
	echo
	echo "Checking $fpath ..."
	#
	if [[ -r "$fpath" ]]
	then
		[[ "${verbose}" == 1 ]] && echo
		[[ "${verbose}" == 1 ]] && echo "File $fpath is readable ..."
		[[ "${verbose}" == 1 ]] && echo "Checking if TOC exists for tar file:"
		[[ "${verbose}" == 1 ]] && echo "==>> $fpath"
		#
		[[ ! -d "$tocfdir" ]] && mkdir -p $tocfdir;
		#
		if [[ "$tocfpath" -nt "$fpath" ]]
		then
			echo "Using existing TOC ..."
			cat $tocfpath >>$lfiles
		else
			echo "Creating new TOC ..."
			/opt/exp/gnu/bin/tar tzvf $fpath | 
			grep -v -- "->" |
			grep -v "^d" >$tocfpath
			chmod 777 $tocfpath
			cat $tocfpath >>$lfiles
		fi
	else
		echo
		echo "$fpath is NOT readable ..."
	fi
done
#
cat $lfiles |
sed 's/  */ /g;' |
cut -d ' ' -f3,6 |
nawk '{ print $2 " " $1; }' |
sed 's/^/\//g;' |
sort +0 -1 | 
uniq >$llfiles
#
echo
echo "========================================================================"
echo "Comparing Load $cpuload Files To $labid $sp $cpuload files."
echo
comm -23 $llfiles $rfiles >$dfiles
#
if [[ -s "$dfiles" ]]
then
	cat $dfiles
else
	echo "No differences found."
fi
echo "========================================================================"
#
rm -f /tmp/*$$ 2>/dev/null 1>/dev/null
#
exit 0


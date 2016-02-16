#!/usr/bin/ksh
# copy scripts from basescripts directory to scripts directory for 
# provisioning.
#
#########################################################################
#
export CMD=$(basename ${0})
#
usage="\n
usage: ${CMD} [-?x] frombranch tobranch tocpuload labid [labid ...]
\n
where \n
\t-? - print usage message \n
\t-x - debug \n
\n
"
#
set -- $(getopt ?xa ${*})
if [[ ${?} -ne 0 ]]
then
	echo $usage
	exit 2
fi
#
for i in ${*}
do
	case "${i}" in
	-x)
		set -x
		shift
		;;
	--)
		shift
		break
		;;
	esac
done
#
cd ${LCSTOOLSDATA}
#
if [[ $# < 4 ]]
then
	echo "ERROR: Not enough parameters were given."
	echo $usage
	exit 2
fi
#
fromrelease=${1}
torelease=${2}
toload=${3}
shift 3
#
for fromlabid in ${*}
do
	# leave this here. we reset the directory below.
	cd ${LCSTOOLSDATA}
	#
	echo
	echo "Copying from ${fromlabid}/${fromrelease} ..."
	echo
	#
	tolabid=${fromlabid}
	#
	echo
	echo "Base Scripts From : ${fromlabid}/${fromrelease}"
	echo "Copying Scripts To: ${torelease}/${toload}/${tolabid}"
	echo
	#
	from="${LCSBASESCRIPTS}/${fromlabid}/${fromrelease}/current"
	to="${LCSSCRIPTS}/${torelease}/${toload}/${tolabid}"
	#
	if [[ ! -d "${from}" ]]
	then
		echo 
		echo "'From' directory ${from} does not exist." 
		echo "Continue to next labid."
		echo 
		continue
	fi
	if [[ ! -d "${to}" ]]
	then
		echo 
		echo "'To' directory ${to} does not exist." 
		echo "Creating 'To' directory ${to}." 
		echo 
		mkdir -p ${to}
	fi
	#
	# check that scripts exist.
	#
	ls ${from}/* 2>/dev/null 1>/tmp/scripts$$
	if [[ ! -s "/tmp/scripts$$" ]]
	then
		echo 
		echo "'From' directory ${from} is empty." 
		echo "Continue to next labid."
		echo 
		continue
	fi
	#
	echo 
	echo "Exec'ing cp ${from}/* ${to} ..."
	cp ${from}/* ${to}
	#
	# update the hardware scripts
	#
	uprintf -q -f"<%s> %s\n" type name in images where branch req "^${torelease}$" and cpuload req "^${toload}$" | 
	sed 's/ \([^_][^_]*\)_.*$/ \1/' | 
	sed 's?^?s/?; s? ?/?; s?$?/;?;' |
	tee /tmp/sedcmds$$
	#
	cd ${to}
	#
	for script in *
	do
		sed -f /tmp/sedcmds$$ ${script} >/tmp/new${script}
		mv /tmp/new${script} ${script}
		chmod 777 ${script}
	done
	#
done
#
echo 
echo "${CMD} done."
#
rm -f /tmp/*$$ 1>/dev/null 2>&1
exit 0


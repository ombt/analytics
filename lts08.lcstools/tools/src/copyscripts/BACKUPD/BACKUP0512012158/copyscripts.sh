#!/usr/bin/ksh
# copy scripts from basescripts directory to scripts directory for 
# provisioning.
#
#########################################################################
#
export usagecmd=$(basename ${0})
#
usage="\n
usage: ${usagecmd} [-?x] [-a] \n
\n
where \n
\t-? - print usage message \n
\t-x - debug \n
\t-a - ask where to copy to \n
\n
"
#
ask=no
#
set -- $(getopt ?xa ${*})
if [[ ${?} -ne 0 ]]
then
	echo $usage >&2
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
	-a)
		ask=yes
		shift
		;;
	--)
		shift
		break
		;;
	esac
done
#
CMD=${0}
cd ${LCSTOOLSDATA}
#
echo
echo "'From' Lab and Release data from ${LCSTOOLSDATA}/chassis file."
echo "'To' Lab, Release, Load data from ${LCSTOOLSDATA}/labloads file."
echo
#
cat chassis |
cut -d'	' -f1,2 |
sed 's/[ 	]/__/' |
sort -u >/tmp/fromlabrelease$$
#
PS3="Choose a Lab and Release to copy base scripts from: "
#
select fromlabrelease in QUIT $(cat /tmp/fromlabrelease$$)
do
	case "${fromlabrelease}" in
	QUIT)
		echo "Quitting ${CMD}." >&2
		rm -f /tmp/*$$ 1>/dev/null 2>&1
		exit 0
		;;
	*)
		fromlabrelease=$(echo ${fromlabrelease} | sed 's/__/ /')
		break 2
		;;
	esac
done
#
set -- ${fromlabrelease}
fromlabid=${1}
fromrelease=${2}
#
echo
echo "Copying from ${fromlabid}/${fromrelease} ..."
echo
#
if [[ "${ask}" == yes ]]
then
	cat labloads |
	cut -d'	' -f1 |
	sort -u >/tmp/tolab$$
	#
	PS3="Choose a Lab to copy base scripts To: "
	#
	select tolabid in QUIT $(cat /tmp/tolab$$)
	do
		case "${tolabid}" in
		QUIT)
			echo "Quitting ${CMD}." >&2
			exit 0
			;;
		*)
			break 2
			;;
		esac
	done
else
	tolabid=${fromlabid}
fi
#
grep "	${fromrelease}	" labloads >/tmp/loads$$
if [[ ! -s "/tmp/loads$$" ]]
then
	echo
	echo "WARNING: No $fromrelease loads found for lab ${tolabid}."
	echo
	sleep 2
fi
#
cat labloads |
grep "^${tolabid}	" | 
cut -d'	' -f2,3 |
sed 's/[ 	]/__/' |
sort -u >/tmp/toreleaseload$$
#
PS3="Choose a ${tolabid} Release and Load to copy base scripts To: "
#
select toreleaseload in QUIT $(cat /tmp/toreleaseload$$)
do
	case "${toreleaseload}" in
	QUIT)
		echo "Quitting ${CMD}." >&2
		rm -f /tmp/*$$ 1>/dev/null 2>&1
		exit 0
		;;
	*)
		toreleaseload=$(echo ${toreleaseload} | sed 's/__/ /')
		break 2
		;;
	esac
done
#
set -- ${toreleaseload}
torelease=${1}
toload=${2}
#
# echo
# echo "Copying to ${tolabid}/${torelease}/${toload} ..."
# echo
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
	echo "'From' directory ${from} does not exist." >&2
	echo "${CMD} done."
	rm -f /tmp/*$$ 1>/dev/null 2>&1
	exit 2
fi
if [[ ! -d "${to}" ]]
then
	echo "'To' directory ${to} does not exist." >&2
	echo "Do you want to create it? [y/n/cr=n] \c"
	read YESNO
	case "${YESNO}" in
	y)
		mkdir -p ${to}
		;;
	*)
		echo "${CMD} done."
		rm -f /tmp/*$$ 1>/dev/null 2>&1
		exit 2
		;;
	esac

	
fi
#
# check that scripts exist.
#
ls ${from}/* 2>/dev/null 1>/tmp/scripts$$
if [[ ! -s "/tmp/scripts$$" ]]
then
	echo "'From' directory ${from} is empty." >&2
	echo "${CMD} done."
	rm -f /tmp/*$$ 1>/dev/null 2>&1
	exit 2
fi
#
echo "Exec'ing cp ${from}/* ${to} ..."
cp ${from}/* ${to}
#
echo "${CMD} done."
#
rm -f /tmp/*$$ 1>/dev/null 2>&1
exit 0


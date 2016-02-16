#!/usr/bin/ksh
#
# create TL1 scripts from base scripts that BBB can use.
#
#########################################################################
#
export usagecmd=$(basename ${0})
#
trap 'rm -f /tmp/*$$ 1>/dev/null 2>&1;' 0 1 2 15
#
allscripts="/tmp/allscripts$$"
hardware="/tmp/hardware$$"
iproute="/tmp/iproute$$"
cpymem="/tmp/cpymem$$"
calldata="/tmp/calldata$$"
trunk="/tmp/trunk$$"
#
usage () {
cat <<EOF
usage: ${usagecmd} [-?x] [-b branch[,branch[,...]]] [-L|[labid [labid ...]]]

where
	-? - print usage message
	-x - enable debug
	-b branch[,...] - create scripts for these branches.
	-A - create scripts for all labids.

create BBB scripts for the given list of labids. if a labid is not 
given, then use shell variable LABID. all scripts are created in the 
LCSSCRIPTS directory. if no branch is given, then all branches for a
lab are used.

EOF
#
return 0
}
#
makebbbscripts () {
	echo "\nSort scripts in ${1}: hardware, iproute, calldata, trunk"
	#
	cd ${1}
	#
	ls >${allscripts} 2>/dev/null
	#
	if [[ ! -s "${allscripts}" ]]
	then
		echo "\nWARNING: no scripts in ${1}."
		return 0
	fi
	#
	grep hardware ${allscripts} >${hardware}
	grep cpymem ${allscripts} >${cpymem}
	grep calldata ${allscripts} >${calldata}
	grep trunk ${allscripts} >${trunk}
	grep iproute ${allscripts} >${iproute}
	#
	return 0
}
#
alllabids=no
allbranches=no
userbranches=
#
set -- $(getopt ?xBb:L ${*})
if [[ ${?} -ne 0 ]]
then
	usage
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
	-L)
		alllabids=yes
		shift
		;;
	-B)
		allbranches=yes
		shift
		;;
	-b)
		userbranches="$(echo ${2} | tr ',' ' ')"
		shift 2
		;;
	--)
		shift
		break
		;;
	esac
done
#
echo "\nCreating BBB TL1 Scripts:"
#
if [[ -z "${LCSBASESCRIPTS}" ]]
then
	echo "\nERROR: LCSBASESCRIPTS is NOT set."
	exit 2
elif [[ ! -d "${LCSBASESCRIPTS}" ]]
then
	echo "\nERROR: ${LCSBASESCRIPTS} is NOT a directory."
	exit 2
fi
#
echo "\nBase Scripts Directory: ${LCSBASESCRIPTS}"
#
cd ${LCSBASESCRIPTS}
#
if [[ "${alllabids}" == yes ]]
then
	labids="$(ls -d * | tr '\n' ' ')"
elif [[ $# == 0 ]]
then
	labids="${LABID}"
else
	labids="${@}"
fi
#
if [[ -z "${labids}" ]]
then
	echo "\nERROR: No LABIDs given."
	exit 2
else
	echo "\nLabid(s): ${labids}"
fi
#
for labid in ${labids}
do
	# reset to basescripts base directory
	cd ${LCSBASESCRIPTS}
	# all paths are relative
	if [[ ! -d "${labid}" ]]
	then
		echo "\nWARNING: subdirectory ${labid} does not exist. Skipping it."
		continue
	fi
	#
	if [[ "${allbranches}" == yes || -z "${userbranches}" ]]
	then
		branches="$(ls -d ${labid}/* | cut -d/ -f2 | tr '\n' ' ')"
	else
		branches="${userbranches}"
	fi
	#
	for branch in ${branches}
	do
		scriptsdir=${labid}/${branch}/current
		if [[ ! -d "${scriptsdir}" ]]
		then
			echo "\nWARNING: skipping ${scriptsdir}."
			continue
		else
			echo "\nProcessing ${scriptsdir}:"
			makebbbscripts ${scriptsdir}
		fi
	done
done
#
exit 0


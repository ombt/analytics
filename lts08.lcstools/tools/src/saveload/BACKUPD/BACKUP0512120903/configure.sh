#!/usr/bin/ksh
#
# edit parameters for a load.
#
###############################################################################
#
CMD=$(basename ${0})
#
oper=none
newlabloads=/tmp/newlabloads$$
newlabloads2=/tmp/newlabloads2$$
#
usage() {
	echo
	echo "usage: $CMD [-x?] -a branch cpuload labid [labid ...]"
	echo "	or"
	echo "usage: $CMD [-x?] -d branch cpuload labid [labid ...]"
	echo "	or"
	echo "usage: $CMD [-x?] -b branch [branch ...]"
	echo "	or"
	echo "usage: $CMD [-x?] -c cpuload [cpuload ...]"
	echo "	or"
	echo "usage: $CMD [-x?] -l labid [labid ...]"
	echo
	echo "where:"
	echo "	-x - enable debug mode"
	echo "	-? - print usage message"
	echo "	-a - add branch/cpuload for reload of labid"
	echo "	-d - delete branch/cpuload for reload of labid"
	echo "	-b - list reload data filtered by branch"
	echo "	-c - list reload data filtered by cpuload"
	echo "	-l - list reload data filtered by labid"
	echo
	echo "the last option [-a|-d|-b|-c|-l] given takes precedence."
	echo
}
#
function add_to_reload {
	echo
	echo "Starting add_to_reload: ${*}"
	#
	if [[ $# -lt 3 ]]
	then
		echo
		echo "Missing parameters: branch, cpuload, labid [labid ...]"
		return 2
	fi
	#
	branch=${1}
	cpuload=${2}
	shift 2
	#
	# back up files before updating
	#
	backupdir="BACKUP/$(date '+%y%m%d%H%M%S')"
	[ ! -d ${backupdir} ] && mkdir -p ${backupdir};
	cp loads images labloads ${backupdir}
	#
	cp labloads $newlabloads
	#
	for labid in ${*}
	do
		echo
		echo "Adding $branch/$cpuload for reload of $labid."
		#
		echo "${labid}	${branch}	${cpuload}" >>$newlabloads
	done
	#
	cat $newlabloads | sort -u >labloads
	#
	return 0
}
#
function delete_from_reload {
	#
	echo
	echo "Starting delete_from_reload: ${*}"
	#
	if [[ $# -lt 3 ]]
	then
		echo
		echo "Missing parameters: branch, cpuload, labid [labid ...]"
		return 2
	fi
	#
	branch=${1}
	cpuload=${2}
	shift 2
	#
	# back up files before updating
	#
	backupdir="BACKUP/$(date '+%y%m%d%H%M%S')"
	[ ! -d ${backupdir} ] && mkdir -p ${backupdir};
	cp loads images labloads ${backupdir}
	#
	cp labloads $newlabloads
	#
	for labid in ${*}
	do
		echo
		echo "Deleting $branch/$cpuload from reload of $labid."
		grep -v "^${labid}	${branch}	${cpuload}$" $newlabloads >$newlabloads2
		mv $newlabloads2 $newlabloads
	done
	#
	cat $newlabloads | sort -u >labloads
	#
	return 0
}
#
function list_by_branch {
	echo
	echo "Starting list_by_branch: ${*}"
	#
	if [[ $# -lt 1 ]]
	then
		echo
		echo "Load data for all branches: "
		uprint loads 
		#
		echo
		echo "Lab Load data for all branches:"
		uprint labloads 
		return 0
	fi
	#
	for branch in ${*}
	do
		echo
		echo "Load data for branch $branch:"
		uprint loads where branch req "^$branch$"
		#
		echo
		echo "Lab Load data for branch $branch:"
		uprint labloads where branch req "^$branch$"
	done
	#
	return 0
}
#
function list_by_cpuload {
	echo
	echo "Starting list_by_cpuload: ${*}"
	#
	if [[ $# -lt 1 ]]
	then
		echo
		echo "Load data for all cpuloads: "
		uprint loads 
		#
		echo
		echo "Lab Load data for all cpuloads:"
		uprint labloads 
		return 0
	fi
	#
	for cpuload in ${*}
	do
		echo
		echo "Load data for cpuload $cpuload:"
		uprint loads where cpuload req "^$cpuload$"
		#
		echo
		echo "Lab Load data for cpuload $cpuload:"
		uprint labloads where cpuload req "^$cpuload$"
	done
	#
	return 0
}
#
function list_by_labid {
	echo
	echo "Starting list_by_labid: ${*}"
	#
	if [[ $# -lt 1 ]]
	then
		echo
		echo "Lab Load data for all labids:"
		uprint labloads 
		return 0
	fi
	#
	for labid in ${*}
	do
		echo
		echo "Lab Load data for labid $labid:"
		uprint labloads where labid req "^$labid$"
	done
	#
	return 0
}
#
function none {
	echo
	echo "Nothing to do."
	#
	usage
	#
	return 0
}
#
set -- $(getopt ?xadbcl ${*})
if [[ ${?} -ne 0 ]]
then
	usage
	exit 0
fi
#
for opt in ${*}
do
	case "${opt}" in
	-x)
		set -x
		shift
		;;
	-a)
		oper=add_to_reload
		shift
		;;
	-d)
		oper=delete_from_reload
		shift
		;;
	-b)
		oper=list_by_branch
		shift
		;;
	-c)
		oper=list_by_cpuload
		shift
		;;
	-l)
		oper=list_by_labid
		shift
		;;
	--)
		shift
		break
		;;
	esac
done
#
echo
echo "Starting LCS Configure Load"
#
if [[ -z "${LCSTOOLSDATA}" ]]
then
	echo
	echo "LCSTOOLSDATA not defined." >&2
	exit 2
fi
#
cd ${LCSTOOLSDATA}
#
${oper} ${*}
#
exit 0

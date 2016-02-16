#!/usr/bin/ksh
#
# remove an old load and update relations in a consistent manner.
#
###############################################################################
#
CMD=${0}
#
tmp=/tmp/tmp$$
loads=/tmp/loads$$
newloads=/tmp/newloads$$
newlabloads=/tmp/newlabloads$$
newimages=/tmp/newimages$$
filestoremove=/tmp/filestoremove$$
#
trap 'rm -f /tmp/*$$ 1>/dev/null 2>&1' 0 1 2 15
#
usage() {
	echo "usage: $CMD [-x?]"
	echo
	echo "where:"
	echo "	-x - enable debug mode"
	echo "	-? - print usage message"
}
#
set -- $(getopt ?x ${*})
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
	--)
		shift
		break
		;;
	esac
done
#
echo
echo "Starting LCS List Loads"
#
if [[ -z "${LCSTOOLSDATA}" ]]
then
	echo
	echo "LCSTOOLSDATA not defined." >&2
	exit 2
fi
#
# load to delete.
#
cd ${LCSTOOLSDATA}
#
uprintf -q -f"%s %s\n" branch cpuload in loads | 
sed 's/[	 ]/__/' |
sort -u >$loads
#
while [ 1 ]
do
	#
	echo
	PS3="Choose branch/load to list: "
	#
	select branchload in QUIT $(cat $loads)
	do
		case "${branchload}" in
		QUIT)
			echo "Exit $CMD."
			break 3
			;;
		*)
			branchload=$(echo $branchload | sed 's/__/ /')
			set -- ${branchload}
			branch=${1}
			load=${2}
			break
			;;
		esac
	done
	#
	echo
	echo "Branch/Load to list: $branch $load"
	#
	# uprint branch cpuload type name in images where branch leq "$branch" and cpuload leq "$load"
	uprint cpuload type name in images where branch leq "$branch" and cpuload leq "$load"
done
#
exit 0

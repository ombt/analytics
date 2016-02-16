#!/usr/bin/ksh
# du of LCS files systems.
#
export usagecmd=$(basename ${0})
#
trap 'rm -f /tmp/*$$ 1>/dev/null 2>&1;' 0 1 2 15
#
usage="\n
usage: ${usagecmd} [-?x] \n
\n
where \n
\t-? - print usage message \n
\t-x - debug \n
\n
"
#
set -- $(getopt ?x ${*})
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
	--)
		shift
		break
		;;
	esac
done
#
if [[ -z "${LCSTOOLSDATA}" ]]
then
	echo >&2
	echo "LCSTOOLSDATA is not set." >&2
	exit 2
fi
if [[ ! -d "${LCSTOOLSDATA}" ]]
then
	echo >&2
	echo "$LCSTOOLSDATA does not exist." >&2
	exit 2
fi
#
cd ${LCSTOOLSDATA}
#
uprintf -q -f"%s\n" path in filesystems | 
sort -u |
while read fs
do
	/usr/bin/du -sk ${fs}
done
#
exit 0

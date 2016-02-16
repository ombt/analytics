#!/usr/bin/ksh
#
# send email to report command status.
#
###############################################################################
#
CMD=${0}
#
branch=${1}
operation=${2}
reason=${3}
subject=${4}
msg=${5}
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
addresses=$(uselect -q addresses from notification where branch req "^${branch}$" and operation req "^${operation}$" and reason req "^${reason}$")
#
# echo "sending email: <$branch> <$operation> <$reason> <$msg> <$addresses>"
/usr/bin/mailx -s "$subject" $addresses <<EOF
$msg
EOF
#
exit 0

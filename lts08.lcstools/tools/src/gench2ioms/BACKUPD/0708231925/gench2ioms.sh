#!/usr/bin/ksh
#
# generate relation chassis2ioms for a list of switches (labids).
#
#########################################################################
#
CMD=$(basename ${0})
PATH=$PATH:/opt/exp/lib/unity/bin
#
rtrvout=/tmp/rtrvout$$
clei=/tmp/clei$$
labcleis=/tmp/labcleis$$
labiomcleis=/tmp/labiomcleis$$
username=telica
passwd=telica
#
trap 'rm -rf /tmp/*$$ 1>/dev/null 2>&1' 0 1 2 3 4 5 6 15
#
usage() {
cat <<EOF

usage: ${CMD} [-?] [-x] [-a] [-o outfile] [-u username] [-p passwd]
	[-b branch[,branch2[,...]]] [labid [labid2 ...] ]

where:
	-x - debug
	-? - usage message
	-a - run for all labs in chassis relation
	-o filename - output file name
	-u username - TL1 user name (default is telica)
	-p passwd - TL1 passwd (default is telica)
	-b branch[,branch2[,..]]] - comma-separated list of branches

labid of switch to scan and determine iom cleis. all output
is to standard out. variable LABID is used by default.

EOF
}
#
alllabids=no
branches=
outfile=
#
set -- `getopt ?axb:o: ${*}`
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
	-a)
		alllabids=yes
		shift
		;;
	-b)
		branches="$(echo ${2} | tr ',' ' ')"
		shift 2
		;;
	-o)
		outfile=${2}
		shift 2
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
if [[ "${alllabids}" == yes ]]
then
	set -- $(uprintf -q -f"%s\n" labid in chassis | sort -u)
elif [[ $# == 0 ]]
then
	if [[ -n "${LABID}" ]]
	then
		set -- ${LABID}
	else
		echo
		echo "ERROR: LABID is not set and no labid was given."
		usage
		exit 2
	fi
fi
#
if [[ -z "${branches}" ]]
then
	PS3="Choose a branch: "
	select branch in QUIT $(cat ${LCSTOOLSDATA}/chassis | cut -d'	' -f2 | sort -u)
	do
		case "${branch}" in
		QUIT)
			echo "Exit ${CMD}."
			exit 0
			;;
		*)
			break 1
			;;
		esac
	done
	#
	branches=${branch}
fi
#
if [[ -n "${outfile}" ]]
then
	>${outfile}
fi
#
echo
echo "Using branch(es): ${branches}."
#
for labid in ${*}
do
	echo
	echo "Using RTRV-EQPT-ALL to get ${labid} IOM CLEIS:"
	echo
	#
	>${labcleis}
	#
	tl1 -u ${username} -p ${passwd} -l ${labid} RTRV-EQPT-ALL 2>/dev/null |
	tr '[A-Z]' '[a-z]' |
	sed -n 's/^.*iom-\([0-9][0-9]*\):.*iomoduletype=\([^,:]*\).*rearmoduletype=\([^,:]*\).*$/<\1> <\2> <\3>/p' >${labiomcleis}
	#
	for branch in ${branches}
	do
		cat ${labiomcleis} |
		nawk 'BEGIN {
			labid = "'"${labid}"'";
			branch = "'"${branch}"'";
			cleifile = "'"${LCSTOOLSDATA}/ncleis"'";
			#
			while (getline tuple < cleifile > 0)
			{
				split(tuple, fields, /\t/);
				filebranch = fields[1];
				fileclei = fields[2];
				filerearclei = fields[3];
				fileisrearreq = fields[4];
				filetype = fields[5];
				cleis[filebranch,fileclei,filerearclei] = filetype;
			}
		}
		$1 ~ /<[0-9]+>/ && $2 != /<>/ {
			# get iom and front clei
			iom = substr($1,2,length($1)-2);
			# check if we have a clei
			if (length($2) > 2) {
				clei = substr($2,2,length($2)-2);
			} else {
				# iom is not provisioned
				next;
			}
			# check if we have a rear clei
			if (length($3) > 2) {
				rearclei = substr($3,2,length($3)-2);
			} else {
				rearclei = "none";
			}
			# determine iom type
			if ((branch,clei,rearclei) in cleis) {
				type = cleis[branch,clei,rearclei];
			} else if (("default",clei,rearclei) in cleis) {
				type = cleis["default",clei,rearclei];
			} else if ((branch,clei,"none") in cleis) {
				type = cleis[branch,clei,"none"];
			} else if (("default",clei,"none") in cleis) {
				type = cleis["default",clei,"none"];
			} else {
				type = "UNKNOWN";
			}
			# print results
			printf("%s\t", labid);
			printf("%s\t", branch);
			printf("%s\t", iom);
			printf("%s\n", type);
			#
			printf("%s\t", labid) >> "/dev/tty";
			printf("%s\t", branch) >> "/dev/tty";
			printf("%s\t", iom) >> "/dev/tty";
			printf("%s\n", type) >> "/dev/tty";
			next;
		}
		END {
		} ' 
	done >>${labcleis}
	#
	# check if we found anything
	#
	if [[ ! -s "${labcleis}" ]]
	then
		echo
		echo "WARNING: No IOM/CLEIS found for labid ${labid}"
	elif [[ -n "${outfile}" ]]
	then
		cat ${labcleis} >>${outfile}
	fi
done
#
exit 0



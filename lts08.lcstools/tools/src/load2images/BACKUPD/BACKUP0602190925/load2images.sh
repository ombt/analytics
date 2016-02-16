#
# get a list of images for a given: branch, branch type and type of
# image. the allowed branch types are: dev and beta.  the supported
#  list of image types is: all, cpu, ... whatever.
#
############################################################################
#
# tmp files
#
tmp=/tmp/tmp$$
tmp2=/tmp/tmp2$$
supported=/tmp/supported$$
required=/tmp/required$$
requiredfiles=/tmp/requiredfiles$$
files=/tmp/files$$
sortedfiles=/tmp/sortedfiles$$
#
trap 'rm -f /tmp/*$$ 1>/dev/null 2>&1;' 0 1 2
#
lflag=no
usage="usage: ${0} [-?xl] branch branchtype imagetype"
#
# supported image file types.
#
cat >$supported <<EOF
ana
atmds3
cm
cpu
ds1_2
ds1
ds3
e1
ena2
ena
octds3_2
octds3_3
octds3
pna
tdmoc
trids3_3
trids3
voip6
voip
vs3
EOF
#
# cmd line options
#
set -- $(getopt ?xl ${*})
if [[ $? != 0 ]]
then
	echo "ERROR: invalid option, ${usage}."
	exit 2
fi
#
for opt in ${*}
do
	case "${opt}" in
	-x)
		set -x 
		shift
		;;
	-l)
		lflag=yes
		shift
		;;
	--)
		shift
		break
		;;
	esac
done
#
branch="${1}"
branchtype="${2}"
imagetype="${3}"
#
# echo
# echo "Starting ${0}: branch=<$branch>, type=<$branchtype>, image=<$imagetype>"
# echo "${0} Args: <${*}>"
# echo
#
# sanity check
#
if [[ -z "${branch}" ]]
then
	echo "ERROR: branch is not given."
	exit 2
fi
if [[ -z "${branchtype}" ]]
then
	echo "ERROR: branch type is not given."
	exit 2
fi
if [[ -z "${imagetype}" ]]
then
	echo "ERROR: image type is not given."
	exit 2
fi
#
case "${branchtype}" in
dev)
	# ok
	;;
beta)
	# ok
	;;
*)
	# not supported
	echo "ERROR: branch type <${branchtype}> is not supported."
	exit 2
	;;
esac
#
if [[ "$imagetype" == "all" ]]
then
	cp $supported $required
else
	grep "^${imagetype}$" $supported >$required
	#
	if [[ $? != 0 ]]
	then
		echo "ERROR: image type ${imagetype} is not supported."
		exit 2
	fi
fi
#
# generate list of files and filter by type.
#
case "${branchtype}" in
dev)
	roots="/telica/toaster/home/release/${branch}"
	;;
beta)
	# search under release/ECO and newpatches
	ecobranch="${branch#BP-}"
	#
	roots="/home2/builder/newpatches/${branch}"
	roots="${roots} /telica/toaster/home/release/ECO/${ecobranch} /telica/toaster/home/release/ECO/${ecobranch}-*"
	;;
*)
	# not supported
	echo "ERROR: branch type ${branchtype} is not supported."
	exit 2
	;;
esac
#
cat $required | sed 's/^/_/; s/$/.tar.gz/' >$requiredfiles
#
for root in ${roots}
do
	find $root -type f -name '*.tar.gz' -print 2>/dev/null |
	grep -f $requiredfiles
done >$files
#
if [[ ! -s "${files}" ]]
then
	echo "ERROR: No files found for type: ${imagetype}."
	exit 2
fi
#
# sort the files by time stamp
#
cat $supported |
while read imagetype
do
	echo "_${imagetype}.tar.gz" >$tmp
	grep -f $tmp $files >$tmp2
	#
	if [[ -s "${tmp2}" ]]
	then
		if [[ "${lflag}" == yes  ]]
		then
			ls -t $(cat ${tmp2}) |
			sed -n "s/^/${imagetype} /p" |
			sed -n "1,1p"
		else 
			ls -t $(cat ${tmp2}) |
			sed -n "s/^/${imagetype} /p"
		fi
	else
		echo "${imagetype} NONE"
	fi
done > $sortedfiles
#
cat $sortedfiles
#
exit 0

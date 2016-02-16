if [[ $# == 0 ]]
then
	set -- ${LABID}
elif [[ ${1} == "-?" ]]
then
	echo "usage: ${0} [-?] [labid] [labid ...]"
	exit 0
fi
#
cd ${LCSTOOLSDATA}
#
for labid in ${*}
do
	uprint -h "Loads available for reload of ${labid}:" labloads where labid req ${labid}
done
#
exit 0

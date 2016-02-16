# get SP IPs for the given labid.
verbose=no
all=no
usage="usage: ${0} [-?] [-x] [-V] [-a | [labid [...]]]"
#
set -- $(getopt ?axV ${*})
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
	-V)
		verbose=yes
		shift
		;;
	-a)
		all=yes
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
if [[ "${all}" == yes ]]
then
	case "${verbose}" in
	yes)
		uprint labid cpu_a_ip cpu_b_ip in chassis 
		;;
	*)
		uprintf -q -f'%s %s %s\n' labid cpu_a_ip cpu_b_ip in chassis
		;;
	esac
	#
	exit 0
fi
#
if [[ $# == 0 ]]
then
	set -- ${LABID}
fi
#
case "${verbose}" in
yes)
	for labid in ${*}
	do
		uprint labid cpu_a_ip cpu_b_ip in chassis where labid req "^$labid$"
	done
	;;
*)
	for labid in ${*}
	do
		uprintf -q -f'%s %s %s\n' labid cpu_a_ip cpu_b_ip in chassis where labid req "^$labid$"
	done
	;;
esac
#
exit 0

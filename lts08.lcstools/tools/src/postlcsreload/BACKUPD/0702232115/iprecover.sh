# simple script to recover IP connectivity.
#
inter=${1:-"mgt0"}
ip=${2}
#
ipfile=/Telica/dbCurrent/Telica_IP
if [[ ! -r "${ipfile}" ]]
then
	echo "IP file ${ipfile} does not exist." >&2
	exit 2
fi
#
interip=$(grep "${inter}_ip=" ${ipfile} | cut -d'=' -f2)
if [[ -z "${interip}" ]]
then
	echo "Unable to determine ${inter} IP from IP file ${ipfile}." >&2
	exit 2
fi
#
if [[ -n "${ip}" ]]
then
	interip=$(echo ${interip} | sed "s/\.0 *$/\.${ip}/;")
	if [[ -z "${interip}" ]]
	then
		echo "Unable to update ${inter} IP ${interip} to ${ip}." >&2
		exit 2
	fi
	echo "Updated ${inter} IP is ${interip}."
fi
#
defaultgw=$(grep 'default_gw=' ${ipfile} | cut -d'=' -f2)
if [[ -z "${defaultgw}" ]]
then
	echo "Unable to determine default gw IP from IP file ${ipfile}." >&2
	exit 2
fi
#
mgt0_netmask=$(grep 'mgt0_netmask=' ${ipfile} | cut -d'=' -f2)
if [[ -z "${defaultgw}" ]]
then
	echo "Unable to determine mgt0 NET MASK from IP file ${ipfile}." >&2
	exit 2
fi
# remove interface, if any.
ifconfig ${inter} delete
route -n delete default
# add interface, if any.
/bin/ifconfig ${inter} ${interip} netmask ${mgt0_netmask}
/bin/route -n add default -net ${defaultgw}
#
exit 0

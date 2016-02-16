# simple script to recover IP connectivity.
#
ipfile=/Telica/dbCurrent/Telica_IP
if [[ ! -r "${ipfile}" ]]
then
	echo "IP file ${ipfile} does not exist." >&2
	exit 2
fi
#
mgt0ip=$(grep 'mgt0_ip=' ${ipfile} | cut -d'=' -f2)
if [[ -z "${mgt0ip}" ]]
then
	echo "Unable to determine mgt0 IP from IP file ${ipfile}." >&2
	exit 2
fi
#
defaultgw=$(grep 'default_gw=' ${ipfile} | cut -d'=' -f2)
if [[ -z "${defaultgw}" ]]
then
	echo "Unable to determine default gw IP from IP file ${ipfile}." >&2
	exit 2
fi
#
/bin/ifconfig mgt0 ${mgt0ip} netmask 255.255.255.0
/bin/route -n add default -net ${defaultgw}
#
exit 0

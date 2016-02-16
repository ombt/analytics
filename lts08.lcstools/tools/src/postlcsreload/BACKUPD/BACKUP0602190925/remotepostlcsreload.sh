# script to tweak certain files for lab
#
##########################################################################
#
cmd=${0}
#
addhosts=
labmode=
disablediskcleanup=
cpymemnum=
motdlabid=
#
usage () {
	echo "
	usage: ${cmd} [-x] [-h] [-s|-d] [-C|-D] [-c num] [-m labid]

	where:

	-x - set debug mode.
	-s - split the lab.
	-d - duplex the lab.
	-C - enable Disk Clean Up.
	-D - disable Disk Clean Up.
	-h - add extra entries to /etc/hosts.
	-c num - maximum number of simultaneous Cpy-Mems.
	-m labid - update /etc/motd with CPU load and LABID.
	
"
	#
	return 0
}
#
while getopts '?xsdhCDc:m:' opt
do
	case "${opt}" in
	x)
		set -x
		;;
	s)
		echo "LAB will be simplex."
		labmode=simplex
		AllowReset=0
		AllowReboot=0
		IgnorePartnerSp=1
		;;
	d)
		echo "LAB will be duplex."
		labmode=duplex
		AllowReset=1
		AllowReboot=1
		IgnorePartnerSp=0
		;;
	h)
		echo "Adding extra machines to /etc/hosts."
		addhosts=yes
		;;
	C)
		echo "Enabling Disk Clean Up."
		disablediskcleanup=0
		;;
	D)
		echo "Disabling Disk Clean Up."
		disablediskcleanup=1
		;;
	m)
		motdlabid="${OPTARG}"
		echo "Setting MOTD LABID to ${motdlabid}."
		;;
	c)
		cpymemnum="${OPTARG}"
		if [[ $(echo "${cpymemnum}" | grep -c '^[0-9][0-9]*$') -eq 0 ]]
		then
			echo >&2
			echo "ERROR: -c option requires a number." >&2
			exit 2
		fi
		echo "Setting number of simultaneous Cpy-Mems to ${cpymemnum}."
		;;
	\?)
		usage >&2
		exit 0
		;;
	esac
done
#
# do we update the hosts files?
#
if [[ -n "${addhosts}" ]]
then
	#
	# check /etc/hosts file
	#
	echo "Adding additional ips/hosts to /etc/hosts file ..."
	#
	if [[ ! -r "/etc/hosts" ]]
	then
		echo "ERROR: /etc/hosts file is not readable." >&2
		exit 2
	fi
	#
	# remove old references
	#
	cat /etc/hosts |
	grep -v "lts08" |
	grep -v "lcsbld" |
	grep -v "chibuild" |
	grep -v "ohbuild" |
	grep -v "build[0-9]" |
	grep -v "xtm8[0-9]*" |
	grep -v "ihgp"  >/etc/newhosts
	#
	# add references to X-terms, labs, build, and GP machines.
	#
	cat >> /etc/newhosts <<EOF
135.111.82.6	lts08 lts08.ih.lucent.com
135.1.218.100	ihgp ihgp.ih.lucent.com
135.4.64.50	chibuild chibuild.telica.com
135.111.82.15	lcsbld1 lcsbld1.ih.lucent.com
135.4.64.50	chibuild chibuild.telica.com
135.4.64.49	ohbuild ohbuild.telica.com
135.1.64.31	build2 build2.telica.com
135.1.64.33	build3 build3.telica.com
192.168.38.5	xtm800
192.168.38.6	xtm801
192.168.38.7	xtm802
192.168.38.8	xtm803
192.168.38.9	xtm804
192.168.38.10	xtm805
192.168.38.11	xtm806
192.168.38.12	xtm807
192.168.38.13	xtm808
192.168.38.14	xtm809
192.168.38.15	xtm810
192.168.38.16	xtm811
192.168.38.17	xtm812
192.168.38.18	xtm813
192.168.38.19	xtm814
EOF
	#
	# leave this here for 3.X loads. see below for the 
	# 5.X details.
	#
	mv /etc/newhosts /etc/hosts
	chmod 644 /etc/hosts
	#
	# added this for 5.3 on 10/3/2005. the telica.rc.network
	# script removes /etc/hosts and recreates it using this
	# file.
	#
	cat > /Telica/dbCurrent/local_hosts <<EOF
135.111.82.6	lts08 lts08.ih.lucent.com
135.1.218.100	ihgp ihgp.ih.lucent.com
135.4.64.50	chibuild chibuild.telica.com
135.111.82.15	lcsbld1 lcsbld1.ih.lucent.com
135.4.64.50	chibuild chibuild.telica.com
135.4.64.49	ohbuild ohbuild.telica.com
135.1.64.31	build2 build2.telica.com
135.1.64.33	build3 build3.telica.com
192.168.38.5	xtm800
192.168.38.6	xtm801
192.168.38.7	xtm802
192.168.38.8	xtm803
192.168.38.9	xtm804
192.168.38.10	xtm805
192.168.38.11	xtm806
192.168.38.12	xtm807
192.168.38.13	xtm808
192.168.38.14	xtm809
192.168.38.15	xtm810
192.168.38.16	xtm811
192.168.38.17	xtm812
192.168.38.18	xtm813
192.168.38.19	xtm814
EOF
	#
	chmod 644 /Telica/dbCurrent/local_hosts
else
	echo "NO changes to /etc/hosts."
fi
#
# update disk clean up flags.
#
if [[ -n "${disablediskcleanup}" ]]
then
	echo "Changing DisableDiskCleanup to ${disablediskcleanup} ..."
	if [[ ! -r "/Telica/swCPU/CurrRel/schema/debug.xml" ]]
	then
		echo "ERROR: /Telica/swCPU/CurrRel/schema/debug.xml does not exists." >&2
		exit 2
	fi
	#
	cat /Telica/swCPU/CurrRel/schema/debug.xml |
	sed "/COL.*DisableDiskCleanup/ {
		s/> *[0-9][0-9]* *</>${disablediskcleanup}</;
	}" > /Telica/swCPU/CurrRel/schema/newdebug.xml
	mv /Telica/swCPU/CurrRel/schema/newdebug.xml /Telica/swCPU/CurrRel/schema/debug.xml
else
	echo "NO changes for DisableDiskCleanup ..."
fi
#
# simplex or duplex the SP.
#
if [[ -n "${labmode}" ]]
then
	echo "Changing Lab Mode to ${labmode} ..."
	if [[ ! -r "/Telica/swCPU/CurrRel/schema/debug.xml" ]]
	then
		echo "ERROR: /Telica/swCPU/CurrRel/schema/debug.xml does not exists." >&2
		exit 2
	fi
	#
	cat /Telica/swCPU/CurrRel/schema/debug.xml |
	sed "/COL.*AllowReset/ {
		s/> *[0-9][0-9]* *</>${AllowReset}</;
	}" | sed "/COL.*AllowReboot/ {
		s/> *[0-9][0-9]* *</>${AllowReboot}</;
	}" | sed "/COL.*IgnorePartnerSp/ {
		s/> *[0-9][0-9]* *</>${IgnorePartnerSp}</;
	}" > /Telica/swCPU/CurrRel/schema/newdebug.xml
	mv /Telica/swCPU/CurrRel/schema/newdebug.xml /Telica/swCPU/CurrRel/schema/debug.xml
else
	echo "NO changes to Lab Mode ..."
fi
#
# update the allowed number of simultaneous CPY-MEMs
#
if [[ -n "${cpymemnum}" ]]
then
	echo "Changing CpyMem number to ${cpymemnum} ..."
	if [[ ! -r "/Telica/swCPU/CurrRel/schema/localSpCfgDb.xml" ]]
	then
		echo "ERROR: /Telica/swCPU/CurrRel/schema/localSpCfgDb.xml does not exists." >&2
		exit 2
	fi
	#
	cat /Telica/swCPU/CurrRel/schema/localSpCfgDb.xml |
	sed "/COL.*NumCpyMem/,/> *[0-9][0-9]* *</ {
		s/> *[0-9][0-9]* *</>${cpymemnum}</;
	}" > /Telica/swCPU/CurrRel/schema/newlocalSpCfgDb.xml
	mv /Telica/swCPU/CurrRel/schema/newlocalSpCfgDb.xml /Telica/swCPU/CurrRel/schema/localSpCfgDb.xml
else
	echo "NO changes to Cpy-Mem ..."
fi
#
# update MOTD with LABID and LOAD.
#
if [[ -n "${motdlabid}" ]]
then
	echo "Updating MOTD to ${motdlabid} ..."
	#
	grep "\*" /etc/motd >/etc/newmotd
	echo >> /etc/newmotd
	# /bin/banner ${motdlabid} >> /etc/newmotd
	echo ${motdlabid} >> /etc/newmotd
	echo >> /etc/newmotd
	#
	if [[ -d "/Telica/swCPU/CurrRel" ]]
	then
		cd /Telica/swCPU
		currel=$(ls -l CurrRel | cut -d'>' -f2 | cut -d'/' -f4)
		# /bin/banner ${currel} >> /etc/newmotd
		echo ${currel} >> /etc/newmotd
		echo >> /etc/newmotd
	fi
	#
	mv /etc/newmotd /etc/motd
else
	echo "NO changes to MOTD ..."
fi
#
exit 0


#
# copy scripts to individual directories for reload.
#
#############################################################################
#
cmd=${0}
#
if [[ -z "${1}" ]]
then
	echo "No directory given. Exit."
	exit 2
elif [[ ! -d "${1}" ]]
then
	echo "Path ${1} is not a directory or is not readable. Exit."
	exit 2
fi
#
cd ${1}
#
currdir=$(pwd)
distdir=$(echo $currdir | sed 's?/scripts/?/distscripts/?')
#
set -- $(echo ${distdir} | sed 's?/? ?g;')
branch=${3}
cpuload=${4}
labid=${5}
#
echo
echo "Distribute Scripts for:"
echo
echo "Labid  : $labid"
echo "Branch : $branch"
echo "Cpuload: $cpuload"
echo
echo "Distributing scripts:"
echo
echo "From: ${currdir}"
echo "To  : ${distdir}"
#
if [[ ! -d "${distdir}" ]]
then
	echo
	echo "Creating directory ${distdir}."
	mkdir -p ${distdir}
fi
#
for script in *
do
	if [[ -d "${script}" ]]
	then 
		echo
		echo "Skipping directory ${f} ..."
	fi
	#
	case "${script}" in
	*calldata*)
		echo
		echo "Call Data script: $script"
		grep -i '^[^#]*init-sys:' $script 1>/dev/null
		if [[ ${?} == 0 ]]
		then
			echo
			echo "Script $script contains an init-sys cmd."
		fi
		;;
	*hardware*)
		echo
		echo "Hardware script: $script"
		grep -i '^[^#]*init-sys:' $script 1>/dev/null
		if [[ ${?} == 0 ]]
		then
			echo
			echo "Script $script contains an init-sys cmd."
		fi
		;;
	*prov_linefeats*)
		echo
		echo "Provision Line Features script: $script"
		grep -i '^[^#]*init-sys:' $script 1>/dev/null
		if [[ ${?} == 0 ]]
		then
			echo
			echo "Script $script contains an init-sys cmd."
		fi
		;;
	*iproute*)
		echo
		echo "IP Route script: $script"
		grep -i '^[^#]*init-sys:' $script 1>/dev/null
		if [[ ${?} == 0 ]]
		then
			echo
			echo "Script $script contains an init-sys cmd."
		fi
		;;
	users)
		echo
		echo "Users script: $script"
		;;
	*cpymem*|*copymem*)
		echo
		echo "Copy Mem script: $script"
		;;
	*)
		echo
		echo "Unknown type of script: $script"
		;;
	esac
done
#
exit 0

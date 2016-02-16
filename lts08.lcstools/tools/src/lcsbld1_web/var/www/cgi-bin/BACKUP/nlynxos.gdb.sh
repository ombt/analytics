#!/bin/bash
#
while getopts '?xe' opt
do
	case "${opt}" in
	x)
		set -x
		shift 1
		;;
	\?)
		echo "usage: ${0} [-?] [-x] branch load debugfile corefile"
		exit 0
		;;
	esac
done
#
echo "Starting GDB:"
#
branch=${1}
load=${2}
debugfile=${3}
corefile=${4}
#
echo 
echo "Branch: $branch"
echo "Load  : $load"
echo "Debug : $debugfile"
echo "Core  : $corefile"
#
echo "Who Am I: $(id)"
#
root=/tmp/cvs$$
#
mkdir $root
cd $root
#
if [[ "${branch}" != Main ]]
then
	branchoption="-r ${branch}"
fi
#
if [[ -z "${CVSROOT}" ]]
then
	export CVSROOT=":pserver:builder@stein.telica.com:/cvs/cvsroot/Repository"
fi
#
cvs co ${branchoption} TelicaRoot/TelicaUpdate
#
cvs update -d ${branchoption} -l TelicaRoot/components
cvs update -P -d -l ${branchoption} TelicaRoot/components/lynx
#
cd TelicaRoot/components/lynx
source ./SETUP.bash
#
if [[ -z "${HOME}" ]]
then
	export HOME="/etc/httpd/home"
fi
#
/var/www/cgi-bin/lynxos.gdb.tcl ${debugfile} ${corefile}
#
cd /tmp
rm -rf $root
#
exit 0
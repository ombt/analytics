#!/bin/bash
#
# batch mode
#
: ${DB_SERVER:?"is NOT set."}
: ${DB_PORT_NO:?"is NOT set."}
: ${DB_NAME:?"is NOT set."}
#
errlog="/tmp/el.$$"
#
rmfiles() {
    rm -f ${errlog} 2>/dev/null 1>&1
}
#
trap 'rmfiles' 0
#
usage() {
cat >&2 <<EOF

usage: $0 [-?] [-x] [-d] [-c] [-O | -o outfile] sql.script [...]"

where:
	-? = print usage message
	-x = shell debug
	-d = pg debug
	-c = clean output
	-o outfile = output to given file
	-O = generate output file name from sql file name (add .out)

EOF
}
#
dflag=0
outfile=
Oflag=0
cflag=0
cflagopts="--quiet"
#
set -- $(getopt Ocdxo: ${*} 2>${errlog})
if [[ -s "${errlog}" ]]
then
	echo -e "\nERROR: invalid option" >&2
	cat ${errlog} >&2
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
	-d)
		dflag=1
		shift
		;;
	-c)
		cflag=1
		cflagopts="--quiet --no-align"
		shift
		;;
	-o)
		Oflag=0
		outfile="${2}"
		>${outfile}
		shift 2
		;;
	-O)
		outfile=
		Oflag=1
		shift
		;;
	--)
		shift
		break
		;;
	esac
done
#
if [[ $# == 0 ]]
then
	usage
	exit 0
fi
#
if [[ ! -z "${outfile}" ]]
then
	echo "OUTFILE: ${outfile}"
fi
#
for f in "${@}"
do
	echo "SCRIPT: $f"
	#
	if [[ ${Oflag} == 1 ]]
	then
		outfile="${f}.out"
		>${outfile}
		echo "OUTFILE: ${outfile}"
	fi
	#
	if [[ ! -z "${outfile}" ]]
	then
		echo "SCRIPT: $f" >> ${outfile}
	fi
	#
	cat > /tmp/$$.sql <<EOF
\pset footer off
\pset pager off
EOF
	#
	cat $f >> /tmp/$$.sql
	#
	if [[ ${dflag} == 0 ]]
	then
		if [[ -z "${outfile}" ]]
		then
			psql -h ${DB_SERVER} \
			     -p ${DB_PORT_NO} \
			     -d ${DB_NAME} \
			     -U cim ${cflagopts} \
			     -f /tmp/$$.sql 2>&1 
		else
			psql -h ${DB_SERVER} \
			     -p ${DB_PORT_NO} \
			     -d ${DB_NAME} \
			     -U cim ${cflagopts} \
			     -f /tmp/$$.sql >> ${outfile} 2>&1
		fi
	else
		if [[ -z "${outfile}" ]]
		then
			psql -h ${DB_SERVER} \
			     -p ${DB_PORT_NO} \
			     -d ${DB_NAME} \
			     -U cim ${cflagopts} \
			     -f /tmp/$$.sql 2>&1 
		else
			psql -h ${DB_SERVER} \
			     -p ${DB_PORT_NO} \
			     -d ${DB_NAME} \
			     -U cim ${cflagopts} \
			     -f /tmp/$$.sql >> ${outfile} 2>&1
		fi
	fi
done
#
exit 0

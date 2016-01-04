#!/bin/bash
#
#########################################################################
#
# basic sanity checks
#
: ${DB_SERVER:?"is NOT set."}
: ${DB_PORT_NO:?"is NOT set."}
: ${DB_NAME:?"is NOT set."}
#
# Calgary Time !!!
#
TZ="Canada/Mountain"
export TZ
#
#########################################################################
#
# functions
#
my_bsql () {
    #
    infile=${1}
    outfile=${2}
    #
    if [[ ! -r "${infile}" ]]
    then
        echo -e "\nERROR: SQL file ${infile} is NOT READABLE. Exiting."
        exit 2
    fi
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: Output file was NOT GIVEN. Exiting."
        exit 2
    fi
    #
    echo -e "\nSQL IN : ${infile}"
    echo -e "SQL OUT: ${outfile}"
    #
    cat >/tmp/$$.sql <<EOF
USE ${DB_NAME};
GO
EOF
    #
    cat ${infile} >>/tmp/$$.sql
    #
    cat >>/tmp/$$.sql <<EOF
GO
BYE
EOF
    #
    tsql -H ${DB_SERVER} -p ${DB_PORT_NO} -U cim -P cim < /tmp/$$.sql 2>&1 |
    sed -e "s|[0-9][0-9]*> ||g" \
        -e "s|(return status = 0)||g" \
        -e "s|local.*$||g" \
        -e "s|[	 ]*$||g" |
    grep -v "^[	 ]*$" > ${outfile}
    #
    return 0
}
#
#######################################################################
#
# sql commands
#
MGMT_FILES_USED_SQL="/tmp/$$.mfu.sql"
#
cat > ${MGMT_FILES_USED_SQL} <<EOF
select
    -- zhr.report_file as zhr_file
    zhr.report_file
from
    z_cass_header_raw zhr
inner join
    z_cass_header zh
on
    zhr.report_id = zh.report_id
and
    zhr.equipment_id = zh.equipment_id
and
    zhr.lane_no = zh.lane_no
order by
    zhr.equipment_id asc,
    zhr.lane_no asc,
    zhr.report_id asc
go
EOF
#
#########################################################################
#
MGMT_FILES_USED_SQL_OUT="${MGMT_FILES_USED_SQL}.out"
my_bsql ${MGMT_FILES_USED_SQL} ${MGMT_FILES_USED_SQL_OUT}
#
USEDFILES="/tmp/usedfiles.$$"
cat ${MGMT_FILES_USED_SQL_OUT} | 
sort > ${USEDFILES}
#
ALLFILESWITHPATH="/tmp/allfileswithpath.$$"
find /cimuser/mrumore/archive/field_problems/bwtech/cells/L[12]*/quar*/spc*/proce* -type f -print > ${ALLFILESWITHPATH}
#
ALLFILES="/tmp/allfiles.$$"
find /cimuser/mrumore/archive/field_problems/bwtech/cells/L[12]*/quar*/spc*/proce* -type f -print |
cut -d/ -f13 |
sort > ${ALLFILES}
#
echo -e "\nUsed Files:"
comm -12 ${USEDFILES} ${ALLFILES} | 
xargs -I '{ }' grep '{ }' ${ALLFILESWITHPATH} |
grep '2015040[67]'
#
echo -e "\nNot Used Files:"
comm -13 ${USEDFILES} ${ALLFILES} |
xargs -I '{ }' grep '{ }' ${ALLFILESWITHPATH} |
grep '2015040[67]'
#
echo -e "\nUsed Files Counts By Date:"
comm -12 ${USEDFILES} ${ALLFILES} | 
xargs -I '{ }' grep '{ }' ${ALLFILESWITHPATH} |
cut -d/ -f12 |
sort |
uniq -c |
grep '2015040[67]'
#
echo -e "\nNot Used Files Counts By Date:"
comm -13 ${USEDFILES} ${ALLFILES} |
xargs -I '{ }' grep '{ }' ${ALLFILESWITHPATH} |
cut -d/ -f12 |
sort |
uniq -c |
grep '2015040[67]'
#
echo -e "\nTotal Files Counts By Date:"
cat ${ALLFILESWITHPATH} |
cut -d/ -f12 |
sort |
uniq -c |
grep '2015040[67]'
#
exit 0

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
# some notes
#
# z_cass_header mgmt_report_id
# z_cass_header report_id
# z_cass_header product_id
# z_cass_header equipment_id
# z_cass_header lane_no
# z_cass_header start_time
# z_cass_header end_time
# z_cass_header setup_id
# z_cass_header nc_version
# z_cass_header job_id
# z_cass_header report_file
# 
# z_cass report_id
# z_cass cassette
# z_cass slot
# z_cass subslot
# z_cass comp_id
# z_cass reel_id
# z_cass feeder_id
# z_cass stocked
# z_cass remaining
# z_cass comp_exhaust
# z_cass pickup_count
# z_cass place_count
# z_cass pickup_error_count
# z_cass pickup_miss_count
# z_cass recog_error_count
# z_cass shape_error_count
# z_cass height_miss_count
# z_cass coplanarity
# z_cass need_for_current_product
# z_cass other_error_count
# z_cass colinearity_count
# z_cass pickup_attempt_count
# z_cass place_search_attempt_count
# z_cass place_search_failure_count
# z_cass vision_failures
# z_cass initial_part_count
# z_cass used_parts_count
# z_cass table_no
# z_cass table_slot
# z_cass table_subslot
# z_cass primary_pn
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
Z_CASS_RAW_SQL="/tmp/$$.zcr.sql"
#
cat > ${Z_CASS_RAW_SQL} <<EOF
select
    -- zhr.mgmt_report_id            as zhr_mgmt_report_id,
    -- zhr.product_id                as zhr_product_id,
    zhr.equipment_id              as zhr_equipment_id,
    -- zhr.lane_no                   as zhr_lane_no,
    -- zhr.report_id                 as zhr_report_id,
    -- zhr.start_time                as zhr_start_time,
    zhr.end_time                  as zhr_end_time,
    zr.table_no                   as zr_table_no,
    zr.table_slot                 as zr_table_slot,
    zr.table_subslot              as zr_table_subslot,
    -- zhr.setup_id                  as zhr_setup_id,
    -- zhr.nc_version                as zhr_nc_version,
    -- zhr.job_id                    as zhr_job_id,
    -- zhr.report_file               as zhr_report_file,
    -- zr.report_id                  as zr_report_id,
    -- zr.cassette                   as zr_cassette,
    zr.slot                       as zr_slot,
    zr.subslot                    as zr_subslot,
    zr.comp_id                    as zr_comp_id,
    -- zr.reel_id                    as zr_reel_id,
    -- zr.feeder_id                  as zr_feeder_id,
    -- zr.stocked                    as zr_stocked,
    -- zr.remaining                  as zr_remaining,
    -- zr.comp_exhaust               as zr_comp_exhaust,
    zr.pickup_count               as zr_pickup_count,
    -- zr.place_count                as zr_place_count,
    -- zr.pickup_error_count         as zr_pickup_error_count,
    zr.pickup_miss_count          as zr_pickup_miss_count,
    zr.recog_error_count          as zr_recog_error_count,
    zr.height_miss_count          as zr_height_miss_count
    -- zr.shape_error_count          as zr_shape_error_count,
    -- zr.coplanarity                as zr_coplanarity,
    -- zr.need_for_current_product   as zr_need_for_current_product,
    -- zr.other_error_count          as zr_other_error_count,
    -- zr.colinearity_count          as zr_colinearity_count,
    -- zr.pickup_attempt_count       as zr_pickup_attempt_count,
    -- zr.place_search_attempt_count as zr_place_search_attempt_count,
    -- zr.place_search_failure_count as zr_place_search_failure_count,
    -- zr.vision_failures            as zr_vision_failures,
    -- zr.initial_part_count         as zr_initial_part_count,
    -- zr.used_parts_count           as zr_used_parts_count,
    -- zr.primary_pn                 as zr_primary_pn
from
    z_cass_header_raw zhr
left join
    z_cass_raw zr
on
    zhr.report_id = zr.report_id
where
    zhr.end_time >= SQL_MIN_TIME
and
    zhr.end_time <= SQL_MAX_TIME
order by
    zhr.equipment_id asc,
    zhr.report_id asc,
    zr.table_no asc,
    zr.table_slot asc,
    zr.table_subslot asc
go
EOF
#
#########################################################################
#
# determine range of dates for audit.
#
SQLTIMES="/tmp/sqltm.$$"
> ${SQLTIMES}
#
for MACHINE in AB21DTP1_CM402 AB21DTP2_CM402
do
    echo -e "\nPT Log Files for Machine: ${MACHINE}"
    #
    MACHSQLTIMES="/tmp/machine.sqltm.$$"
    > ${MACHSQLTIMES}
    #
    ls ${MACHINE}*.log |
    grep -v _App_ |
    while read file
    do
        echo -e "\tPT Log File: $file"
	#
        YMD=$(echo $file |
              sed -e 's/\.log$//' \
                  -e 's/_/ /g' |
              cut -d' ' -f3-5 |
              sed 's/ /-/g')
        HMS=$(echo $file |
              sed -e 's/\.log$//' \
                  -e 's/_/ /g' |
              cut -d' ' -f6-8 |
              sed 's/ /:/g')
	echo -e "\tYMD: $YMD HMS: $HMS"
	#
	typeset -i TODAY_MIDNIGHT
        TODAY_MIDNIGHT=$(date -d "${YMD}" '+%s')
        #
	typeset -i TOMORROW_MIDNIGHT
	TOMORROW_MIDNIGHT=TODAY_MIDNIGHT+24*60*60
        echo -e "\t\tSTART: ${TODAY_MIDNIGHT}"
        echo -e "\t\tEND  : ${TOMORROW_MIDNIGHT}"
	#
        echo "${MACHINE} ${TODAY_MIDNIGHT} ${TOMORROW_MIDNIGHT}" >> ${MACHSQLTIMES}
    done
    #
    echo -e "\tAudit Times for Machine:"
    cat ${MACHSQLTIMES} |
    sort -u 
    #
    cat ${MACHSQLTIMES} |
    sort -u >> ${SQLTIMES}
done
#
echo -e "\nFinal Audit Times per Machine:"
cat ${SQLTIMES} 
#
MINSQLTIME=$(cat ${SQLTIMES} | cut -d' ' -f2 | sort -n | head -1)
MAXSQLTIME=$(cat ${SQLTIMES} | cut -d' ' -f3 | sort -n | tail -1)
#
echo -e "\nSQL MIN TIME: ${MINSQLTIME}\nSQL MAX TIME: ${MAXSQLTIME}"
#
TMPSQL="/tmp/sql.$$"
#
echo -e "\nGetting Z_CASS_RAW DB Data From ${MINSQLTIME} to ${MAXSQLTIME}"
cat ${Z_CASS_RAW_SQL} |
sed -e "s/SQL_MIN_TIME/${MINSQLTIME}/g" \
    -e "s/SQL_MAX_TIME/${MAXSQLTIME}/g" > ${TMPSQL}
Z_CASS_RAW_SQL_OUT="${Z_CASS_RAW_SQL}.out"
time my_bsql ${TMPSQL} ${Z_CASS_RAW_SQL_OUT}
#
echo -e "\nGenerate DB data file to use in audit:"
#
DBFILE="/tmp/dbf.$$"
#
cat ${Z_CASS_RAW_SQL_OUT} |
grep -v 'zhr_equipment_id' |
sed 's/	/ /g' |
gawk '
{
    printf "%d %d T%1d%04d SS%d PC%d PM%d RE%d HM%d PN%s LN0\n",
          $1, $2, $3, $4, $5, $9, $10, $11, $12, $8;
} ' > ${DBFILE}
#
echo -e "\nGenerate PT log data file to use in audit:"
#
PTFILE="/tmp/ptf.$$"
#
ls AB21DTP* |
grep -v _App_ |
xargs -L1 cat |
sed -n 's/\r//gp' |
gawk 'BEGIN {
    rpm67 = 0;
    rmp = 0;
    date = "";
    machine = "";
}
/DATA OUT : RPM67/ {
    rpm67 = 1;
    next;
}
/<RAWMGMT_PACKAGE>/, /<\/RAWMGMT_PACKAGE>/ {
    rmp = 1;
    # FALL THRU
}
/<WM_FILE>/, /<\/WM_FILE>/ {
    # print "PRODUCTION " $0;
    next;
}
/<NM_FILE>/, /<\/NM_FILE>/ {
    # print "NOZZLE " $0;
    next;
}
/<PM_FILE>/, /<\/PM_FILE>/ {
    # printf "DATE ... <%s>\n", date;
    # printf "MACHINE ... <%s>\n", machine;
    if ($0 ~ /^T[0-9]/)
    {
        printf "%s %s %s\n", machine, date, $0;
    }
    else if ($0 ~ /^Date:/)
    {
        date = $0;
    }
    else if ($0 ~ /^Author:/)
    {
        machine = $0;
    }
    next;
}
{
    rpm67 = 0;
    rmp   = 0;
    date = "";
    machine = "";
    next;
}
END {
} ' |
sed -e 's/Author:AB21DTP1/1000/' \
    -e 's/Author:AB21DTP2/1002/' \
    -e 's/Date://' \
    -e 's/,/ /' \
    -e 's/SS/ SS/' \
    -e 's/PC/ PC/' \
    -e 's/PM/ PM/' \
    -e 's/RE/ RE/' \
    -e 's/HM/ HM/' \
    -e 's/PN/ PN/' \
    -e 's/LN/ LN/' |
sort -t' ' --key 1 --key 2,3 --key 4,5 | 
uniq > ${PTFILE}
#
echo -e "\nDB FILE: ${DBFILE}"
echo -e "PT FILE: ${PTFILE}"
#
exit 0
# 
# 
# 
# # FEEDER <PM_FILE>Format:ProductDat
# # FEEDER Version:3
# # FEEDER Machine:ProViewer
# # FEEDER Date:2015/02/06,16:02:57
# # FEEDER AuthorType:PT100CG
# # FEEDER Author:AB21DTP1
# # FEEDER T10002SS1PC21499PM2RE3HM0PNLN0
# # FEEDER T10002SS2PC21555PM4RE1HM0PNLN0
# # FEEDER T10003SS1PC44862PM22RE4HM0PNLN0
# # FEEDER T10003SS2PC46731PM13RE2HM0PNLN0
# # FEEDER T10004SS1PC89089PM20RE5HM0PNLN0
# # FEEDER T10004SS2PC87026PM35RE21HM0PNLN0
# # FEEDER T10005SS1PC88145PM73RE67HM0PN119055LN0
# # FEEDER T10005SS2PC84923PM22RE15HM0PN50104991-021LN0
# # FEEDER T10006SS1PC66344PM30RE4HM0PN113207LN0
# # FEEDER T10006SS2PC67715PM12RE11HM0PN103085LN0
# # FEEDER T10007SS1PC48947PM12RE4HM0PN110722LN0
# # FEEDER T10007SS2PC42271PM34RE3HM0PN136355LN0
# # FEEDER T10008SS1PC36382PM8RE17HM0PN110894LN0
# # FEEDER T10008SS2PC26800PM3RE2HM0PN102984LN0
#
exit 0

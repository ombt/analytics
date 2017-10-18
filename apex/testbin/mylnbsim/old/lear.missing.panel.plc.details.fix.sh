#!/bin/bash 
#
#########################################################################
#
# script to regenerate missing panel placement details:
#
# constraints:
#
# 1) Missing panel placement details data will be recovered only for 
#    panels which have a panel placement header record. 
# 2) Recovering missing panel placement details data requires that the 
#    MAI file to be available in the file history table. We need the 
#    MAI to determine the placements and the reference designators. 
# 3) Not all the panel placement details data may be recoverable, 
#    for example, custom area [1234] data.
# 4) Script is only for CMs.
# 5) Script is only for CMs supported by DGS.
#
# 6) Cells setup-id directories are *NOT* included in this version.
# 7) Limited to one CM per line for now.
#
#########################################################################
#
# basic sanity checks
#
: ${DB_SERVER:?"is NOT set."}
: ${DB_PORT_NO:?"is NOT set."}
: ${DB_NAME:?"is NOT set."}
#
#########################################################################
#
export mai_dir="/tmp/MAI_DIR"
#
#########################################################################
#
# functions
#
usage() {
cat >&2 <<EOF

usage: $0 [-?|-h] [-x] [-t trigger ppd count] [-Q size] [-S start date] [-U] [-R|-P|-B] [MAI path]

where:
        -? = print usage message
        -h = print usage message
        -x = debug
	-t trigger-ppd-count = number of ppd records which will trigger a failure.
	   default is zero.
        -P = only run perl script. 
             do not regenerate DB input.
             disables -R option.
             OFF by default. Either -R or -P MUST BE GIVEN.
        -R = only regenerate DB input. 
             do not run perl script.
             disables -P option.
             OFF by default. Either -R or -P MUST BE GIVEN.
        -B = enables both -R and -P together.
        -Q = maximum sql queue size for perl script.
        -U = DO NOT UPDATE panel placement headers for slave panels.
        -S "MM/DD/YYYY hh:mm:ss" = start date for data recovery.
                                    defaults to everything.

MAI path = Path to where all the data and scripts are stored. 
           Default is /tmp/MAI_DIR.

constraints:

 1) Missing panel placement details data will be recovered only for 
    panels which have a panel placement header record. 
 2) Recovering missing panel placement details data requires that the 
    MAI file to be available in the file history table. We need the 
    MAI to determine the placements and the reference designators. 
 3) Not all the panel placement details data may be recoverable, 
    for example, custom area [1234] data.
 4) Script is only for CMs.
 5) Script is only for CMs supported by DGS.

 6) Cells setup-id directories are *NOT* included in this version.
 7) Limited to one CM per line for now.

EOF
}
#
clean_up_and_mkdir () {
    rm -fr ${mai_dir}
    mkdir -p ${mai_dir}
}
#
gen_fpath () {
    echo "${mai_dir}/${1}"
}
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
    echo -e "\nSQL IN: ${infile}"
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
get_mix_names () {
    #
    infile="${1}"
    outfile="${2}"
    #
    if [[ ! -r "${infile}" ]]
    then
        echo -e "\nERROR: PPH file ${infile} is NOT READABLE. Exiting."
        exit 2
    fi
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: Output file was NOT GIVEN. Exiting."
        exit 2
    fi
    #
    echo -e "\nMIX NAMES IN: ${infile}"
    echo -e "MIX NAMES OUT: ${outfile}"
    #
    # don't forget to remove column heading of mix_name
    #
    cat ${infile} |
    cut -d'	' -f14 | 
    grep -v 'mix_name' |
    sort -u > ${outfile}
}
#
get_list_of_mai_files () {
    #
    mix_names="${1}"
    history_file_ids="${2}"
    mai_files="${3}"
    #
    if [[ ! -r "${mix_names}" ]]
    then
        echo -e "\nERROR: Mix Names file ${mix_names} is NOT READABLE. Exiting."
        exit 2
    fi
    #
    if [[ ! -r "${history_file_ids}" ]]
    then
        echo -e "\nERROR: History File IDs file ${history_file_ids} is NOT READABLE. Exiting."
        exit 2
    fi
    #
    if [[ -z "${mai_files}" ]]
    then
        echo -e "\nERROR: Output file was NOT GIVEN. Exiting."
        exit 2
    fi
    #
    rm -f "${mai_files}"
    #
    echo -e "\nMIX NAMES IN: ${mix_names}"
    echo -e "HISTORY IDS IN: ${history_file_ids}"
    echo -e "MAI FILE NAMES OUT: ${mai_files}"
    #
    cat ${mix_names} |
    sed 's/_/	/g' |
    while read crb_fname lot_name lot_no
    do
        grep "${lot_name}${crb_fname}.MAI" "${history_file_ids}" 
    done |
    sort -t'	' +0 -1 |
    tee "${mai_files}"
}
#
get_mai_files () {
    #
    mai_files="${1}"
    #
    if [[ ! -r "${mai_files}" ]]
    then
        echo -e "\nERROR: MAI Files file ${mix_names} is NOT READABLE. Exiting."
        exit 2
    fi
    #
    echo -e "\nMAI FILE NAMES IN: ${mai_files}"
    echo -e "\nMAI FILE DIR OUT: ${mai_dir}"
    #
    cat ${mai_files} |
    cut -d'	' -f1,2,4 |
    while read histfileid tstamp fname
    do
        echo "$histfileid $tstamp $fname"
        dgspt_crb_parse_test -s ${histfileid}
        #
        # mv /tmp/CRB_*-${histfileid}.*.txt "${mai_dir}/${histfileid}_${tstamp}_${fname}"
        mv /tmp/CRB_*-${histfileid}.*.txt "${mai_dir}/${tstamp}_${fname}"
    done
}
#
#######################################################################
#
# sql commands
#
write_pph_wo_details_sql_file () {
    #
    outfile="${1}"
    start_tstamp="${2}"
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: PPH WO DETAILS file not given. Exiting."
        exit 2
    fi
    #
    if [[ ( ! -z "$start_tstamp}" ) && ( $start_tstamp -ne 0 ) ]]
    then
        start_tstsmp="and pph.timestamp >= $start_tstamp"
    fi
    #
    cat > ${outfile} <<EOF
select
    -- top 1000
    r.route_id,
    r.route_name,
    zl.equipment_id,
    -- p.equipment_id,
    p.panel_id,
    p.nc_version,
    -- p.start_time,
    -- p.end_time,
    p.panel_equipment_id,
    -- p.panel_source,
    -- p.panel_trace,
    p.lane_no,
    p.stage_no,
    -- p.job_id,
    p.setup_id,
    -- p.trx_product_id,
    -- pph.equipment_id,
    -- pph.panel_equipment_id,
    pph.master_placement_id,
    pph.panel_placement_id,
    pph.timestamp,
    -- dbo.usf_unix_time_to_datetime(pph.timestamp) as nice_tstamp,
    -- pph.trx_product_id,
    ps.product_id,
    -- ps.route_id,
    ps.mix_name,
    -- ps.setup_id,
    count(ppd.panel_placement_id) as ppd_count
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    m.equipment_id = zl.equipment_id
and
    m.model_number in (
        24429826, -- CM212
        24429936, -- CM232
        232140, -- CM402
        8357053, -- CM402 Dual Lane
        229512, -- CM401-M
        24429646, -- CM401-L
        659784, -- DT401
        24429754, -- CM602
        879472477, -- CM101 35/0
        879472478, -- CM101 35/35
        879472480, -- CM101 27/0
        879472481, -- CM101 27/27
        206220, -- CM201
        225660, -- CM202-D
        208812, -- CM301
        224328 -- CM20F-M
    )
inner join
    panels p
on
    p.equipment_id = zl.equipment_id
inner join
    panel_placement_header pph
on
    pph.panel_equipment_id = p.panel_equipment_id
and
    pph.equipment_id = p.equipment_id 
inner join
    product_setup ps
on
    ps.route_id = r.route_id
and
    ps.setup_id = p.setup_id
left join
    panel_placement_details ppd
on
    -- master record
    ppd.panel_placement_id = pph.master_placement_id
or
    -- delta record
    ppd.panel_placement_id = pph.panel_placement_id
where
    r.valid_flag = 'T'
${start_tstsmp}
-- and
    -- CM (1022) and NPM (1019) in mix line 14 for testing
    -- zl.equipment_id in ( 1022, 1019 )
-- and
    -- after 03/01/2017 00:00:00 for testing
    -- pph.timestamp >= 1488322800
    --
    -- 05/01/2016 00:00:00 ==>> 1462053600
    -- pph.timestamp >= 1462053600
    -- 06/01/2016 00:00:00 ==>> 1464732000
    -- pph.timestamp >= 1464732000
    -- 07/01/2016 00:00:00 ==>> 1467324000
    -- pph.timestamp >= 1467324000
    -- 08/01/2016 00:00:00 ==>> 1470002400
    -- pph.timestamp >= 1470002400
    -- 09/01/2016 00:00:00 ==>> 1472680800
    -- pph.timestamp >= 1472680800
    -- 10/01/2016 00:00:00 ==>> 1475272800
    -- pph.timestamp >= 1475272800
    -- 11/01/2016 00:00:00 ==>> 1477954800
    -- pph.timestamp >= 1477954800
    -- 12/01/2016 00:00:00 ==>> 1480546800
    -- pph.timestamp >= 1480546800
    -- 01/01/2017 00:00:00 ==>> 1483225200
    -- pph.timestamp >= 1483225200
    -- 02/01/2017 00:00:00 ==>> 1485903600
    -- pph.timestamp >= 1485903600
    -- 03/01/2017 00:00:00 ==>> 1488322800
    -- pph.timestamp >= 1488322800
    --
    -- 05/01/2016 00:00:00 ==>> 1462053600
    -- pph.timestamp >= 1462053600
    --
    -- after 05/16/2016, time P3 was built
    -- 05/16/2016 00:00:00 ==>> 1463349600
    -- pph.timestamp >= 1463349600
group by
    r.route_id,
    r.route_name,
    zl.equipment_id,
    p.panel_id,
    p.nc_version,
    p.panel_equipment_id,
    p.lane_no,
    p.stage_no,
    p.setup_id,
    pph.master_placement_id,
    pph.panel_placement_id,
    ps.product_id,
    ps.mix_name,
    pph.timestamp
having
    count(ppd.panel_placement_id) <= ${trigger_ppd_count}
order by
    r.route_id asc,
    zl.equipment_id asc,
    p.lane_no asc,
    p.stage_no asc,
    pph.timestamp asc
go
EOF
}
#
write_file_history_ids_sql_file () {
    #
    outfile="${1}"
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: FILE HISTORY IDS file not given. Exiting."
        exit 2
    fi
    #
    cat > ${outfile} <<EOF
select
    file_history_id,
    timestamp,
    dbo.usf_unix_time_to_datetime(timestamp) as nice_tstamp,
    file_name
from
    file_history
where
    file_type_id = 7
order by
    file_history_id
go
EOF
}
#
write_product_setup_sql_file () {
    #
    outfile="${1}"
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: PRODUCT SETUP file not given. Exiting."
        exit 2
    fi
    #
    cat > ${outfile} <<EOF
select
    ps.setup_id,
    ps.product_id,
    ps.route_id,
    ps.mix_name
from
    product_setup ps
order by
    ps.setup_id asc,
    ps.product_id asc,
    ps.route_id
go
go
EOF
}
#
write_machine_slot_to_pu_sql_file () {
    #
    outfile="${1}"
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: MACHINE SLOT TO PU file not given. Exiting."
        exit 2
    fi
    #
    cat > ${outfile} <<EOF
select
    mstpu.equipment_id,
    mstpu.slot,
    mstpu.subslot,
    mstpu.z_number,
    mstpu.pu_number,
    mstpu.stage_no,
    mstpu.display_z_pu,
    mstpu.display_table_slot,
    mstpu.display_subslot
from
    machine_slot_to_pu mstpu
order by
    mstpu.equipment_id,
    mstpu.slot,
    mstpu.subslot
go
EOF
}
#
write_feeder_history_sql_file () {
    #
    outfile="${1}"
    #
    if [[ -z "${outfile}" ]]
    then
        echo -e "\nERROR: FEEDER HISTORY file not given. Exiting."
        exit 2
    fi
    #
    cat > ${outfile} <<EOF
select 
    fh.equipment_id, 
    fh.carriage_no, 
    fh.slot, 
    fh.subslot, 
    fh.time_on, 
    fh.time_off, 
    fh.reel_id, 
    fh.feeder_id, 
    fh.pu_number 
from 
    feeder_history fh
order by
    fh.equipment_id asc,
    fh.time_on asc
go
EOF
}
#
#######################################################################
#
# start of script
#
errlog="/tmp/$$.errlog"
only_run_perl_script=no
only_regenerate_data=no
run_both=no
max_sql_queue_size=1000
update_pph_headers=yes
start_date=''
start_tstamp=0
trigger_ppd_count=0
#
set -- $(getopt 'hxPRQ:US:Bt:' "${@}" 2>${errlog})
if [[ -s "${errlog}" ]]
then
    echo -e "\nERROR: invalid option"
    cat ${errlog}
    usage
    rm -f ${errlog}
    exit 2
fi
#
# don't need it.
#
rm -f ${errlog}
#
for i in ${*}
do
    case "${i}" in
    -x)
        set -x
        shift
        ;;
    -h|'-?')
        usage
        exit 0
        ;;
    -P)
        echo -e "\nReusing existing data. Will ONLY run Perl script."
        only_run_perl_script=yes
        only_regenerate_data=no
        shift
        ;;
    -R)
        echo -e "\nRegenerate data. Will NOT run Perl script."
        only_run_perl_script=no
        only_regenerate_data=yes
        shift
        ;;
    -B)
        echo -e "\nRegenerate data AND run Perl script."
        run_both=yes
        shift
        ;;
    -U)
        update_pph_headers=no
        shift
        ;;
    -Q)
        max_sql_queue_size=${2}
        shift 2
        ;;
    -t)
        trigger_ppd_count=${2}
        echo -e "\nTrigger PPD Count: ${trigger_ppd_count}"
        shift 2
        ;;
    -S)
        # date has a space inbetween the date and the time.
        start_date="${2} ${3}"
        start_tstamp=$(date -d "${start_date}" '+%s')
        if [[ $? -ne 0 ]]
        then
            echo -e "\nERROR: Invalid date. Must be 'MM/DD/YY hh:mm:ss'."
            exit 2
        fi
        echo -e "\nStart Date/Time: ${start_date} ==>> ${start_tstamp}"
        shift 3
        ;;
    --)
        shift
        break
        ;;
    esac
done
#
if [[ $# -ne 0 ]]
then
    mai_dir="${1}"
fi
#
if [[ ${run_both} == no && 
      ${only_run_perl_script} == no && 
      $only_regenerate_data == no ]]
then
    echo -e "\nERROR: Either -R or -P option MUST BE GIVEN. Exiting."
    exit 2
fi
#
# check if only need to run the perl script.
#
if [[ "${only_run_perl_script}" != yes || ${run_both} == yes ]]
then
    #
    # remove any data from previous runs. regenerate everything.
    #
    echo -e "\nRemove and create temp directory: ${mai_dir}"
    clean_up_and_mkdir
    #
    # get list of panel placement headers with NO panel placement details.
    #
    echo -e "\nGet list of Panel Placement Headers without Details"
    #
    pph_wo_details_sql=$(gen_fpath pph_wo_details.sql)
    pph_wo_details_sql_out=$(gen_fpath pph_wo_details.sql.out)
    write_pph_wo_details_sql_file ${pph_wo_details_sql} ${start_tstamp}
    time my_bsql ${pph_wo_details_sql} ${pph_wo_details_sql_out}
    #
    echo -e "\nGet list of File History IDs"
    #
    file_history_ids_sql=$(gen_fpath file_history_ids.sql)
    file_history_ids_sql_out=$(gen_fpath file_history_ids.sql.out)
    write_file_history_ids_sql_file "${file_history_ids_sql}"
    time my_bsql ${file_history_ids_sql} ${file_history_ids_sql_out}
    #
    echo -e "\nGet Product Setup Data"
    #
    product_setup_sql=$(gen_fpath product_setup.sql)
    product_setup_sql_out=$(gen_fpath product_setup.sql.out)
    write_product_setup_sql_file "${product_setup_sql}"
    time my_bsql ${product_setup_sql} ${product_setup_sql_out}
    #
    echo -e "\nGet Machine Slot To PU Data"
    #
    machine_slot_to_pu_sql=$(gen_fpath machine_slot_to_pu.sql)
    machine_slot_to_pu_sql_out=$(gen_fpath machine_slot_to_pu.sql.out)
    write_machine_slot_to_pu_sql_file "${machine_slot_to_pu_sql}"
    time my_bsql ${machine_slot_to_pu_sql} ${machine_slot_to_pu_sql_out}
    #
    echo -e "\nGet Feeder History Data"
    #
    feeder_history_sql=$(gen_fpath feeder_history.sql)
    feeder_history_sql_out=$(gen_fpath feeder_history.sql.out)
    write_feeder_history_sql_file "${feeder_history_sql}"
    time my_bsql ${feeder_history_sql} ${feeder_history_sql_out}
    #
    # get the list of all mix names
    #
    echo -e "\nGet Mix Names"
    #
    mix_names_out=$(gen_fpath mix_names.out)
    time get_mix_names ${pph_wo_details_sql_out} ${mix_names_out}
    #
    # get the list of all product MAI files
    #
    echo -e "\nGet list of MAI files"
    #
    mai_files_out=$(gen_fpath mai_files.out)
    time get_list_of_mai_files ${mix_names_out} ${file_history_ids_sql_out} ${mai_files_out}
    #
    echo -e "\nGet MAI files"
    #
    time get_mai_files ${mai_files_out}
    #
    if [[ "${only_regenerate_data}" == yes && ${run_both} == no ]]
    then
        echo -e "\nData regenerated. Perl Script NOT executed."
        echo -e "\nDONE"
        exit 0
    fi
else
    echo -e "\nSkipping data regeneration. Will only run Perl script."
fi
#
echo -e "\nGenerate SQL Script To Fix Trace Data"
#
if [[ "$update_pph_headers" == no ]]
then
    time lear.missing.panel.plc.details.fix.pl -U -Q ${max_sql_queue_size} ${mai_dir}
else
    time lear.missing.panel.plc.details.fix.pl -Q ${max_sql_queue_size} ${mai_dir}
fi
#
# all done
#
echo -e "\nDONE"
exit 0

#!/bin/bash
#
: ${DB_SERVER:?"is NOT set."}
: ${DB_PORT_NO:?"is NOT set."}
: ${DB_NAME:?"is NOT set."}
#
echohl () {
    smso="$(tput smso)"
    rmso="$(tput rmso)"
    blink="$(tput blink)"
    unblink="$(tput sgr0)"
    #
    echo -e "${smso}${blink}${*}${unblink}${rmso}"
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
trace_data_sql="/tmp/$$.tds.sql"
cat > ${trace_data_sql} <<EOF
select 
    r.route_name as          'r.route_name',
    td.panel_id as           'td.panel_id',
    eq.equipment_name as     'eq.equipment_name',
    p.lane_no as             'p.lane_no',
    p.stage_no as            'p.stage_no',
    p.nc_version as          'p.nc_version',
    p.end_time as            'p.end_time',
    p.trx_product_id as      'p.trx_product_id',
    td.serial_no as          'td.serial_no',
    td.barcode as            'td.barcode',
    td.prod_model_no as      'td.prod_model_no',
    td.pattern_id as         'td.pattern_id',
    td.setup_id as           'td.setup_id',
    td.top_bottom as         'td.top_bottom',
    td.timestamp as          'td.timestamp',
    td.import_flag as        'td.import_flag',
    pph.panel_equipment_id as  'pph.panel_equipment_id',
    pph.equipment_id as        'pph.equipment_id',
    pph.master_placement_id as 'pph.master_placement_id',
    pph.panel_placement_id as  'pph.panel_placement_id',
    pph.timestamp as           'pph.timestamp',
    pph.trx_product_id as      'pph.trx_product_id',
    count(ppd.panel_placement_id) as 'count_ppd.panel_placement_id'
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    z.zone_id = rl.zone_id
inner join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
inner join
    equipment eq
on
    eq.equipment_id = zl.equipment_id
inner join
    panels p
on
    p.equipment_id = zl.equipment_id
inner join
    tracking_data td
on
    td.panel_id = p.panel_id
left join
    panel_placement_header pph
on
    pph.equipment_id = zl.equipment_id
and
    pph.panel_equipment_id = p.panel_equipment_id
left join
    panel_placement_details ppd
on
    ppd.panel_placement_id = pph.master_placement_id
where
    r.valid_flag = 't'
and
    z.valid_flag = 't'
and
    z.module_id > 0
and
    START_TIME <= p.end_time
and
    p.end_time < END_TIME
group by
    r.route_id,
    r.route_name,
    td.panel_id,
    rl.pos,
    eq.equipment_name,
    p.lane_no,
    p.stage_no,
    p.nc_version,
    p.end_time,
    p.trx_product_id,
    td.serial_no,
    td.barcode,
    td.prod_model_no,
    td.pattern_id,
    td.setup_id,
    td.top_bottom,
    td.timestamp,
    td.import_flag,
    pph.panel_equipment_id,
    pph.equipment_id,
    pph.master_placement_id,
    pph.panel_placement_id,
    pph.timestamp,
    pph.trx_product_id
order by
    r.route_id asc,
    td.panel_id asc,
    rl.pos asc,
    p.lane_no asc,
    p.stage_no asc
go
EOF
#
if [[ $# -eq 1 ]]
then
    echo "Using cmd line date: ${1}"
    may_start=$(date -d "${1} 00:00:00" "+%s")
    may_end=$(date -d "${1} 23:59:59" "+%s")
else
    may_start=$(date -d "2015-05-19 00:00:00" "+%s")
    may_end=$(date -d "2015-05-19 23:59:59" "+%s")
fi
may_trace_data_sql="/tmp/$$.mtds.sql"
echo "$may_start $may_end $may_trace_data_sql"
#
cat ${trace_data_sql} |
sed -e "s/START_TIME/${may_start}/" \
    -e "s/END_TIME/${may_end}/" > ${may_trace_data_sql}
#
today_start=$(date -d "00:00:00" "+%s")
today_end=$(date "+%s")
today_trace_data_sql="/tmp/$$.ttds.sql"
echo "$today_start $today_end $today_trace_data_sql"
#
cat ${trace_data_sql} |
sed -e "s/START_TIME/${today_start}/" \
    -e "s/END_TIME/${today_end}/" > ${today_trace_data_sql}
#
product_run_history_sql="/tmp/$$.prh.sql"
echo "$product_run_history_sql"
#
cat > ${product_run_history_sql} <<EOF
select 
    prh.product_run_history_id as 'prh.product_run_history_id',
    prh.equipment_id as 'prh.equipment_id',
    prh.lane_no as 'prh.lane_no',
    prh.setup_id as 'prh.setup_id',
    prh.start_time as 'prh.start_time',
    prh.end_time as 'prh.end_time'
from
    product_run_history prh
order by
    prh.equipment_id asc,
    prh.lane_no asc,
    prh.start_time asc
go
EOF
#
#######################################################################
#
# start of script
#
may_trace_data_sql_out="${may_trace_data_sql}.out"
time my_bsql ${may_trace_data_sql} ${may_trace_data_sql_out}
#
today_trace_data_sql_out="${today_trace_data_sql}.out"
time my_bsql ${today_trace_data_sql} ${today_trace_data_sql_out}
#
product_run_history_sql_out="${product_run_history_sql}.out"
time my_bsql ${product_run_history_sql} ${product_run_history_sql_out}
#
all_out="/tmp/$$.all.out"
cat ${may_trace_data_sql} \
    ${may_trace_data_sql_out} \
    ${today_trace_data_sql} \
    ${today_trace_data_sql_out} \
    ${product_run_history_sql} \
    ${product_run_history_sql_out} > ${all_out}
#
#
echohl "\n\t\tPlease send this file to PFSA: ${all_out}\n"
#
exit 0

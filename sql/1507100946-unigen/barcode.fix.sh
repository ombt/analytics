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
trace_data_sql="/tmp/$$.tds.sql"
#
cat > ${trace_data_sql} <<EOF
select 
    -- top(5000)
    r.route_id as            'r.route_id',
    r.route_name as          'r.route_name',
    rl.pos as                'rl.pos',
    rl.zone_id as            'rl.zone_id',
    z.zone_name as           'z.zone_name',
    z.trace_level as         'z.trace_level',
    z.module_id as           'z.module_id',
    zl.pos as                'zl.pos',
    zl.equipment_id as       'zl.equipment_id',
    sh.equipment_id as       'sh.equipment_id',
    sh.panel_equipment_id as 'sh.panel_equipment_id',
    sh.trx_product_id as     'sh.trx_product_id',
    sh.master_strace_id as   'sh.master_strace_id',
    sh.panel_strace_id as    'sh.panel_strace_id',
    sh.timestamp as          'sh.timestamp',
    p.panel_id as            'p.panel_id',
    p.equipment_id as        'p.equipment_id',
    p.nc_version as          'p.nc_version',
    p.start_time as          'p.start_time',
    p.end_time as            'p.end_time',
    p.panel_equipment_id as  'p.panel_equipment_id',
    p.panel_source as        'p.panel_source',
    p.panel_trace as         'p.panel_trace',
    p.stage_no as            'p.stage_no',
    p.lane_no as             'p.lane_no',
    p.job_id as              'p.job_id',
    p.setup_id as            'p.setup_id',
    p.trx_product_id as      'p.trx_product_id',
    td.serial_no as          'td.serial_no',
    td.barcode as            'td.barcode',
    td.prod_model_no as      'td.prod_model_no',
    td.panel_id as           'td.panel_id',
    td.pattern_id as         'td.pattern_id',
    td.setup_id as           'td.setup_id',
    td.top_bottom as         'td.top_bottom',
    td.timestamp as          'td.timestamp',
    td.import_flag as        'td.import_flag'
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
left join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
left join
    panel_strace_header sh
on
    sh.equipment_id = zl.equipment_id
left join
    panels p
on
    p.panel_equipment_id = sh.panel_equipment_id
left join
    tracking_data td
on
    td.panel_id = p.panel_id
where
    r.valid_flag = 'T'
and
    len(r.lnb_host_name) > 0
and
    z.valid_flag = 'T'
and
    z.module_id > 0
order by
    r.route_id asc,
    rl.pos asc,
    sh.equipment_id asc,
    td.serial_no asc,
    p.stage_no asc,
    p.lane_no asc,
    sh.panel_equipment_id asc
go
EOF
#
product_run_history_sql="/tmp/$$.prh.sql"
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
max_panel_ids_sql="/tmp/$$.mpi.sql"
#
cat > ${max_panel_ids_sql} <<EOF
select 
    max(sh.panel_equipment_id) as 'max.sh.panel_equipment_id'
from
    panel_strace_header sh
go
select 
    max(p.panel_equipment_id) as  'max.p.panel_equipment_id',
    max(p.panel_id) as            'max.p.panel_id'
from
    panels p
go
select 
    max(td.panel_id) as 'max.td.panel_id'
from
    tracking_data td
go
EOF
#
#
#######################################################################
#
# start of script
#
# get trace data which needs to be fixed.
#
echo -e "\nDump Trace Data"
trace_data_sql_out="${trace_data_sql}.out"
time my_bsql ${trace_data_sql} ${trace_data_sql_out}
#
# dump out extra data needed for generating fixes.
#
echo -e "\nDump Product Run History Data"
product_run_history_sql_out="${product_run_history_sql}.out"
time my_bsql ${product_run_history_sql} ${product_run_history_sql_out}
#
echo -e "\nDump Maximum Panel IDs Data"
max_panel_ids_sql_out="${max_panel_ids_sql}.out"
time my_bsql ${max_panel_ids_sql} ${max_panel_ids_sql_out}
#
# start creating SQL script to fix the database.
#
echo -e "\nGenerate SQL Script To Fix Trace Data"
fix_sql="/tmp/$$.fix.sql"
log_out="/tmp/$$.lo"
#
echo "barcode.fix.pl -V 1 -L ${log_out} -P all \
                           ${trace_data_sql_out} \
                           ${product_run_history_sql_out} \
                           ${fix_sql}"
#
time barcode.fix.pl -V 1 -L ${log_out} -P all \
                           ${trace_data_sql_out} \
                           ${product_run_history_sql_out} \
                           ${max_panel_ids_sql_out} \
                           ${fix_sql}
#
echo -e "\nLOG OUT: ${log_out}"
echo "TRACE DATA SQL: ${trace_data_sql_out}"
echo "PRODUCT RUN HISTORY: ${product_run_history_sql_out}"
echo "FIX SQL: ${fix_sql}"
#
echo -e "\nALL DONE"
#
exit 0




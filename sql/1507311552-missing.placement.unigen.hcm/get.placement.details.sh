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
    echo -e "${smso}${*}${rmso}"
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
all_out="/tmp/$$.all.out"
>${all_out}
#
current_ncpd_sql="/tmp/$$.cncpd.sql"
cat > ${current_ncpd_sql} <<EOF
select 
    r.route_name as 'r.route_name',
    -- r.route_id as 'r.route_id',
    -- rl.pos as 'rl.pos',
    -- rl.zone_id as 'rl.zone_id',
    -- z.zone_name as 'z.zone_name',
    -- z.trace_level as 'z.trace_level',
    -- z.module_id as 'z.module_id',
    -- zl.pos as 'zl.pos',
    -- zl.equipment_id as 'zl.equipment_id',
    eq.equipment_name as 'eq.equipment_name',
    -- prh. product_run_history_id
    -- prh. equipment_id
    prh.lane_no as 'prh.lane_no',
    prh.setup_id as 'prh.setup_id',
    -- prh.start_time
    -- prh.end_time
    -- ncs.setup_id
    -- ncs.equipment_id
    ncs.nc_version as 'ncs.nc_version',
    -- ncs.tva
    -- ncs.double_feeder_flag
    -- ncs.glue_total
    -- ncs.solder_total
    count(ncpd.nc_placement_id) as 'count_ncpd.nc_placement_id'
    -- nc_placement_detail nc_placement_id
    -- nc_placement_detail idnum
    -- nc_placement_detail ref_designator
    -- nc_placement_detail part_name
    -- nc_placement_detail pattern_number
    -- nc_placement_detail nc_version
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
and
    r.valid_flag = 't'
inner join
    zones z
on
    z.zone_id = rl.zone_id
and
    z.valid_flag = 't'
and
    z.module_id > 0
inner join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
inner join
    equipment eq
on
    eq.equipment_id = zl.equipment_id
inner join
    product_run_history prh
on
    prh.equipment_id = zl.equipment_id
and
    prh.end_time > 2000000000
inner join
    nc_summary ncs
on
    ncs.setup_id = prh.setup_id
and
    ncs.equipment_id = prh.equipment_id
left join
    nc_placement_detail ncpd
on
    ncpd.nc_version = ncs.nc_version
where
    prh.start_time <= SEARCH_TIME
and
    SEARCH_TIME <= prh.end_time
group by
    r.route_id,
    rl.pos,
    prh.start_time,
    ncs.nc_version,
    r.route_name,
    eq.equipment_name,
    prh.lane_no,
    prh.setup_id,
    ncs.nc_version
order by
    r.route_id asc,
    rl.pos asc,
    prh.start_time asc,
    ncs.nc_version asc
go
EOF
#
if [[ $# -eq 1 ]]
then
    echo "Using cmd line date/time: ${1}"
    search_time=$(date -d "${1}" "+%s")
else
    search_time=$(date "+%s")
fi
#
cat ${current_ncpd_sql} |
sed "s/SEARCH_TIME/${search_time}/" > /tmp/$$.sql
mv /tmp/$$.sql ${current_ncpd_sql}
#
#######################################################################
#
# start of script
#
current_ncpd_sql_out="${current_ncpd_sql}.out"
time my_bsql ${current_ncpd_sql} ${current_ncpd_sql_out}
#
cat ${current_ncpd_sql} \
    ${current_ncpd_sql_out} \
    ${today_product_run_history_sql_out} >> ${all_out}
#
echohl "\n\t\tPlease send this file to PFSA: ${all_out}\n"
#
exit 0

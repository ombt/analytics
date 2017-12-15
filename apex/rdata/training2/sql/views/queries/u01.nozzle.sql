select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    dn._filename_id,
    dn._pcb_id,
    dn._pcb_serial,
    dn._machine_order,
    dn._lane_no,
    dn._stage_no,
    dn._timestamp,
    dn._nhadd,
    dn._ncadd,
    dn._mjsid,
    dn._lotname,
    dn._output_no,
    dn._pickup,
    dn._pmiss,
    dn._rmiss,
    dn._dmiss,
    dn._mmiss,
    dn._hmiss,
    dn._trsmiss,
    dn._mount
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_nozzle as dn
on
    dn._filename_id = ftf._filename_id
and
    dn._lane_no = ufd._lane_no
and
    dn._stage_no = ufd._stage_no
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    dn._nhadd,
    dn._ncadd
;

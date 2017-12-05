
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    df._fadd,
    df._fsadd,
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
    df._filename_id,
    df._pcb_id,
    df._pcb_serial,
    df._machine_order,
    df._lane_no,
    df._stage_no,
    df._timestamp,
    df._mjsid,
    df._lotname,
    df._reelid,
    df._partsname,
    df._output_no,
    df._blkserial,
    df._pickup,
    df._pmiss,
    df._rmiss,
    df._dmiss,
    df._mmiss,
    df._hmiss,
    df._trsmiss,
    df._mount
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_feeder df
on
    df._filename_id = ftf._filename_id
and
    df._lane_no = ufd._lane_no
and
    df._stage_no = ufd._stage_no
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    df._fadd,
    df._fsadd
;

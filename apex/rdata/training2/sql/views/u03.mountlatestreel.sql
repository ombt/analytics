
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mlr._fadd,
    mlr._fsadd,
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
    mlr._filename_id,
    mlr._blkcode,
    mlr._blkserial,
    mlr._ftype,
    mlr._use,
    mlr._pestatus,
    mlr._pcstatus,
    mlr._remain,
    mlr._init,
    mlr._partsname,
    mlr._custom1,
    mlr._custom2,
    mlr._custom3,
    mlr._custom4,
    mlr._reelid,
    mlr._partsemp,
    mlr._active,
    mlr._tgserial
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.mountlatestreel mlr
on
    mlr._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mlr._fadd,
    mlr._fsadd
;

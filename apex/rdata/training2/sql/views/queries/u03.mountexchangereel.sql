select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mxr._fadd,
    mxr._fsadd,
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
    mxr._filename_id,
    mxr._blkcode,
    mxr._blkserial,
    mxr._ftype,
    mxr._use,
    mxr._pestatus,
    mxr._pcstatus,
    mxr._remain,
    mxr._init,
    mxr._partsname,
    mxr._custom1,
    mxr._custom2,
    mxr._custom3,
    mxr._custom4,
    mxr._reelid,
    mxr._partsemp,
    mxr._active
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.mountexchangereel mxr
on
    mxr._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mxr._fadd,
    mxr._fsadd
;

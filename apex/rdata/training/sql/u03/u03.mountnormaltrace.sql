select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    mnt._fadd,
    mnt._fsadd,
    mnt._nhadd,
    mnt._ncadd,
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
    mnt._filename_id,
    mnt._b,
    mnt._idnum,
    mnt._reelid
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.mountnormaltrace mnt
on
    mnt._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mnt._fadd,
    mnt._fsadd,
    mnt._nhadd,
    mnt._ncadd
;

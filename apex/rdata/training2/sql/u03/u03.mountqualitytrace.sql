
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mqt._fadd,
    mqt._fsadd,
    mqt._nhadd,
    mqt._ncadd,
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
    mqt._filename_id,
    mqt._b,
    mqt._idnum,
    mqt._turn,
    mqt._ms,
    mqt._ts,
    mqt._fblkcode,
    mqt._fblkserial,
    mqt._nblkcode,
    mqt._nblkserial,
    mqt._reelid,
    mqt._f,
    mqt._rcgx,
    mqt._rcgy,
    mqt._rcga,
    mqt._tcx,
    mqt._tcy,
    mqt._mposirecx,
    mqt._mposirecy,
    mqt._mposireca,
    mqt._mposirecz,
    mqt._thmax,
    mqt._thave,
    mqt._mntcx,
    mqt._mntcy,
    mqt._mntca,
    mqt._tlx,
    mqt._tly,
    mqt._inspectarea,
    mqt._didnum,
    mqt._ds,
    mqt._dispenseid,
    mqt._parts,
    mqt._warpz,
    mqt._prepickuplot,
    mqt._prepickupsts
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.mountqualitytrace mqt
on
    mqt._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    mqt._fadd,
    mqt._fsadd,
    mqt._nhadd,
    mqt._ncadd
;

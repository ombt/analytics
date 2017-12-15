
create view u03.mountexchangereel_view
as
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
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- mxr._filename_id,
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

create view u03.mountlatestreel_view
as
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
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- mlr._filename_id,
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

create view u03.mountnormaltrace_view
as
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
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- mnt._filename_id,
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

create view u03.mountqualitytrace_view
as
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
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- mqt._filename_id,
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

create view u03.index_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date as index_date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upi._filename_id,
    upi._author,
    upi._authortype,
    upi._comment,
    upi._date,
    upi._diff,
    upi._format,
    upi._machine,
    upi._mjsid,
    upi._version
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.pivot_index upi
on
    upi._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

create view u03.information_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    -- ftf._filename_id,
    ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upi._filename_id,
    upi._bcrstatus,
    upi._code,
    -- upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus
    -- upi._stage
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

create view u03.index_information_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upx._filename_id,
    upx._author,
    upx._authortype,
    upx._comment,
    upx._date as idx_date,
    upx._diff,
    upx._format,
    upx._machine,
    upx._mjsid,
    upx._version,
    -- upi._filename_id,
    upi._bcrstatus,
    upi._code,
    upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus,
    upi._stage
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

create view u03.index_info_mqt_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    -- ftf._filename,
    -- ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upx._filename_id,
    -- upx._author,
    -- upx._authortype,
    -- upx._comment,
    -- upx._date as idx_date,
    -- upx._diff,
    -- upx._format,
    -- upx._machine,
    upx._mjsid,
    -- upx._version,
    -- upi._filename_id,
    upi._bcrstatus,
    upi._code,
    upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus,
    upi._stage,
    -- mqt._filename_id,
    mqt._b,
    mqt._idnum,
    mqt._turn,
    mqt._ms,
    mqt._ts,
    mqt._fadd,
    mqt._fsadd,
    mqt._nhadd,
    mqt._ncadd,
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
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    u03.mountqualitytrace mqt
on
    mqt._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

create view u03.index_info_mqt_no_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    -- ftf._filename,
    -- ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upx._filename_id,
    -- upx._author,
    -- upx._authortype,
    -- upx._comment,
    -- upx._date as idx_date,
    -- upx._diff,
    -- upx._format,
    -- upx._machine,
    upx._mjsid,
    -- upx._version,
    -- upi._filename_id,
    upi._bcrstatus,
    upi._code,
    upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus,
    upi._stage,
    -- mqt._filename_id,
    mqt._b,
    mqt._idnum,
    mqt._turn,
    mqt._ms,
    mqt._ts,
    mqt._fadd,
    mqt._fsadd,
    mqt._nhadd,
    mqt._ncadd,
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
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    u03.mountqualitytrace mqt
on
    mqt._filename_id = ftf._filename_id
--
-- no - no ordering
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;


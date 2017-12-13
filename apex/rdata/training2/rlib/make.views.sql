
drop view if exists aoi.file_data_view
;
drop view if exists aoi.all_view
;
drop view if exists aoi.no_good_view
;
drop view if exists aoi.good_view
;
drop view if exists u01.count_view
;
drop view if exists u01.time_view
;
drop view if exists u01.feeder_view
;
drop view if exists u01.nozzle_view
;
drop view if exists u03.mountexchangereel_view
;
drop view if exists u03.mountlatestreel_view
;
drop view if exists u03.mountnormaltrace_view
;
drop view if exists u03.mountqualitytrace_view
;

create view aoi.file_data_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
order by
    ftf._filename_timestamp asc
;

create view aoi.all_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
left join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
left join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp
order by
    ftf._filename_timestamp asc
;

create view aoi.no_good_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp > 0
inner join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
inner join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp
order by
    ftf._filename_timestamp asc
;

create view aoi.good_view
as
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp < 0
order by
    ftf._filename_timestamp asc
;

create view u01.count_view
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
    -- dpc._filename_id,
    -- dpc._pcb_id,
    -- dpc._pcb_serial,
    -- dpc._machine_order,
    -- dpc._lane_no,
    -- dpc._stage_no,
    dpc._timestamp,
    dpc._mjsid,
    dpc._lotname,
    -- dpc._output_no,
    dpc._bndrcgstop,
    dpc._bndstop,
    dpc._board,
    dpc._brcgstop,
    dpc._bwait,
    dpc._cderr,
    dpc._cmerr,
    dpc._cnvstop,
    dpc._cperr,
    dpc._crerr,
    dpc._cterr,
    dpc._cwait,
    dpc._fbstop,
    dpc._fwait,
    dpc._jointpasswait,
    dpc._judgestop,
    dpc._lotboard,
    dpc._lotmodule,
    dpc._mcfwait,
    dpc._mcrwait,
    dpc._mhrcgstop,
    dpc._module,
    dpc._otherlstop,
    dpc._othrstop,
    dpc._pwait,
    dpc._rwait,
    dpc._scestop,
    dpc._scstop,
    dpc._swait,
    dpc._tdispense,
    dpc._tdmiss,
    dpc._thmiss,
    dpc._tmmiss,
    dpc._tmount,
    dpc._tpickup,
    dpc._tpmiss,
    dpc._tpriming,
    dpc._trbl,
    dpc._trmiss,
    dpc._trserr,
    dpc._trsmiss
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_pivot_count dpc
on
    dpc._filename_id = ftf._filename_id
and
    dpc._lane_no = ufd._lane_no
and
    dpc._stage_no = ufd._stage_no
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

create view u01.time_view
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
    -- dpt._filename_id,
    -- dpt._pcb_id,
    -- dpt._pcb_serial,
    -- dpt._machine_order,
    -- dpt._lane_no,
    -- dpt._stage_no,
    dpt._timestamp,
    dpt._mjsid,
    dpt._lotname,
    -- dpt._output_no,
    dpt._actual,
    dpt._bndrcgstop,
    dpt._bndstop,
    dpt._brcg,
    dpt._brcgstop,
    dpt._bwait,
    dpt._cderr,
    dpt._change,
    dpt._cmerr,
    dpt._cnvstop,
    dpt._cperr,
    dpt._crerr,
    dpt._cterr,
    dpt._cwait,
    dpt._dataedit,
    dpt._fbstop,
    dpt._fwait,
    dpt._idle,
    dpt._jointpasswait,
    dpt._judgestop,
    dpt._load,
    dpt._mcfwait,
    dpt._mcrwait,
    dpt._mente,
    dpt._mhrcgstop,
    dpt._mount,
    dpt._otherlstop,
    dpt._othrstop,
    dpt._poweron,
    dpt._prdstop,
    dpt._prod,
    dpt._prodview,
    dpt._pwait,
    dpt._rwait,
    dpt._scestop,
    dpt._scstop,
    dpt._swait,
    dpt._totalstop,
    dpt._trbl,
    dpt._trserr,
    dpt._unitadjust
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_pivot_time dpt
on
    dpt._filename_id = ftf._filename_id
and
    dpt._lane_no = ufd._lane_no
and
    dpt._stage_no = ufd._stage_no
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

create view u01.feeder_view
as
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
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- df._filename_id,
    -- df._pcb_id,
    -- df._pcb_serial,
    -- df._machine_order,
    -- df._lane_no,
    -- df._stage_no,
    df._timestamp,
    df._mjsid,
    df._lotname,
    df._reelid,
    df._partsname,
    -- df._output_no,
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

create view u01.nozzle_view
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
    -- dn._filename_id,
    -- dn._pcb_id,
    -- dn._pcb_serial,
    -- dn._machine_order,
    -- dn._lane_no,
    -- dn._stage_no,
    dn._timestamp,
    dn._nhadd,
    dn._ncadd,
    dn._mjsid,
    dn._lotname,
    -- dn._output_no,
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


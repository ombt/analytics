
drop view if exists u03.mqt_pos_data_view
;
drop view if exists u03.mqt_pos_data_aoi_no_good_view
;
drop view if exists u03.mqt_pos_data_aoi_good_view
;
drop view if exists aoi.file_data_view
;
drop view if exists aoi.all_view
;
drop view if exists aoi.all_no_view
;
drop view if exists aoi.no_good_view
;
drop view if exists aoi.no_good_no_view
;
drop view if exists aoi.good_view
;
drop view if exists aoi.good_no_view
;
drop view if exists u01.count_view
;
drop view if exists u01.time_view
;
drop view if exists u01.feeder_view
;
drop view if exists u01.nozzle_view
;
drop view if exists u01.index_view
;
drop view if exists u01.information_view
;
drop view if exists u01.index_information_view
;
drop view if exists u03.mountexchangereel_view
;
drop view if exists u03.mountlatestreel_view
;
drop view if exists u03.mountnormaltrace_view
;
drop view if exists u03.mountqualitytrace_view
;
drop view if exists u03.index_view
;
drop view if exists u03.information_view
;
drop view if exists u03.index_information_view
;
drop view if exists u03.index_info_mqt_view
;
drop view if exists u03.index_info_mqt_no_view
;
drop view if exists crb.lot_position_data_view
;
drop view if exists crb.lot_position_data_no_view
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

create view aoi.all_no_view
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
-- no - no ordering
-- order by
    -- ftf._filename_timestamp asc
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

create view aoi.no_good_no_view
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
-- no - no ordering
-- order by
    -- ftf._filename_timestamp asc
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

create view aoi.good_no_view
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
-- no - no ordering
-- order by
    -- ftf._filename_timestamp asc
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

create view u01.index_view
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
    -- upi._filename_id,
    upi._author,
    upi._authortype,
    upi._comment,
    upi._date as index_date,
    upi._diff,
    upi._format,
    upi._machine,
    upi._mjsid,
    upi._version
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_index upi
on
    upi._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
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

create view u01.information_view
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
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_information upi
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

create view crb.lot_position_data_view
as
select
    ftf._filename_route,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- cfd._filename_id,
    cfd._history_id,
    cfd._time_stamp,
    cfd._crb_file_name,
    cfd._product_name,
    -- cl._filename_id,
    cl._idnum as lot_idnum,
    cl._lotnum,
    cl._lot,
    cl._mcfilename,
    cl._filter,
    cl._autochg,
    cl._basechg,
    cl._lane,
    cl._productionid,
    cl._simproduct,
    cl._dgspcbname,
    cl._dgspcbrev,
    cl._dgspcbside,
    cl._dgsrefpin,
    cl._c as lot_c,
    cl._datagenmode,
    cl._mounthead,
    cl._vstpath,
    cl._targettact,
    cl._order,
    -- cp._filename_id,
    cp._lot_number,
    cp._idnum as pos_idnum,
    cp._cadid,
    cp._x,
    cp._y,
    cp._a,
    cp._parts,
    cp._brm,
    cp._turn,
    cp._dturn,
    cp._ts,
    cp._ms,
    cp._ds,
    cp._np,
    cp._dnp,
    cp._pu,
    cp._side,
    cp._dpu,
    cp._head,
    cp._dhead,
    cp._ihead,
    cp._b,
    cp._pg,
    cp._s,
    cp._rid,
    cp._c as pos_c,
    cp._m,
    cp._mb,
    cp._f,
    cp._pr,
    cp._priseq,
    cp._p,
    cp._pad,
    cp._vw,
    cp._stdpos,
    cp._land,
    cp._depend,
    cp._chkflag,
    cp._exchk,
    cp._grand,
    cp._marea,
    cp._rmset,
    cp._sh,
    cp._scandir1,
    cp._scandir2,
    cp._ohl,
    cp._ohr,
    cp._apcctrl,
    cp._wg,
    cp._skipnumber
from
    crb.filename_to_fid ftf
inner join
    crb.crb_filename_data cfd
on
    cfd._filename_id = ftf._filename_id
inner join
    crb.lotnames cl
on
    cl._filename_id = ftf._filename_id
inner join
    crb.positiondata cp
on
    cp._filename_id = ftf._filename_id
and
    cp._lot_number = cl._lotnum
order by
    ftf._filename_route,
    ftf._filename_timestamp,
    cl._lotnum,
    cp._idnum
;

create view crb.lot_position_data_no_view
as
select
    ftf._filename_route,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- cfd._filename_id,
    cfd._history_id,
    cfd._time_stamp,
    cfd._crb_file_name,
    cfd._product_name,
    -- cl._filename_id,
    cl._idnum as lot_idnum,
    cl._lotnum,
    cl._lot,
    cl._mcfilename,
    cl._filter,
    cl._autochg,
    cl._basechg,
    cl._lane,
    cl._productionid,
    cl._simproduct,
    cl._dgspcbname,
    cl._dgspcbrev,
    cl._dgspcbside,
    cl._dgsrefpin,
    cl._c as lot_c,
    cl._datagenmode,
    cl._mounthead,
    cl._vstpath,
    cl._targettact,
    cl._order,
    -- cp._filename_id,
    cp._lot_number,
    cp._idnum as pos_idnum,
    cp._cadid,
    cp._x,
    cp._y,
    cp._a,
    cp._parts,
    cp._brm,
    cp._turn,
    cp._dturn,
    cp._ts,
    cp._ms,
    cp._ds,
    cp._np,
    cp._dnp,
    cp._pu,
    cp._side,
    cp._dpu,
    cp._head,
    cp._dhead,
    cp._ihead,
    cp._b,
    cp._pg,
    cp._s,
    cp._rid,
    cp._c as pos_c,
    cp._m,
    cp._mb,
    cp._f,
    cp._pr,
    cp._priseq,
    cp._p,
    cp._pad,
    cp._vw,
    cp._stdpos,
    cp._land,
    cp._depend,
    cp._chkflag,
    cp._exchk,
    cp._grand,
    cp._marea,
    cp._rmset,
    cp._sh,
    cp._scandir1,
    cp._scandir2,
    cp._ohl,
    cp._ohr,
    cp._apcctrl,
    cp._wg,
    cp._skipnumber
from
    crb.filename_to_fid ftf
inner join
    crb.crb_filename_data cfd
on
    cfd._filename_id = ftf._filename_id
inner join
    crb.lotnames cl
on
    cl._filename_id = ftf._filename_id
inner join
    crb.positiondata cp
on
    cp._filename_id = ftf._filename_id
and
    cp._lot_number = cl._lotnum
--
-- no - not ordered
-- order by
    -- ftf._filename_route,
    -- ftf._filename_timestamp,
    -- cl._lotnum,
    -- cp._idnum
;

create view u01.index_information_view
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
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u01.pivot_information upi
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

create view u03.mqt_pos_data_view
as
select
    mqt._filename_route as mqt_filename_route,
    mqt._machine_order as mqt_machine_order,
    mqt._lane_no as mqt_lane_no,
    mqt._stage_no as mqt_stage_no,
    mqt._filename_timestamp as mqt_filename_timestamp,
    mqt._filename_id as mqt_filename_id,
    mqt._pcb_serial as mqt_pcb_serial,
    mqt._pcb_id as mqt_pcb_id,
    mqt._output_no as mqt_output_no,
    mqt._pcb_id_lot_no as mqt_pcb_id_lot_no,
    mqt._pcb_id_serial_no as mqt_pcb_id_serial_no,
    mqt._mjsid as mqt_mjsid,
    mqt._bcrstatus as mqt_bcrstatus,
    mqt._code as mqt_code,
    mqt._lane as mqt_lane,
    mqt._lotname as mqt_lotname,
    mqt._lotnumber as mqt_lotnumber,
    mqt._output as mqt_output,
    mqt._planid as mqt_planid,
    mqt._productid as mqt_productid,
    mqt._rev as mqt_rev,
    mqt._serial as mqt_serial,
    mqt._serialstatus as mqt_serialstatus,
    mqt._stage as mqt_stage,
    mqt._b as mqt_b,
    mqt._idnum as mqt_idnum,
    mqt._turn as mqt_turn,
    mqt._ms as mqt_ms,
    mqt._ts as mqt_ts,
    mqt._fadd as mqt_fadd,
    mqt._fsadd as mqt_fsadd,
    mqt._nhadd as mqt_nhadd,
    mqt._ncadd as mqt_ncadd,
    mqt._fblkcode as mqt_fblkcode,
    mqt._fblkserial as mqt_fblkserial,
    mqt._nblkcode as mqt_nblkcode,
    mqt._nblkserial as mqt_nblkserial,
    mqt._reelid as mqt_reelid,
    mqt._f as mqt_f,
    mqt._rcgx as mqt_rcgx,
    mqt._rcgy as mqt_rcgy,
    mqt._rcga as mqt_rcga,
    mqt._tcx as mqt_tcx,
    mqt._tcy as mqt_tcy,
    mqt._mposirecx as mqt_mposirecx,
    mqt._mposirecy as mqt_mposirecy,
    mqt._mposireca as mqt_mposireca,
    mqt._mposirecz as mqt_mposirecz,
    mqt._thmax as mqt_thmax,
    mqt._thave as mqt_thave,
    mqt._mntcx as mqt_mntcx,
    mqt._mntcy as mqt_mntcy,
    mqt._mntca as mqt_mntca,
    mqt._tlx as mqt_tlx,
    mqt._tly as mqt_tly,
    mqt._inspectarea as mqt_inspectarea,
    mqt._didnum as mqt_didnum,
    mqt._ds as mqt_ds,
    mqt._dispenseid as mqt_dispenseid,
    mqt._parts as mqt_parts,
    mqt._warpz as mqt_warpz,
    mqt._prepickuplot as mqt_prepickuplot,
    mqt._prepickupsts as mqt_prepickupsts,
    pos._filename_route as pos_filename_route,
    pos._filename_timestamp as pos_filename_timestamp,
    pos._filename as pos_filename,
    pos._filename_type as pos_filename_type,
    pos._filename_id as pos_filename_id,
    pos._history_id as pos_history_id,
    pos._time_stamp as pos_time_stamp,
    pos._crb_file_name as pos_crb_file_name,
    pos._product_name as pos_product_name,
    pos.lot_idnum as pos_lot_idnum,
    pos._lotnum as pos_lotnum,
    pos._lot as pos_lot,
    pos._mcfilename as pos_mcfilename,
    pos._filter as pos_filter,
    pos._autochg as pos_autochg,
    pos._basechg as pos_basechg,
    pos._lane as pos_lane,
    pos._productionid as pos_productionid,
    pos._simproduct as pos_simproduct,
    pos._dgspcbname as pos_dgspcbname,
    pos._dgspcbrev as pos_dgspcbrev,
    pos._dgspcbside as pos_dgspcbside,
    pos._dgsrefpin as pos_dgsrefpin,
    pos.lot_c as pos_lot_c,
    pos._datagenmode as pos_datagenmode,
    pos._mounthead as pos_mounthead,
    pos._vstpath as pos_vstpath,
    pos._targettact as pos_targettact,
    pos._order as pos_order,
    pos._lot_number as pos_lot_number,
    pos.pos_idnum as pos_idnum,
    pos._cadid as pos_cadid,
    pos._x as pos_x,
    pos._y as pos_y,
    pos._a as pos_a,
    pos._parts as pos_parts,
    pos._brm as pos_brm,
    pos._turn as pos_turn,
    pos._dturn as pos_dturn,
    pos._ts as pos_ts,
    pos._ms as pos_ms,
    pos._ds as pos_ds,
    pos._np as pos_np,
    pos._dnp as pos_dnp,
    pos._pu as pos_pu,
    pos._side as pos_side,
    pos._dpu as pos_dpu,
    pos._head as pos_head,
    pos._dhead as pos_dhead,
    pos._ihead as pos_ihead,
    pos._b as pos_b,
    pos._pg as pos_pg,
    pos._s as pos_s,
    pos._rid as pos_rid,
    pos.pos_c as pos_c,
    pos._m as pos_m,
    pos._mb as pos_mb,
    pos._f as pos_f,
    pos._pr as pos_pr,
    pos._priseq as pos_priseq,
    pos._p as pos_p,
    pos._pad as pos_pad,
    pos._vw as pos_vw,
    pos._stdpos as pos_stdpos,
    pos._land as pos_land,
    pos._depend as pos_depend,
    pos._chkflag as pos_chkflag,
    pos._exchk as pos_exchk,
    pos._grand as pos_grand,
    pos._marea as pos_marea,
    pos._rmset as pos_rmset,
    pos._sh as pos_sh,
    pos._scandir1 as pos_scandir1,
    pos._scandir2 as pos_scandir2,
    pos._ohl as pos_ohl,
    pos._ohr as pos_ohr,
    pos._apcctrl as pos_apcctrl,
    pos._wg as pos_wg,
    pos._skipnumber as pos_skipnumber

from
    u03.index_info_mqt_no_view mqt
inner join
    crb.lot_position_data_no_view pos
on
    upper(pos._crb_file_name) = upper(mqt._mjsid)
and
    upper(pos._lot) = upper(mqt._lotname)
and
    pos.pos_idnum = mqt._idnum
;

create view u03.mqt_pos_data_aoi_no_good_view
as
select
    mqt._filename_route as     mqt_filename_route,
    mqt._machine_order as      mqt_machine_order,
    mqt._lane_no as            mqt_lane_no,
    mqt._stage_no as           mqt_stage_no,
    mqt._filename_timestamp as mqt_filename_timestamp,
    mqt._filename_id as        mqt_filename_id,
    mqt._pcb_serial as         mqt_pcb_serial,
    mqt._pcb_id as             mqt_pcb_id,
    mqt._output_no as          mqt_output_no,
    mqt._pcb_id_lot_no as      mqt_pcb_id_lot_no,
    mqt._pcb_id_serial_no as   mqt_pcb_id_serial_no,
    mqt._mjsid as              mqt_mjsid,
    mqt._bcrstatus as          mqt_bcrstatus,
    mqt._code as               mqt_code,
    mqt._lane as               mqt_lane,
    mqt._lotname as            mqt_lotname,
    mqt._lotnumber as          mqt_lotnumber,
    mqt._output as             mqt_output,
    mqt._planid as             mqt_planid,
    mqt._productid as          mqt_productid,
    mqt._rev as                mqt_rev,
    mqt._serial as             mqt_serial,
    mqt._serialstatus as       mqt_serialstatus,
    mqt._stage as              mqt_stage,
    mqt._b as                  mqt_b,
    mqt._idnum as              mqt_idnum,
    mqt._turn as               mqt_turn,
    mqt._ms as                 mqt_ms,
    mqt._ts as                 mqt_ts,
    mqt._fadd as               mqt_fadd,
    mqt._fsadd as              mqt_fsadd,
    mqt._nhadd as              mqt_nhadd,
    mqt._ncadd as              mqt_ncadd,
    mqt._fblkcode as           mqt_fblkcode,
    mqt._fblkserial as         mqt_fblkserial,
    mqt._nblkcode as           mqt_nblkcode,
    mqt._nblkserial as         mqt_nblkserial,
    mqt._reelid as             mqt_reelid,
    mqt._f as                  mqt_f,
    mqt._rcgx as               mqt_rcgx,
    mqt._rcgy as               mqt_rcgy,
    mqt._rcga as               mqt_rcga,
    mqt._tcx as                mqt_tcx,
    mqt._tcy as                mqt_tcy,
    mqt._mposirecx as          mqt_mposirecx,
    mqt._mposirecy as          mqt_mposirecy,
    mqt._mposireca as          mqt_mposireca,
    mqt._mposirecz as          mqt_mposirecz,
    mqt._thmax as              mqt_thmax,
    mqt._thave as              mqt_thave,
    mqt._mntcx as              mqt_mntcx,
    mqt._mntcy as              mqt_mntcy,
    mqt._mntca as              mqt_mntca,
    mqt._tlx as                mqt_tlx,
    mqt._tly as                mqt_tly,
    mqt._inspectarea as        mqt_inspectarea,
    mqt._didnum as             mqt_didnum,
    mqt._ds as                 mqt_ds,
    mqt._dispenseid as         mqt_dispenseid,
    mqt._parts as              mqt_parts,
    mqt._warpz as              mqt_warpz,
    mqt._prepickuplot as       mqt_prepickuplot,
    mqt._prepickupsts as       mqt_prepickupsts,
    pos._filename_route as     pos_filename_route,
    pos._filename_timestamp as pos_filename_timestamp,
    pos._filename as           pos_filename,
    pos._filename_type as      pos_filename_type,
    pos._filename_id as        pos_filename_id,
    pos._history_id as         pos_history_id,
    pos._time_stamp as         pos_time_stamp,
    pos._crb_file_name as      pos_crb_file_name,
    pos._product_name as       pos_product_name,
    pos.lot_idnum as           pos_lot_idnum,
    pos._lotnum as             pos_lotnum,
    pos._lot as                pos_lot,
    pos._mcfilename as         pos_mcfilename,
    pos._filter as             pos_filter,
    pos._autochg as            pos_autochg,
    pos._basechg as            pos_basechg,
    pos._lane as               pos_lane,
    pos._productionid as       pos_productionid,
    pos._simproduct as         pos_simproduct,
    pos._dgspcbname as         pos_dgspcbname,
    pos._dgspcbrev as          pos_dgspcbrev,
    pos._dgspcbside as         pos_dgspcbside,
    pos._dgsrefpin as          pos_dgsrefpin,
    pos.lot_c as               pos_lot_c,
    pos._datagenmode as        pos_datagenmode,
    pos._mounthead as          pos_mounthead,
    pos._vstpath as            pos_vstpath,
    pos._targettact as         pos_targettact,
    pos._order as              pos_order,
    pos._lot_number as         pos_lot_number,
    pos.pos_idnum as           pos_idnum,
    pos._cadid as              pos_cadid,
    pos._x as                  pos_x,
    pos._y as                  pos_y,
    pos._a as                  pos_a,
    pos._parts as              pos_parts,
    pos._brm as                pos_brm,
    pos._turn as               pos_turn,
    pos._dturn as              pos_dturn,
    pos._ts as                 pos_ts,
    pos._ms as                 pos_ms,
    pos._ds as                 pos_ds,
    pos._np as                 pos_np,
    pos._dnp as                pos_dnp,
    pos._pu as                 pos_pu,
    pos._side as               pos_side,
    pos._dpu as                pos_dpu,
    pos._head as               pos_head,
    pos._dhead as              pos_dhead,
    pos._ihead as              pos_ihead,
    pos._b as                  pos_b,
    pos._pg as                 pos_pg,
    pos._s as                  pos_s,
    pos._rid as                pos_rid,
    pos.pos_c as               pos_c,
    pos._m as                  pos_m,
    pos._mb as                 pos_mb,
    pos._f as                  pos_f,
    pos._pr as                 pos_pr,
    pos._priseq as             pos_priseq,
    pos._p as                  pos_p,
    pos._pad as                pos_pad,
    pos._vw as                 pos_vw,
    pos._stdpos as             pos_stdpos,
    pos._land as               pos_land,
    pos._depend as             pos_depend,
    pos._chkflag as            pos_chkflag,
    pos._exchk as              pos_exchk,
    pos._grand as              pos_grand,
    pos._marea as              pos_marea,
    pos._rmset as              pos_rmset,
    pos._sh as                 pos_sh,
    pos._scandir1 as           pos_scandir1,
    pos._scandir2 as           pos_scandir2,
    pos._ohl as                pos_ohl,
    pos._ohr as                pos_ohr,
    pos._apcctrl as            pos_apcctrl,
    pos._wg as                 pos_wg,
    pos._skipnumber as         pos_skipnumber,
    aoi._filename as           aoi_filename,
    aoi._filename_type as      aoi_filename_type,
    aoi._filename_timestamp as aoi_filename_timestamp,
    aoi._filename_route as     aoi_filename_route,
    aoi._filename_id as        aoi_filename_id,
    aoi._aoi_pcbid as          aoi_aoi_pcbid,
    aoi._date_time as          aoi_date_time,
    aoi._cid as                aoi_cid,
    aoi._timestamp as          aoi_timestamp,
    aoi._crc as                aoi_crc,
    aoi._c2d as                aoi_c2d,
    aoi._recipename as         aoi_recipename,
    aoi._mid as                aoi_mid,
    aoi._p as                  aoi_p,
    aoi.cmp_idx as             aoi_cmp_idx,
    aoi._sc as                 aoi_sc,
    aoi._pid as                aoi_pid,
    aoi._fc as                 aoi_fc,
    aoi._cmp as                aoi_cmp,
    aoi._cc as                 aoi_cc,
    aoi._ref as                aoi_ref,
    aoi._type as               aoi_type,
    aoi._defect as             aoi_defect,
    aoi._insp_type as          aoi_insp_type,
    aoi._lead_id as            aoi_lead_id
from
    u03.index_info_mqt_no_view mqt
inner join
    crb.lot_position_data_no_view pos
on
    upper(pos._crb_file_name) = upper(mqt._mjsid)
and
    upper(pos._lot) = upper(mqt._lotname)
and
    pos.pos_idnum = mqt._idnum
inner join
    aoi.no_good_no_view aoi
on
    upper(aoi._c2d) = upper(mqt._pcb_id)
and
    upper(aoi._recipename) = upper(pos._dgspcbname)
and
    upper(aoi._ref) = upper(pos.pos_c)
;

create view u03.mqt_pos_data_aoi_good_view
as
select
    mqt._filename_route as     mqt_filename_route,
    mqt._machine_order as      mqt_machine_order,
    mqt._lane_no as            mqt_lane_no,
    mqt._stage_no as           mqt_stage_no,
    mqt._filename_timestamp as mqt_filename_timestamp,
    mqt._filename_id as        mqt_filename_id,
    mqt._pcb_serial as         mqt_pcb_serial,
    mqt._pcb_id as             mqt_pcb_id,
    mqt._output_no as          mqt_output_no,
    mqt._pcb_id_lot_no as      mqt_pcb_id_lot_no,
    mqt._pcb_id_serial_no as   mqt_pcb_id_serial_no,
    mqt._mjsid as              mqt_mjsid,
    mqt._bcrstatus as          mqt_bcrstatus,
    mqt._code as               mqt_code,
    mqt._lane as               mqt_lane,
    mqt._lotname as            mqt_lotname,
    mqt._lotnumber as          mqt_lotnumber,
    mqt._output as             mqt_output,
    mqt._planid as             mqt_planid,
    mqt._productid as          mqt_productid,
    mqt._rev as                mqt_rev,
    mqt._serial as             mqt_serial,
    mqt._serialstatus as       mqt_serialstatus,
    mqt._stage as              mqt_stage,
    mqt._b as                  mqt_b,
    mqt._idnum as              mqt_idnum,
    mqt._turn as               mqt_turn,
    mqt._ms as                 mqt_ms,
    mqt._ts as                 mqt_ts,
    mqt._fadd as               mqt_fadd,
    mqt._fsadd as              mqt_fsadd,
    mqt._nhadd as              mqt_nhadd,
    mqt._ncadd as              mqt_ncadd,
    mqt._fblkcode as           mqt_fblkcode,
    mqt._fblkserial as         mqt_fblkserial,
    mqt._nblkcode as           mqt_nblkcode,
    mqt._nblkserial as         mqt_nblkserial,
    mqt._reelid as             mqt_reelid,
    mqt._f as                  mqt_f,
    mqt._rcgx as               mqt_rcgx,
    mqt._rcgy as               mqt_rcgy,
    mqt._rcga as               mqt_rcga,
    mqt._tcx as                mqt_tcx,
    mqt._tcy as                mqt_tcy,
    mqt._mposirecx as          mqt_mposirecx,
    mqt._mposirecy as          mqt_mposirecy,
    mqt._mposireca as          mqt_mposireca,
    mqt._mposirecz as          mqt_mposirecz,
    mqt._thmax as              mqt_thmax,
    mqt._thave as              mqt_thave,
    mqt._mntcx as              mqt_mntcx,
    mqt._mntcy as              mqt_mntcy,
    mqt._mntca as              mqt_mntca,
    mqt._tlx as                mqt_tlx,
    mqt._tly as                mqt_tly,
    mqt._inspectarea as        mqt_inspectarea,
    mqt._didnum as             mqt_didnum,
    mqt._ds as                 mqt_ds,
    mqt._dispenseid as         mqt_dispenseid,
    mqt._parts as              mqt_parts,
    mqt._warpz as              mqt_warpz,
    mqt._prepickuplot as       mqt_prepickuplot,
    mqt._prepickupsts as       mqt_prepickupsts,
    pos._filename_route as     pos_filename_route,
    pos._filename_timestamp as pos_filename_timestamp,
    pos._filename as           pos_filename,
    pos._filename_type as      pos_filename_type,
    pos._filename_id as        pos_filename_id,
    pos._history_id as         pos_history_id,
    pos._time_stamp as         pos_time_stamp,
    pos._crb_file_name as      pos_crb_file_name,
    pos._product_name as       pos_product_name,
    pos.lot_idnum as           pos_lot_idnum,
    pos._lotnum as             pos_lotnum,
    pos._lot as                pos_lot,
    pos._mcfilename as         pos_mcfilename,
    pos._filter as             pos_filter,
    pos._autochg as            pos_autochg,
    pos._basechg as            pos_basechg,
    pos._lane as               pos_lane,
    pos._productionid as       pos_productionid,
    pos._simproduct as         pos_simproduct,
    pos._dgspcbname as         pos_dgspcbname,
    pos._dgspcbrev as          pos_dgspcbrev,
    pos._dgspcbside as         pos_dgspcbside,
    pos._dgsrefpin as          pos_dgsrefpin,
    pos.lot_c as               pos_lot_c,
    pos._datagenmode as        pos_datagenmode,
    pos._mounthead as          pos_mounthead,
    pos._vstpath as            pos_vstpath,
    pos._targettact as         pos_targettact,
    pos._order as              pos_order,
    pos._lot_number as         pos_lot_number,
    pos.pos_idnum as           pos_idnum,
    pos._cadid as              pos_cadid,
    pos._x as                  pos_x,
    pos._y as                  pos_y,
    pos._a as                  pos_a,
    pos._parts as              pos_parts,
    pos._brm as                pos_brm,
    pos._turn as               pos_turn,
    pos._dturn as              pos_dturn,
    pos._ts as                 pos_ts,
    pos._ms as                 pos_ms,
    pos._ds as                 pos_ds,
    pos._np as                 pos_np,
    pos._dnp as                pos_dnp,
    pos._pu as                 pos_pu,
    pos._side as               pos_side,
    pos._dpu as                pos_dpu,
    pos._head as               pos_head,
    pos._dhead as              pos_dhead,
    pos._ihead as              pos_ihead,
    pos._b as                  pos_b,
    pos._pg as                 pos_pg,
    pos._s as                  pos_s,
    pos._rid as                pos_rid,
    pos.pos_c as               pos_c,
    pos._m as                  pos_m,
    pos._mb as                 pos_mb,
    pos._f as                  pos_f,
    pos._pr as                 pos_pr,
    pos._priseq as             pos_priseq,
    pos._p as                  pos_p,
    pos._pad as                pos_pad,
    pos._vw as                 pos_vw,
    pos._stdpos as             pos_stdpos,
    pos._land as               pos_land,
    pos._depend as             pos_depend,
    pos._chkflag as            pos_chkflag,
    pos._exchk as              pos_exchk,
    pos._grand as              pos_grand,
    pos._marea as              pos_marea,
    pos._rmset as              pos_rmset,
    pos._sh as                 pos_sh,
    pos._scandir1 as           pos_scandir1,
    pos._scandir2 as           pos_scandir2,
    pos._ohl as                pos_ohl,
    pos._ohr as                pos_ohr,
    pos._apcctrl as            pos_apcctrl,
    pos._wg as                 pos_wg,
    pos._skipnumber as         pos_skipnumber,
    aoi._filename as           aoi_filename,
    aoi._filename_type as      aoi_filename_type,
    aoi._filename_timestamp as aoi_filename_timestamp,
    aoi._filename_route as     aoi_filename_route,
    aoi._filename_id as        aoi_filename_id,
    aoi._aoi_pcbid as          aoi_aoi_pcbid,
    aoi._date_time as          aoi_date_time,
    aoi._cid as                aoi_cid,
    aoi._timestamp as          aoi_timestamp,
    aoi._crc as                aoi_crc,
    aoi._c2d as                aoi_c2d,
    aoi._recipename as         aoi_recipename,
    aoi._mid as                aoi_mid,
    aoi._p as                  aoi_p,
    aoi.cmp_idx as             aoi_cmp_idx,
    aoi._sc as                 aoi_sc,
    aoi._pid as                aoi_pid,
    aoi._fc as                 aoi_fc
from
    u03.index_info_mqt_no_view mqt
inner join
    crb.lot_position_data_no_view pos
on
    upper(pos._crb_file_name) = upper(mqt._mjsid)
and
    upper(pos._lot) = upper(mqt._lotname)
and
    pos.pos_idnum = mqt._idnum
inner join
    aoi.good_no_view aoi
on
    upper(aoi._c2d) = upper(mqt._pcb_id)
and
    upper(aoi._recipename) = upper(pos._dgspcbname)
;


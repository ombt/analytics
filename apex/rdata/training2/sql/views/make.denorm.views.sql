-- 
-- drop view if exists aoi.all_view
-- ;
-- drop view if exists aoi.information_view
-- ;
-- drop view if exists aoi.lotinformation_view
-- ;
-- drop view if exists u01.count_view
-- ;
-- drop view if exists u01.time_view
-- ;
-- drop view if exists u01.feeder_view
-- ;
-- drop view if exists u01.nozzle_view
-- ;
-- drop view if exists u03.mountexchangereel_view
-- ;
-- drop view if exists u03.mountlatestreel_view
-- ;
-- drop view if exists u03.mountnormaltrace_view
-- ;
-- drop view if exists u03.mountqualitytrace_view
-- ;
-- 
-- 
-- create view aoi.all_view
-- as
-- select
--     ftf._filename_route,
--     rfd._machine,
--     rfd._lane,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- rfd._filename_id,
--     rfd._date_time,
--     rfd._serial_number,
--     rfd._inspection_result,
--     rfd._board_removed,
--     -- pi._filename_id,
--     pi._pcbid,
--     -- pli._filename_id,
--     pli._comment1,
--     pli._comment2,
--     pli._comment3,
--     pli._lot,
--     pli._modelid,
--     pli._productdata,
--     pli._side
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.rst_filename_data rfd
-- on
--     rfd._filename_id = ftf._filename_id
-- inner join
--     aoi.pivot_information pi
-- on
--     pi._filename_id = ftf._filename_id
-- inner join
--     aoi.pivot_lotinformation pli
-- on
--     pli._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     rfd._machine,
--     rfd._lane,
--     ftf._filename_timestamp
-- ;
-- create view aoi.information_view
-- as
-- select
--     ftf._filename_route,
--     rfd._machine,
--     rfd._lane,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- rfd._filename_id,
--     rfd._date_time,
--     rfd._serial_number,
--     rfd._inspection_result,
--     rfd._board_removed,
--     -- pi._filename_id,
--     pi._pcbid
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.rst_filename_data rfd
-- on
--     rfd._filename_id = ftf._filename_id
-- inner join
--     aoi.pivot_information pi
-- on
--     pi._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     rfd._machine,
--     rfd._lane,
--     ftf._filename_timestamp
-- ;
-- create view aoi.lotinformation_view
-- as
-- select
--     ftf._filename_route,
--     rfd._machine,
--     rfd._lane,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- rfd._filename_id,
--     rfd._date_time,
--     rfd._serial_number,
--     rfd._inspection_result,
--     rfd._board_removed,
--     -- pli._filename_id,
--     pli._comment1,
--     pli._comment2,
--     pli._comment3,
--     pli._lot,
--     pli._modelid,
--     pli._productdata,
--     pli._side
-- from
--     aoi.filename_to_fid ftf
-- inner join
--     aoi.rst_filename_data rfd
-- on
--     rfd._filename_id = ftf._filename_id
-- inner join
--     aoi.pivot_lotinformation pli
-- on
--     pli._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     rfd._machine,
--     rfd._lane,
--     ftf._filename_timestamp
-- ;
-- create view u01.count_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- dpc._filename_id,
--     -- dpc._pcb_id,
--     -- dpc._pcb_serial,
--     -- dpc._machine_order,
--     -- dpc._lane_no,
--     -- dpc._stage_no,
--     dpc._timestamp,
--     dpc._mjsid,
--     dpc._lotname,
--     -- dpc._output_no,
--     dpc._bndrcgstop,
--     dpc._bndstop,
--     dpc._board,
--     dpc._brcgstop,
--     dpc._bwait,
--     dpc._cderr,
--     dpc._cmerr,
--     dpc._cnvstop,
--     dpc._cperr,
--     dpc._crerr,
--     dpc._cterr,
--     dpc._cwait,
--     dpc._fbstop,
--     dpc._fwait,
--     dpc._jointpasswait,
--     dpc._judgestop,
--     dpc._lotboard,
--     dpc._lotmodule,
--     dpc._mcfwait,
--     dpc._mcrwait,
--     dpc._mhrcgstop,
--     dpc._module,
--     dpc._otherlstop,
--     dpc._othrstop,
--     dpc._pwait,
--     dpc._rwait,
--     dpc._scestop,
--     dpc._scstop,
--     dpc._swait,
--     dpc._tdispense,
--     dpc._tdmiss,
--     dpc._thmiss,
--     dpc._tmmiss,
--     dpc._tmount,
--     dpc._tpickup,
--     dpc._tpmiss,
--     dpc._tpriming,
--     dpc._trbl,
--     dpc._trmiss,
--     dpc._trserr,
--     dpc._trsmiss
-- from
--     u01.filename_to_fid ftf
-- inner join
--     u01.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u01.delta_pivot_count dpc
-- on
--     dpc._filename_id = ftf._filename_id
-- and
--     dpc._lane_no = ufd._lane_no
-- and
--     dpc._stage_no = ufd._stage_no
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp
-- ;
-- create view u01.time_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- dpt._filename_id,
--     -- dpt._pcb_id,
--     -- dpt._pcb_serial,
--     -- dpt._machine_order,
--     -- dpt._lane_no,
--     -- dpt._stage_no,
--     dpt._timestamp,
--     dpt._mjsid,
--     dpt._lotname,
--     -- dpt._output_no,
--     dpt._actual,
--     dpt._bndrcgstop,
--     dpt._bndstop,
--     dpt._brcg,
--     dpt._brcgstop,
--     dpt._bwait,
--     dpt._cderr,
--     dpt._change,
--     dpt._cmerr,
--     dpt._cnvstop,
--     dpt._cperr,
--     dpt._crerr,
--     dpt._cterr,
--     dpt._cwait,
--     dpt._dataedit,
--     dpt._fbstop,
--     dpt._fwait,
--     dpt._idle,
--     dpt._jointpasswait,
--     dpt._judgestop,
--     dpt._load,
--     dpt._mcfwait,
--     dpt._mcrwait,
--     dpt._mente,
--     dpt._mhrcgstop,
--     dpt._mount,
--     dpt._otherlstop,
--     dpt._othrstop,
--     dpt._poweron,
--     dpt._prdstop,
--     dpt._prod,
--     dpt._prodview,
--     dpt._pwait,
--     dpt._rwait,
--     dpt._scestop,
--     dpt._scstop,
--     dpt._swait,
--     dpt._totalstop,
--     dpt._trbl,
--     dpt._trserr,
--     dpt._unitadjust
-- from
--     u01.filename_to_fid ftf
-- inner join
--     u01.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u01.delta_pivot_time dpt
-- on
--     dpt._filename_id = ftf._filename_id
-- and
--     dpt._lane_no = ufd._lane_no
-- and
--     dpt._stage_no = ufd._stage_no
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp
-- ;
-- create view u01.feeder_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     df._fadd,
--     df._fsadd,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- df._filename_id,
--     -- df._pcb_id,
--     -- df._pcb_serial,
--     -- df._machine_order,
--     -- df._lane_no,
--     -- df._stage_no,
--     df._timestamp,
--     df._mjsid,
--     df._lotname,
--     df._reelid,
--     df._partsname,
--     -- df._output_no,
--     df._blkserial,
--     df._pickup,
--     df._pmiss,
--     df._rmiss,
--     df._dmiss,
--     df._mmiss,
--     df._hmiss,
--     df._trsmiss,
--     df._mount
-- from
--     u01.filename_to_fid ftf
-- inner join
--     u01.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u01.delta_feeder df
-- on
--     df._filename_id = ftf._filename_id
-- and
--     df._lane_no = ufd._lane_no
-- and
--     df._stage_no = ufd._stage_no
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     df._fadd,
--     df._fsadd
-- ;
-- create view u01.nozzle_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- dn._filename_id,
--     -- dn._pcb_id,
--     -- dn._pcb_serial,
--     -- dn._machine_order,
--     -- dn._lane_no,
--     -- dn._stage_no,
--     dn._timestamp,
--     dn._nhadd,
--     dn._ncadd,
--     dn._mjsid,
--     dn._lotname,
--     -- dn._output_no,
--     dn._pickup,
--     dn._pmiss,
--     dn._rmiss,
--     dn._dmiss,
--     dn._mmiss,
--     dn._hmiss,
--     dn._trsmiss,
--     dn._mount
-- from
--     u01.filename_to_fid ftf
-- inner join
--     u01.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u01.delta_nozzle as dn
-- on
--     dn._filename_id = ftf._filename_id
-- and
--     dn._lane_no = ufd._lane_no
-- and
--     dn._stage_no = ufd._stage_no
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     dn._nhadd,
--     dn._ncadd
-- ;
-- create view u03.mountexchangereel_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mxr._fadd,
--     mxr._fsadd,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- mxr._filename_id,
--     mxr._blkcode,
--     mxr._blkserial,
--     mxr._ftype,
--     mxr._use,
--     mxr._pestatus,
--     mxr._pcstatus,
--     mxr._remain,
--     mxr._init,
--     mxr._partsname,
--     mxr._custom1,
--     mxr._custom2,
--     mxr._custom3,
--     mxr._custom4,
--     mxr._reelid,
--     mxr._partsemp,
--     mxr._active
-- from
--     u03.filename_to_fid ftf
-- inner join
--     u03.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u03.mountexchangereel mxr
-- on
--     mxr._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mxr._fadd,
--     mxr._fsadd
-- ;
-- create view u03.mountlatestreel_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mlr._fadd,
--     mlr._fsadd,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- mlr._filename_id,
--     mlr._blkcode,
--     mlr._blkserial,
--     mlr._ftype,
--     mlr._use,
--     mlr._pestatus,
--     mlr._pcstatus,
--     mlr._remain,
--     mlr._init,
--     mlr._partsname,
--     mlr._custom1,
--     mlr._custom2,
--     mlr._custom3,
--     mlr._custom4,
--     mlr._reelid,
--     mlr._partsemp,
--     mlr._active,
--     mlr._tgserial
-- from
--     u03.filename_to_fid ftf
-- inner join
--     u03.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u03.mountlatestreel mlr
-- on
--     mlr._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mlr._fadd,
--     mlr._fsadd
-- ;
-- create view u03.mountnormaltrace_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     mnt._fadd,
--     mnt._fsadd,
--     mnt._nhadd,
--     mnt._ncadd,
--     ftf._filename_timestamp,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- mnt._filename_id,
--     mnt._b,
--     mnt._idnum,
--     mnt._reelid
-- from
--     u03.filename_to_fid ftf
-- inner join
--     u03.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u03.mountnormaltrace mnt
-- on
--     mnt._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mnt._fadd,
--     mnt._fsadd,
--     mnt._nhadd,
--     mnt._ncadd
-- ;
-- create view u03.mountqualitytrace_view
-- as
-- select
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mqt._fadd,
--     mqt._fsadd,
--     mqt._nhadd,
--     mqt._ncadd,
--     ftf._filename,
--     ftf._filename_type,
--     ftf._filename_id,
--     -- ufd._filename_id,
--     ufd._date,
--     ufd._pcb_serial,
--     ufd._pcb_id,
--     ufd._output_no,
--     ufd._pcb_id_lot_no,
--     ufd._pcb_id_serial_no,
--     -- mqt._filename_id,
--     mqt._b,
--     mqt._idnum,
--     mqt._turn,
--     mqt._ms,
--     mqt._ts,
--     mqt._fblkcode,
--     mqt._fblkserial,
--     mqt._nblkcode,
--     mqt._nblkserial,
--     mqt._reelid,
--     mqt._f,
--     mqt._rcgx,
--     mqt._rcgy,
--     mqt._rcga,
--     mqt._tcx,
--     mqt._tcy,
--     mqt._mposirecx,
--     mqt._mposirecy,
--     mqt._mposireca,
--     mqt._mposirecz,
--     mqt._thmax,
--     mqt._thave,
--     mqt._mntcx,
--     mqt._mntcy,
--     mqt._mntca,
--     mqt._tlx,
--     mqt._tly,
--     mqt._inspectarea,
--     mqt._didnum,
--     mqt._ds,
--     mqt._dispenseid,
--     mqt._parts,
--     mqt._warpz,
--     mqt._prepickuplot,
--     mqt._prepickupsts
-- from
--     u03.filename_to_fid ftf
-- inner join
--     u03.u0x_filename_data ufd
-- on
--     ufd._filename_id = ftf._filename_id
-- inner join
--     u03.mountqualitytrace mqt
-- on
--     mqt._filename_id = ftf._filename_id
-- order by
--     ftf._filename_route,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     ftf._filename_timestamp,
--     mqt._fadd,
--     mqt._fsadd,
--     mqt._nhadd,
--     mqt._ncadd
-- ;
-- 

drop view if exists aoi.denorm_view
;

create view aoi.denorm_view
as
select
    aoiv._filename_route     as aoi_filename_route,
    aoiv._machine            as aoi_machine,
    aoiv._lane               as aoi_lane,
    aoiv._filename_timestamp as aoi_filename_timestamp,
    aoiv._filename           as aoi_filename,
    aoiv._filename_type      as aoi_filename_type,
    aoiv._filename_id        as aoi_filename_id,
    aoiv._date_time          as aoi_date_time,
    aoiv._serial_number      as aoi_serial_number,
    aoiv._pcbid              as aoi_pcbid,
    aoiv._comment1           as aoi_comment1,
    aoiv._comment2           as aoi_comment2,
    aoiv._comment3           as aoi_comment3,
    aoiv._lot                as aoi_lot,
    aoiv._modelid            as aoi_modelid,
    aoiv._productdata        as aoi_productdata,
    aoiv._side               as aoi_side,

    u01cv._filename_route     as u01c_filename_route,
    u01cv._machine_order      as u01c_machine_order,
    u01cv._lane_no            as u01c_lane_no,
    u01cv._stage_no           as u01c_stage_no,
    u01cv._filename_timestamp as u01c_filename_timestamp,
    u01cv._filename           as u01c_filename,
    u01cv._filename_type      as u01c_filename_type,
    u01cv._filename_id        as u01c_filename_id,
    u01cv._date               as u01c_date,
    u01cv._pcb_serial         as u01c_pcb_serial,
    u01cv._pcb_id             as u01c_pcb_id,
    u01cv._output_no          as u01c_output_no,
    u01cv._pcb_id_lot_no      as u01c_pcb_id_lot_no,
    u01cv._pcb_id_serial_no   as u01c_pcb_id_serial_no,
    u01cv._timestamp          as u01c_timestamp,
    u01cv._mjsid              as u01c_mjsid,
    u01cv._lotname            as u01c_lotname,
    u01cv._bndrcgstop         as u01c_bndrcgstop,
    u01cv._bndstop            as u01c_bndstop,
    u01cv._board              as u01c_board,
    u01cv._brcgstop           as u01c_brcgstop,
    u01cv._bwait              as u01c_bwait,
    u01cv._cderr              as u01c_cderr,
    u01cv._cmerr              as u01c_cmerr,
    u01cv._cnvstop            as u01c_cnvstop,
    u01cv._cperr              as u01c_cperr,
    u01cv._crerr              as u01c_crerr,
    u01cv._cterr              as u01c_cterr,
    u01cv._cwait              as u01c_cwait,
    u01cv._fbstop             as u01c_fbstop,
    u01cv._fwait              as u01c_fwait,
    u01cv._jointpasswait      as u01c_jointpasswait,
    u01cv._judgestop          as u01c_judgestop,
    u01cv._lotboard           as u01c_lotboard,
    u01cv._lotmodule          as u01c_lotmodule,
    u01cv._mcfwait            as u01c_mcfwait,
    u01cv._mcrwait            as u01c_mcrwait,
    u01cv._mhrcgstop          as u01c_mhrcgstop,
    u01cv._module             as u01c_module,
    u01cv._otherlstop         as u01c_otherlstop,
    u01cv._othrstop           as u01c_othrstop,
    u01cv._pwait              as u01c_pwait,
    u01cv._rwait              as u01c_rwait,
    u01cv._scestop            as u01c_scestop,
    u01cv._scstop             as u01c_scstop,
    u01cv._swait              as u01c_swait,
    u01cv._tdispense          as u01c_tdispense,
    u01cv._tdmiss             as u01c_tdmiss,
    u01cv._thmiss             as u01c_thmiss,
    u01cv._tmmiss             as u01c_tmmiss,
    u01cv._tmount             as u01c_tmount,
    u01cv._tpickup            as u01c_tpickup,
    u01cv._tpmiss             as u01c_tpmiss,
    u01cv._tpriming           as u01c_tpriming,
    u01cv._trbl               as u01c_trbl,
    u01cv._trmiss             as u01c_trmiss,
    u01cv._trserr             as u01c_trserr,
    u01cv._trsmiss            as u01c_trsmiss,

    u01tv._filename_route     as u01tv_filename_route,
    u01tv._machine_order      as u01tv_machine_order,
    u01tv._lane_no            as u01tv_lane_no,
    u01tv._stage_no           as u01tv_stage_no,
    u01tv._filename_timestamp as u01tv_filename_timestamp,
    u01tv._filename           as u01tv_filename,
    u01tv._filename_type      as u01tv_filename_type,
    u01tv._filename_id        as u01tv_filename_id,
    u01tv._date               as u01tv_date,
    u01tv._pcb_serial         as u01tv_pcb_serial,
    u01tv._pcb_id             as u01tv_pcb_id,
    u01tv._output_no          as u01tv_output_no,
    u01tv._pcb_id_lot_no      as u01tv_pcb_id_lot_no,
    u01tv._pcb_id_serial_no   as u01tv_pcb_id_serial_no,
    u01tv._timestamp          as u01tv_timestamp,
    u01tv._mjsid              as u01tv_mjsid,
    u01tv._lotname            as u01tv_lotname,
    u01tv._actual             as u01tv_actual,
    u01tv._bndrcgstop         as u01tv_bndrcgstop,
    u01tv._bndstop            as u01tv_bndstop,
    u01tv._brcg               as u01tv_brcg,
    u01tv._brcgstop           as u01tv_brcgstop,
    u01tv._bwait              as u01tv_bwait,
    u01tv._cderr              as u01tv_cderr,
    u01tv._change             as u01tv_change,
    u01tv._cmerr              as u01tv_cmerr,
    u01tv._cnvstop            as u01tv_cnvstop,
    u01tv._cperr              as u01tv_cperr,
    u01tv._crerr              as u01tv_crerr,
    u01tv._cterr              as u01tv_cterr,
    u01tv._cwait              as u01tv_cwait,
    u01tv._dataedit           as u01tv_dataedit,
    u01tv._fbstop             as u01tv_fbstop,
    u01tv._fwait              as u01tv_fwait,
    u01tv._idle               as u01tv_idle,
    u01tv._jointpasswait      as u01tv_jointpasswait,
    u01tv._judgestop          as u01tv_judgestop,
    u01tv._load               as u01tv_load,
    u01tv._mcfwait            as u01tv_mcfwait,
    u01tv._mcrwait            as u01tv_mcrwait,
    u01tv._mente              as u01tv_mente,
    u01tv._mhrcgstop          as u01tv_mhrcgstop,
    u01tv._mount              as u01tv_mount,
    u01tv._otherlstop         as u01tv_otherlstop,
    u01tv._othrstop           as u01tv_othrstop,
    u01tv._poweron            as u01tv_poweron,
    u01tv._prdstop            as u01tv_prdstop,
    u01tv._prod               as u01tv_prod,
    u01tv._prodview           as u01tv_prodview,
    u01tv._pwait              as u01tv_pwait,
    u01tv._rwait              as u01tv_rwait,
    u01tv._scestop            as u01tv_scestop,
    u01tv._scstop             as u01tv_scstop,
    u01tv._swait              as u01tv_swait,
    u01tv._totalstop          as u01tv_totalstop,
    u01tv._trbl               as u01tv_trbl,
    u01tv._trserr             as u01tv_trserr,
    u01tv._unitadjust         as u01tv_unitadjust
from
    aoi.all_view aoiv
inner join
    u01.count_view u01cv
on
    u01cv._pcb_id = aoiv._pcbid
and
    u01cv._lane_no = aoiv._lane
inner join
    u01.time_view u01tv
on
    u01tv._pcb_id = aoiv._pcbid
and
    u01tv._lane_no = aoiv._lane
;

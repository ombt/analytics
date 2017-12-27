
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
    u03.index_info_mqt_view mqt
inner join
    crb.lot_position_data_view pos
on
    upper(pos._crb_file_name) = upper(mqt._mjsid)
and
    upper(pos._lot) = upper(mqt._lotname)
and
    pos.pos_idnum = mqt._idnum
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
    u03.index_info_mqt_view mqt
inner join
    crb.lot_position_data_view pos
on
    upper(pos._crb_file_name) = upper(mqt._mjsid)
and
    upper(pos._lot) = upper(mqt._lotname)
and
    pos.pos_idnum = mqt._idnum
inner join
    aoi.good_view aoi
on
    upper(aoi._c2d) = upper(mqt._pcb_id)
and
    upper(aoi._recipename) = upper(pos._dgspcbname)
;

create view u01.pa_pcb_status_per_machine_view
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
    -- ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no
    -- upi._filename_id,
    -- upi._bcrstatus,
    -- upi._code,
    -- upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    -- upi._planid,
    upi._productid,
    -- upi._rev,
    upi._serial,
    -- upi._serialstatus,
    -- upi._stage,
    -- i._filename_id,
    -- i._cid,
    -- i._timestamp,
    -- i._crc,
    i._c2d,
    i._recipename,
    -- i._mid,
    -- p._filename_id,
    -- p._p,
    -- p._cmp as cmp_idx,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status
    -- p._sc,
    -- p._pid,
    -- p._fc
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
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
where
    ufd._output_no in ( 3, 4 )
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u03.pcb_mqt_pos_aoi_data_view
as
select
    ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    ftf._filename_timestamp as ftf_filename_timestamp,
    ftf._filename as ftf_filename,
    ftf._filename_type as ftf_filename_type,
    ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    ufd._date as ufd_date,
    ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    ufd._output_no as ufd_output_no,
    ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    upx._filename_id as upx_filename_id,
    upx._author as upx_author,
    upx._authortype as upx_authortype,
    upx._comment as upx_comment,
    upx._date as upx_date,
    upx._diff as upx_diff,
    upx._format as upx_format,
    upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    upx._version as upx_version,
    upi._filename_id as upi_filename_id,
    upi._bcrstatus as upi_bcrstatus,
    upi._code as upi_code,
    upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    upi._lotnumber as upi_lotnumber,
    upi._output as upi_output,
    upi._planid as upi_planid,
    upi._productid as upi_productid,
    upi._rev as upi_rev,
    upi._serial as upi_serial,
    upi._serialstatus as upi_serialstatus,
    upi._stage as upi_stage,
    aftf._filename as aftf_filename,
    aftf._filename_type as aftf_filename_type,
    aftf._filename_timestamp as aftf_filename_timestamp,
    aftf._filename_route as aftf_filename_route,
    aftf._filename_id as aftf_fid,
    aafd._filename_id as aafd_filename_id,
    aafd._aoi_pcbid as aafd_aoi_pcbid,
    aafd._date_time as aafd_date_time,
    ai._filename_id as ai_filename_id,
    ai._cid as ai_cid,
    ai._timestamp as ai_timestamp,
    ai._crc as ai_crc,
    ai._c2d as ai_c2d,
    ai._recipename as ai_recipename,
    ai._mid as ai_mid,
    ap._filename_id as ap_filename_id,
    ap._p as ap_p,
    ap._cmp as ap_cmp,
    case
        when (ap._cmp = -1) then 'PASSED'
        when (ap._cmp = 1) then 'FAILED'
        else 'UNKNOWN'
    end as ap_board_status,
    ap._sc as ap_sc,
    ap._pid as ap_pid,
    ap._fc as ap_fc,
    mqt._filename_id as mqt_filename_id,
    mqt._b as mqt_b,
    mqt._idnum as mqt_idnum,
    mqt._turn as mqt_turn,
    mqt._ms as mqt_ms,
    mqt._ts as mqt_ts,
    mqt._fadd as mqt_fadd,
    mqt._fsadd as mqt_fsadd,
    mqt._fblkcode as mqt_fblkcode,
    mqt._fblkserial as mqt_fblkserial,
    mqt._nhadd as mqt_nhadd,
    mqt._ncadd as mqt_ncadd,
    mqt._nblkcode as mqt_nblkcode,
    mqt._nblkserial as mqt_nblkserial,
    mqt._reelid as mqt_reelid,
    mqt._f as mqt_f,
    case
        when (mqt._f = 0) then 'MOUNT SUCCESS'
        when (mqt._f = 1) then 'EXHAUST'
        when (mqt._f = 2) then 'PICK UP ERROR BY VACUUM SENSOR DETECTION'
        when (mqt._f = 3) then 'PICK UP ERROR BY RECOGNITION'
        when (mqt._f = 4) then 'COMPONENT STAND ERROR'
        when (mqt._f = 5) then 'RECOGNITION ERROR'
        when (mqt._f = 6) then 'DROP ERROR'
        when (mqt._f = 7) then 'MOUNT ERROR'
        when (mqt._f = 8) then 'BLOW OUT ERROR'
        when (mqt._f = 9) then 'NO MOUNT OR INVALID BY MOUNT SUSPEND'
        when (mqt._f = 10) then 'BAD NOZZLE PICK UP ERROR'
        when (mqt._f = 11) then 'BAD NOZZLE RECOGNITION ERROR'
        when (mqt._f = 12) then 'CONTINUE START'
        when (mqt._f = 13) then 'APC MOUNT CANCEL'
        when (mqt._f = 14) then 'MOUNT BLOW ERROR'
        when (mqt._f = 15) then 'DETECT TAPE CHANGE'
        when (mqt._f = 16) then 'COMPONENT THICKNESS ERROR'
        when (mqt._f = 17) then 'PICK UP ERROR WHEN COUNT MANDATORY'
        when (mqt._f = 18) then 'LEAD/BALL FLOAT ERROR'
        when (mqt._f = 19) then 'DETECT SHIFT PICK UP POSITION'
        when (mqt._f = 20) then 'COMPONENT DROP DIPPING UNIT'
        else 'UNKNOWN FAILURE'
    end as mqt_attempt_status,
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
    ccfd._filename_id as crb_fid,
    ccfd._history_id as ccfd_history_id,
    ccfd._time_stamp as ccfd_time_stamp,
    ccfd._crb_file_name as ccfd_crb_file_name,
    ccfd._product_name as ccfd_product_name,
    cl._filename_id as cl_filename_id,
    cl._idnum as cl_idnum,
    cl._lotnum as cl_lotnum,
    cl._lot as cl_lot,
    cl._mcfilename as cl_mcfilename,
    cl._filter as cl_filter,
    cl._autochg as cl_autochg,
    cl._basechg as cl_basechg,
    cl._lane as cl_lane,
    cl._productionid as cl_productionid,
    cl._simproduct as cl_simproduct,
    cl._dgspcbname as cl_dgspcbname,
    cl._dgspcbrev as cl_dgspcbrev,
    cl._dgspcbside as cl_dgspcbside,
    cl._dgsrefpin as cl_dgsrefpin,
    cl._c as cl_c,
    cl._datagenmode as cl_datagenmode,
    cl._mounthead as cl_mounthead,
    cl._vstpath as cl_vstpath,
    cl._order as cl_order,
    cl._targettact as cl_targettact,
    cp._filename_id as cp_filename_id,
    cp._lot_number as cp_lot_number,
    cp._idnum as cp_idnum,
    cp._cadid as cp_cadid,
    cp._x as cp_x,
    cp._y as cp_y,
    cp._a as cp_a,
    cp._parts as cp_parts,
    cp._brm as cp_brm,
    cp._turn as cp_turn,
    cp._dturn as cp_dturn,
    cp._ts as cp_ts,
    cp._ms as cp_ms,
    cp._ds as cp_ds,
    cp._np as cp_np,
    cp._dnp as cp_dnp,
    cp._pu as cp_pu,
    cp._side as cp_side,
    cp._dpu as cp_dpu,
    cp._head as cp_head,
    cp._dhead as cp_dhead,
    cp._ihead as cp_ihead,
    cp._b as cp_b,
    cp._pg as cp_pg,
    cp._s as cp_s,
    cp._rid as cp_rid,
    cp._c as cp_c,
    cp._m as cp_m,
    cp._mb as cp_mb,
    cp._f as cp_f,
    cp._pr as cp_pr,
    cp._priseq as cp_priseq,
    cp._p as cp_p,
    cp._pad as cp_pad,
    cp._vw as cp_vw,
    cp._stdpos as cp_stdpos,
    cp._land as cp_land,
    cp._depend as cp_depend,
    cp._chkflag as cp_chkflag,
    cp._exchk as cp_exchk,
    cp._grand as cp_grand,
    cp._marea as cp_marea,
    cp._rmset as cp_rmset,
    cp._sh as cp_sh,
    cp._scandir1 as cp_scandir1,
    cp._scandir2 as cp_scandir2,
    cp._ohl as cp_ohl,
    cp._ohr as cp_ohr,
    cp._apcctrl as cp_apcctrl,
    cp._wg as cp_wg,
    cp._skipnumber as cp_skipnumber,
    acmp._filename_id as acmp_filename_id,
    acmp._p as acmp_p,
    acmp._cmp as acmp_cmp,
    acmp._cc as acmp_cc,
    acmp._ref as acmp_ref,
    acmp._type as acmp_type,
    ad._filename_id as ad_filename_id,
    ad._cmp as ad_cmp,
    ad._defect as ad_defect,
    ad._insp_type as ad_insp_type,
    ad._lead_id as ad_lead_id
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
inner join
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    aoi.insp ai
on
    upper(ai._c2d) = upper(ufd._pcb_id)
inner join
    aoi.filename_to_fid aftf
on
    aftf._filename_id = ai._filename_id
inner join
    aoi.aoi_filename_data aafd
on
    aafd._filename_id = ai._filename_id
inner join
    aoi.p ap
on
    ap._filename_id = ai._filename_id
inner join
    crb.crb_filename_data ccfd
on
    upper(ccfd._product_name) = upper(upx._mjsid)
inner join
    crb.lotnames cl
on
    cl._filename_id = ccfd._filename_id
and
    cl._lot = upi._lotname
inner join
    crb.positiondata cp
on
    cp._filename_id = ccfd._filename_id
and
    cp._lot_number = cl._lotnum
and
    cp._idnum = mqt._idnum
left join
    aoi.cmp as acmp
on
    acmp._filename_id = ai._filename_id
and
    acmp._p = ap._p
and
    acmp._ref = cp._c
left join
    aoi.defect ad
on
    ad._filename_id = ai._filename_id
and
    ad._cmp = acmp._cmp
;

create view u03.mqt_status_per_machine_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    -- ftf._filename_timestamp,
    -- ftf._filename,
    -- ftf._filename_type,
    -- ftf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    -- ufd._pcb_serial,
    -- ufd._pcb_id,
    -- ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no,
    -- upx._filename_id,
    -- upx._author,
    -- upx._authortype,
    -- upx._comment,
    -- -- upx._date,
    -- upx._diff,
    -- upx._format,
    -- upx._machine,
    -- upx._mjsid,
    -- upx._version,
    -- upi._filename_id,
    -- upi._bcrstatus,
    -- upi._code,
    -- upi._lane,
    -- upi._lotname,
    -- upi._lotnumber,
    -- upi._output,
    -- upi._planid,
    -- upi._productid,
    -- upi._rev,
    -- upi._serial,
    -- upi._serialstatus,
    -- upi._stage,
    -- aftf._filename,
    -- aftf._filename_type,
    -- aftf._filename_timestamp,
    -- aftf._filename_route,
    -- aftf._filename_id,
    -- aafd._filename_id,
    -- aafd._aoi_pcbid,
    -- aafd._date_time,
    -- ai._filename_id,
    -- ai._cid,
    -- ai._timestamp,
    -- ai._crc,
    -- ai._c2d,
    -- ai._recipename,
    -- ai._mid,
    -- ap._filename_id,
    -- ap._p,
    ap._cmp,
    case
        when (ap._cmp = -1) then 'PASSED'
        when (ap._cmp = 1) then 'FAILED'
        else 'UNKNOWN'
    end as aoi_board_status,
    -- count(ap._cmp) as aoi_board_status_count,
    -- ap._sc,
    -- ap._pid,
    -- ap._fc,
    -- mqt._filename_id,
    -- mqt._b,
    -- mqt._idnum,
    -- mqt._turn,
    -- mqt._ms,
    -- mqt._ts,
    -- mqt._fadd,
    -- mqt._fsadd,
    -- mqt._fblkcode,
    -- mqt._fblkserial,
    -- mqt._nhadd,
    -- mqt._ncadd,
    -- mqt._nblkcode,
    -- mqt._nblkserial,
    -- mqt._reelid,
    mqt._f,
    case
        when (mqt._f = 0) then 'MOUNT SUCCESS'
        when (mqt._f = 1) then 'EXHAUST'
        when (mqt._f = 2) then 'PICK UP ERROR BY VACUUM SENSOR DETECTION'
        when (mqt._f = 3) then 'PICK UP ERROR BY RECOGNITION'
        when (mqt._f = 4) then 'COMPONENT STAND ERROR'
        when (mqt._f = 5) then 'RECOGNITION ERROR'
        when (mqt._f = 6) then 'DROP ERROR'
        when (mqt._f = 7) then 'MOUNT ERROR'
        when (mqt._f = 8) then 'BLOW OUT ERROR'
        when (mqt._f = 9) then 'NO MOUNT OR INVALID BY MOUNT SUSPEND'
        when (mqt._f = 10) then 'BAD NOZZLE PICK UP ERROR'
        when (mqt._f = 11) then 'BAD NOZZLE RECOGNITION ERROR'
        when (mqt._f = 12) then 'CONTINUE START'
        when (mqt._f = 13) then 'APC MOUNT CANCEL'
        when (mqt._f = 14) then 'MOUNT BLOW ERROR'
        when (mqt._f = 15) then 'DETECT TAPE CHANGE'
        when (mqt._f = 16) then 'COMPONENT THICKNESS ERROR'
        when (mqt._f = 17) then 'PICK UP ERROR WHEN COUNT MANDATORY'
        when (mqt._f = 18) then 'LEAD/BALL FLOAT ERROR'
        when (mqt._f = 19) then 'DETECT SHIFT PICK UP POSITION'
        when (mqt._f = 20) then 'COMPONENT DROP DIPPING UNIT'
        else 'UNKNOWN FAILURE'
    end as attempt_status,
    count(mqt._f) as f_count
    -- mqt._rcgx,
    -- mqt._rcgy,
    -- mqt._rcga,
    -- mqt._tcx,
    -- mqt._tcy,
    -- mqt._mposirecx,
    -- mqt._mposirecy,
    -- mqt._mposireca,
    -- mqt._mposirecz,
    -- mqt._thmax,
    -- mqt._thave,
    -- mqt._mntcx,
    -- mqt._mntcy,
    -- mqt._mntca,
    -- mqt._tlx,
    -- mqt._tly,
    -- mqt._inspectarea,
    -- mqt._didnum,
    -- mqt._ds,
    -- mqt._dispenseid,
    -- mqt._parts,
    -- mqt._warpz,
    -- mqt._prepickuplot,
    -- mqt._prepickupsts,
    -- ccfd._filename_id,
    -- ccfd._history_id,
    -- ccfd._time_stamp,
    -- ccfd._crb_file_name,
    -- ccfd._product_name,
    -- cl._filename_id,
    -- cl._idnum,
    -- cl._lotnum,
    -- cl._lot,
    -- cl._mcfilename,
    -- cl._filter,
    -- cl._autochg,
    -- cl._basechg,
    -- cl._lane,
    -- cl._productionid,
    -- cl._simproduct,
    -- cl._dgspcbname,
    -- cl._dgspcbrev,
    -- cl._dgspcbside,
    -- cl._dgsrefpin,
    -- cl._c,
    -- cl._datagenmode,
    -- cl._mounthead,
    -- cl._vstpath,
    -- cl._order,
    -- cl._targettact,
    -- cp._filename_id,
    -- cp._lot_number,
    -- cp._idnum,
    -- cp._cadid,
    -- cp._x,
    -- cp._y,
    -- cp._a,
    -- cp._parts,
    -- cp._brm,
    -- cp._turn,
    -- cp._dturn,
    -- cp._ts,
    -- cp._ms,
    -- cp._ds,
    -- cp._np,
    -- cp._dnp,
    -- cp._pu,
    -- cp._side,
    -- cp._dpu,
    -- cp._head,
    -- cp._dhead,
    -- cp._ihead,
    -- cp._b,
    -- cp._pg,
    -- cp._s,
    -- cp._rid,
    -- cp._c,
    -- cp._m,
    -- cp._mb,
    -- cp._f,
    -- cp._pr,
    -- cp._priseq,
    -- cp._p,
    -- cp._pad,
    -- cp._vw,
    -- cp._stdpos,
    -- cp._land,
    -- cp._depend,
    -- cp._chkflag,
    -- cp._exchk,
    -- cp._grand,
    -- cp._marea,
    -- cp._rmset,
    -- cp._sh,
    -- cp._scandir1,
    -- cp._scandir2,
    -- cp._ohl,
    -- cp._ohr,
    -- cp._apcctrl,
    -- cp._wg,
    -- cp._skipnumber,
    -- acmp._filename_id,
    -- acmp._p,
    -- acmp._cmp,
    -- acmp._cc,
    -- acmp._ref,
    -- acmp._type,
    -- ad._filename_id,
    -- ad._cmp,
    -- ad._defect,
    -- ad._insp_type,
    -- ad._lead_id,
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
inner join
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    aoi.insp ai
on
    upper(ai._c2d) = upper(ufd._pcb_id)
inner join
    aoi.filename_to_fid aftf
on
    aftf._filename_id = ai._filename_id
inner join
    aoi.aoi_filename_data aafd
on
    aafd._filename_id = ai._filename_id
inner join
    aoi.p ap
on
    ap._filename_id = ai._filename_id
inner join
    crb.crb_filename_data ccfd
on
    upper(ccfd._product_name) = upper(upx._mjsid)
inner join
    crb.lotnames cl
on
    cl._filename_id = ccfd._filename_id
and
    cl._lot = upi._lotname
inner join
    crb.positiondata cp
on
    cp._filename_id = ccfd._filename_id
and
    cp._lot_number = cl._lotnum
and
    cp._idnum = mqt._idnum
left join
    aoi.cmp as acmp
on
    acmp._filename_id = ai._filename_id
and
    acmp._p = ap._p
and
    acmp._ref = cp._c
left join
    aoi.defect ad
on
    ad._filename_id = ai._filename_id
and
    ad._cmp = acmp._cmp
group by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ap._cmp,
    mqt._f
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- mqt._f
;

create view u03.mqt_pcb_status_per_machine_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    -- ftf._filename,
    -- ftf._filename_type,
    -- ftf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    -- ufd._pcb_serial,
    ufd._pcb_id,
    -- ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no,
    -- upx._filename_id,
    -- upx._author,
    -- upx._authortype,
    -- upx._comment,
    -- -- upx._date,
    -- upx._diff,
    -- upx._format,
    -- upx._machine,
    -- upx._mjsid,
    -- upx._version,
    -- upi._filename_id,
    -- upi._bcrstatus,
    -- upi._code,
    -- upi._lane,
    -- upi._lotname,
    -- upi._lotnumber,
    -- upi._output,
    -- upi._planid,
    -- upi._productid,
    -- upi._rev,
    -- upi._serial,
    -- upi._serialstatus,
    -- upi._stage,
    -- aftf._filename,
    -- aftf._filename_type,
    -- aftf._filename_timestamp,
    -- aftf._filename_route,
    -- aftf._filename_id,
    -- aafd._filename_id,
    -- aafd._aoi_pcbid,
    -- aafd._date_time,
    -- ai._filename_id,
    -- ai._cid,
    -- ai._timestamp,
    -- ai._crc,
    -- ai._c2d,
    -- ai._recipename,
    -- ai._mid,
    -- ap._filename_id,
    -- ap._p,
    ap._cmp,
    case
        when (ap._cmp = -1) then 'PASSED'
        when (ap._cmp = 1) then 'FAILED'
        else 'UNKNOWN'
    end as aoi_board_status,
    -- count(ap._cmp) as aoi_board_status_count,
    -- ap._sc,
    -- ap._pid,
    -- ap._fc,
    -- mqt._filename_id,
    -- mqt._b,
    -- mqt._idnum,
    -- mqt._turn,
    -- mqt._ms,
    -- mqt._ts,
    -- mqt._fadd,
    -- mqt._fsadd,
    -- mqt._fblkcode,
    -- mqt._fblkserial,
    -- mqt._nhadd,
    -- mqt._ncadd,
    -- mqt._nblkcode,
    -- mqt._nblkserial,
    -- mqt._reelid,
    mqt._f,
    case
        when (mqt._f = 0) then 'MOUNT SUCCESS'
        when (mqt._f = 1) then 'EXHAUST'
        when (mqt._f = 2) then 'PICK UP ERROR BY VACUUM SENSOR DETECTION'
        when (mqt._f = 3) then 'PICK UP ERROR BY RECOGNITION'
        when (mqt._f = 4) then 'COMPONENT STAND ERROR'
        when (mqt._f = 5) then 'RECOGNITION ERROR'
        when (mqt._f = 6) then 'DROP ERROR'
        when (mqt._f = 7) then 'MOUNT ERROR'
        when (mqt._f = 8) then 'BLOW OUT ERROR'
        when (mqt._f = 9) then 'NO MOUNT OR INVALID BY MOUNT SUSPEND'
        when (mqt._f = 10) then 'BAD NOZZLE PICK UP ERROR'
        when (mqt._f = 11) then 'BAD NOZZLE RECOGNITION ERROR'
        when (mqt._f = 12) then 'CONTINUE START'
        when (mqt._f = 13) then 'APC MOUNT CANCEL'
        when (mqt._f = 14) then 'MOUNT BLOW ERROR'
        when (mqt._f = 15) then 'DETECT TAPE CHANGE'
        when (mqt._f = 16) then 'COMPONENT THICKNESS ERROR'
        when (mqt._f = 17) then 'PICK UP ERROR WHEN COUNT MANDATORY'
        when (mqt._f = 18) then 'LEAD/BALL FLOAT ERROR'
        when (mqt._f = 19) then 'DETECT SHIFT PICK UP POSITION'
        when (mqt._f = 20) then 'COMPONENT DROP DIPPING UNIT'
        else 'UNKNOWN FAILURE'
    end as attempt_status,
    count(mqt._f) as f_count,
    -- mqt._rcgx,
    -- mqt._rcgy,
    -- mqt._rcga,
    -- mqt._tcx,
    -- mqt._tcy,
    -- mqt._mposirecx,
    -- mqt._mposirecy,
    -- mqt._mposireca,
    -- mqt._mposirecz,
    -- mqt._thmax,
    -- mqt._thave,
    -- mqt._mntcx,
    -- mqt._mntcy,
    -- mqt._mntca,
    -- mqt._tlx,
    -- mqt._tly,
    -- mqt._inspectarea,
    -- mqt._didnum,
    -- mqt._ds,
    -- mqt._dispenseid,
    -- mqt._parts,
    -- mqt._warpz,
    -- mqt._prepickuplot,
    -- mqt._prepickupsts,
    -- ccfd._filename_id,
    -- ccfd._history_id,
    -- ccfd._time_stamp,
    -- ccfd._crb_file_name,
    -- ccfd._product_name,
    -- cl._filename_id,
    -- cl._idnum,
    -- cl._lotnum,
    -- cl._lot,
    -- cl._mcfilename,
    -- cl._filter,
    -- cl._autochg,
    -- cl._basechg,
    -- cl._lane,
    -- cl._productionid,
    -- cl._simproduct,
    -- cl._dgspcbname,
    -- cl._dgspcbrev,
    -- cl._dgspcbside,
    -- cl._dgsrefpin,
    -- cl._c,
    -- cl._datagenmode,
    -- cl._mounthead,
    -- cl._vstpath,
    -- cl._order,
    -- cl._targettact,
    -- cp._filename_id,
    -- cp._lot_number,
    -- cp._idnum,
    -- cp._cadid,
    -- cp._x,
    -- cp._y,
    -- cp._a,
    -- cp._parts,
    -- cp._brm,
    -- cp._turn,
    -- cp._dturn,
    -- cp._ts,
    -- cp._ms,
    -- cp._ds,
    -- cp._np,
    -- cp._dnp,
    -- cp._pu,
    -- cp._side,
    -- cp._dpu,
    -- cp._head,
    -- cp._dhead,
    -- cp._ihead,
    -- cp._b,
    -- cp._pg,
    -- cp._s,
    -- cp._rid,
    -- cp._c,
    -- cp._m,
    -- cp._mb,
    -- cp._f,
    -- cp._pr,
    -- cp._priseq,
    -- cp._p,
    -- cp._pad,
    -- cp._vw,
    -- cp._stdpos,
    -- cp._land,
    -- cp._depend,
    -- cp._chkflag,
    -- cp._exchk,
    -- cp._grand,
    -- cp._marea,
    -- cp._rmset,
    -- cp._sh,
    -- cp._scandir1,
    -- cp._scandir2,
    -- cp._ohl,
    -- cp._ohr,
    -- cp._apcctrl,
    -- cp._wg,
    -- cp._skipnumber,
    -- acmp._filename_id,
    -- acmp._p,
    -- acmp._cmp,
    -- acmp._cc,
    acmp._ref,
    -- acmp._type,
    -- ad._filename_id,
    -- ad._cmp,
    -- ad._defect,
    ad._insp_type,
    ad._lead_id
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
inner join
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    aoi.insp ai
on
    upper(ai._c2d) = upper(ufd._pcb_id)
inner join
    aoi.filename_to_fid aftf
on
    aftf._filename_id = ai._filename_id
inner join
    aoi.aoi_filename_data aafd
on
    aafd._filename_id = ai._filename_id
inner join
    aoi.p ap
on
    ap._filename_id = ai._filename_id
inner join
    crb.crb_filename_data ccfd
on
    upper(ccfd._product_name) = upper(upx._mjsid)
inner join
    crb.lotnames cl
on
    cl._filename_id = ccfd._filename_id
and
    cl._lot = upi._lotname
inner join
    crb.positiondata cp
on
    cp._filename_id = ccfd._filename_id
and
    cp._lot_number = cl._lotnum
and
    cp._idnum = mqt._idnum
left join
    aoi.cmp as acmp
on
    acmp._filename_id = ai._filename_id
and
    acmp._p = ap._p
and
    acmp._ref = cp._c
left join
    aoi.defect ad
on
    ad._filename_id = ai._filename_id
and
    ad._cmp = acmp._cmp
group by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ufd._pcb_id,
    ap._cmp,
    mqt._f,
    acmp._ref,
    ad._insp_type,
    ad._lead_id
-- order by
    -- ftf._filename_route,
    -- ufd._pcb_id,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- mqt._f
;

create view u01.pa_pcb_feeder_aoi_per_machine_view
as
select 
    ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    ftf._filename_timestamp as ftf_filename_timestamp,
    ftf._filename as ftf_filename,
    ftf._filename_type as ftf_filename_type,
    ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    ufd._date as ufd_date,
    ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    ufd._output_no as ufd_output_no,
    ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    upx._author as upx_author,
    upx._authortype as upx_authortype,
    upx._comment as upx_comment,
    upx._date as upx_date,
    upx._diff as upx_diff,
    upx._format as upx_format,
    upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    upx._version as upx_version,
    upi._filename_id as upi_filename_id,
    upi._bcrstatus as upi_bcrstatus,
    upi._code as upi_code,
    upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    upi._lotnumber as upi_lotnumber,
    upi._output as upi_output,
    upi._planid as upi_planid,
    upi._productid as upi_productid,
    upi._rev as upi_rev,
    upi._serial as upi_serial,
    upi._serialstatus as upi_serialstatus,
    upi._stage as upi_stage,
    i._filename_id as i_filename_id,
    i._cid as i_cid,
    i._timestamp as i_timestamp,
    i._crc as i_crc,
    i._c2d as i_c2d,
    i._recipename as i_recipename,
    i._mid as i_mid,
    p._filename_id as p_filename_id,
    p._p as p_p,
    p._cmp as p_cmp,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status,
    p._sc as p_sc,
    p._pid as p_pid,
    p._fc as p_fc,
    df._filename_id as df_filename_id,
    df._pcb_id as df_pcb_id,
    df._pcb_serial as df_pcb_serial,
    df._machine_order as df_machine_order,
    df._lane_no as df_lane_no,
    df._stage_no as df_stage_no,
    df._timestamp as df_timestamp,
    df._fadd as df_fadd,
    df._fsadd as df_fsadd,
    df._mjsid as df_mjsid,
    df._lotname as df_lotname,
    df._reelid as df_reelid,
    df._partsname as df_partsname,
    df._output_no as df_output_no,
    df._blkserial as df_blkserial,
    df._pickup as df_pickup,
    df._pmiss as df_pmiss,
    df._rmiss as df_rmiss,
    df._dmiss as df_dmiss,
    df._mmiss as df_mmiss,
    df._hmiss as df_hmiss,
    df._trsmiss as df_trsmiss,
    df._mount as df_mount
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
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
inner join
    u01.delta_feeder df
on
    df._filename_id = ufd._filename_id
where
    ufd._output_no in ( 3, 4 )
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.pa_pcb_nozzle_aoi_per_machine_view
as
select 
    ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    ftf._filename_timestamp as ftf_filename_timestamp,
    ftf._filename as ftf_filename,
    ftf._filename_type as ftf_filename_type,
    ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    ufd._date as ufd_date,
    ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    ufd._output_no as ufd_output_no,
    ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    upx._author as upx_author,
    upx._authortype as upx_authortype,
    upx._comment as upx_comment,
    upx._date as upx_date,
    upx._diff as upx_diff,
    upx._format as upx_format,
    upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    upx._version as upx_version,
    upi._filename_id as upi_filename_id,
    upi._bcrstatus as upi_bcrstatus,
    upi._code as upi_code,
    upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    upi._lotnumber as upi_lotnumber,
    upi._output as upi_output,
    upi._planid as upi_planid,
    upi._productid as upi_productid,
    upi._rev as upi_rev,
    upi._serial as upi_serial,
    upi._serialstatus as upi_serialstatus,
    upi._stage as upi_stage,
    i._filename_id as i_filename_id,
    i._cid as i_cid,
    i._timestamp as i_timestamp,
    i._crc as i_crc,
    i._c2d as i_c2d,
    i._recipename as i_recipename,
    i._mid as i_mid,
    p._filename_id as p_filename_id,
    p._p as p_p,
    p._cmp as p_cmp,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status,
    p._sc as p_sc,
    p._pid as p_pid,
    p._fc as p_fc,
    dn._filename_id as dn_filename_id,
    dn._pcb_id as dn_pcb_id,
    dn._pcb_serial as dn_pcb_serial,
    dn._machine_order as dn_machine_order,
    dn._lane_no as dn_lane_no,
    dn._stage_no as dn_stage_no,
    dn._timestamp as dn_timestamp,
    dn._nhadd as dn_nhadd,
    dn._ncadd as dn_ncadd,
    dn._mjsid as dn_mjsid,
    dn._lotname as dn_lotname,
    dn._output_no as dn_output_no,
    dn._pickup as dn_pickup,
    dn._pmiss as dn_pmiss,
    dn._rmiss as dn_rmiss,
    dn._dmiss as dn_dmiss,
    dn._mmiss as dn_mmiss,
    dn._hmiss as dn_hmiss,
    dn._trsmiss as dn_trsmiss,
    dn._mount as dn_mount
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
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
inner join
    u01.delta_nozzle dn
on
    dn._filename_id = ufd._filename_id
where
    ufd._output_no in ( 3, 4 )
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.pa_pcb_times_aoi_per_machine_view
as
select 
    ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    ftf._filename_timestamp as ftf_filename_timestamp,
    ftf._filename as ftf_filename,
    ftf._filename_type as ftf_filename_type,
    ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    ufd._date as ufd_date,
    ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    ufd._output_no as ufd_output_no,
    ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    upx._author as upx_author,
    upx._authortype as upx_authortype,
    upx._comment as upx_comment,
    upx._date as upx_date,
    upx._diff as upx_diff,
    upx._format as upx_format,
    upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    upx._version as upx_version,
    upi._filename_id as upi_filename_id,
    upi._bcrstatus as upi_bcrstatus,
    upi._code as upi_code,
    upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    upi._lotnumber as upi_lotnumber,
    upi._output as upi_output,
    upi._planid as upi_planid,
    upi._productid as upi_productid,
    upi._rev as upi_rev,
    upi._serial as upi_serial,
    upi._serialstatus as upi_serialstatus,
    upi._stage as upi_stage,
    i._filename_id as i_filename_id,
    i._cid as i_cid,
    i._timestamp as i_timestamp,
    i._crc as i_crc,
    i._c2d as i_c2d,
    i._recipename as i_recipename,
    i._mid as i_mid,
    p._filename_id as p_filename_id,
    p._p as p_p,
    p._cmp as p_cmp,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status,
    p._sc as p_sc,
    p._pid as p_pid,
    p._fc as p_fc,
    dpt._filename_id as dpt_filename_id,
    dpt._pcb_id as dpt_pcb_id,
    dpt._pcb_serial as dpt_pcb_serial,
    dpt._machine_order as dpt_machine_order,
    dpt._lane_no as dpt_lane_no,
    dpt._stage_no as dpt_stage_no,
    dpt._timestamp as dpt_timestamp,
    dpt._mjsid as dpt_mjsid,
    dpt._lotname as dpt_lotname,
    dpt._output_no as dpt_output_no,
    dpt._actual as dpt_actual,
    dpt._bndrcgstop as dpt_bndrcgstop,
    dpt._bndstop as dpt_bndstop,
    dpt._brcg as dpt_brcg,
    dpt._brcgstop as dpt_brcgstop,
    dpt._bwait as dpt_bwait,
    dpt._cderr as dpt_cderr,
    dpt._change as dpt_change,
    dpt._cmerr as dpt_cmerr,
    dpt._cnvstop as dpt_cnvstop,
    dpt._cperr as dpt_cperr,
    dpt._crerr as dpt_crerr,
    dpt._cterr as dpt_cterr,
    dpt._cwait as dpt_cwait,
    dpt._dataedit as dpt_dataedit,
    dpt._fbstop as dpt_fbstop,
    dpt._fwait as dpt_fwait,
    dpt._idle as dpt_idle,
    dpt._jointpasswait as dpt_jointpasswait,
    dpt._judgestop as dpt_judgestop,
    dpt._load as dpt_load,
    dpt._mcfwait as dpt_mcfwait,
    dpt._mcrwait as dpt_mcrwait,
    dpt._mente as dpt_mente,
    dpt._mhrcgstop as dpt_mhrcgstop,
    dpt._mount as dpt_mount,
    dpt._otherlstop as dpt_otherlstop,
    dpt._othrstop as dpt_othrstop,
    dpt._poweron as dpt_poweron,
    dpt._prdstop as dpt_prdstop,
    dpt._prod as dpt_prod,
    dpt._prodview as dpt_prodview,
    dpt._pwait as dpt_pwait,
    dpt._rwait as dpt_rwait,
    dpt._scestop as dpt_scestop,
    dpt._scstop as dpt_scstop,
    dpt._swait as dpt_swait,
    dpt._totalstop as dpt_totalstop,
    dpt._trbl as dpt_trbl,
    dpt._trserr as dpt_trserr,
    dpt._unitadjust as dpt_unitadjust
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
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
inner join
    u01.delta_pivot_time dpt
on
    dpt._filename_id = ftf._filename_id
where
    ufd._output_no in ( 3, 4 )
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.pa_pcb_totals_aoi_per_machine_view
as
select 
    ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    ftf._filename_timestamp as ftf_filename_timestamp,
    ftf._filename as ftf_filename,
    ftf._filename_type as ftf_filename_type,
    ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    ufd._date as ufd_date,
    ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    ufd._output_no as ufd_output_no,
    ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    upx._filename_id as upx_filename_id,
    upx._author as upx_author,
    upx._authortype as upx_authortype,
    upx._comment as upx_comment,
    upx._date as upx_date,
    upx._diff as upx_diff,
    upx._format as upx_format,
    upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    upx._version as upx_version,
    upi._filename_id as upi_filename_id,
    upi._bcrstatus as upi_bcrstatus,
    upi._code as upi_code,
    upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    upi._lotnumber as upi_lotnumber,
    upi._output as upi_output,
    upi._planid as upi_planid,
    upi._productid as upi_productid,
    upi._rev as upi_rev,
    upi._serial as upi_serial,
    upi._serialstatus as upi_serialstatus,
    upi._stage as upi_stage,
    i._filename_id as i_filename_id,
    i._cid as i_cid,
    i._timestamp as i_timestamp,
    i._crc as i_crc,
    i._c2d as i_c2d,
    i._recipename as i_recipename,
    i._mid as i_mid,
    p._filename_id as p_filename_id,
    p._p as p_p,
    p._cmp as p_cmp,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status,
    p._sc as p_sc,
    p._pid as p_pid,
    p._fc as p_fc,
    dpc._filename_id as dpc_filename_id,
    dpc._pcb_id as dpc_pcb_id,
    dpc._pcb_serial as dpc_pcb_serial,
    dpc._machine_order as dpc_machine_order,
    dpc._lane_no as dpc_lane_no,
    dpc._stage_no as dpc_stage_no,
    dpc._timestamp as dpc_timestamp,
    dpc._mjsid as dpc_mjsid,
    dpc._lotname as dpc_lotname,
    dpc._output_no as dpc_output_no,
    dpc._bndrcgstop as dpc_bndrcgstop,
    dpc._bndstop as dpc_bndstop,
    dpc._board as dpc_board,
    dpc._brcgstop as dpc_brcgstop,
    dpc._bwait as dpc_bwait,
    dpc._cderr as dpc_cderr,
    dpc._cmerr as dpc_cmerr,
    dpc._cnvstop as dpc_cnvstop,
    dpc._cperr as dpc_cperr,
    dpc._crerr as dpc_crerr,
    dpc._cterr as dpc_cterr,
    dpc._cwait as dpc_cwait,
    dpc._fbstop as dpc_fbstop,
    dpc._fwait as dpc_fwait,
    dpc._jointpasswait as dpc_jointpasswait,
    dpc._judgestop as dpc_judgestop,
    dpc._lotboard as dpc_lotboard,
    dpc._lotmodule as dpc_lotmodule,
    dpc._mcfwait as dpc_mcfwait,
    dpc._mcrwait as dpc_mcrwait,
    dpc._mhrcgstop as dpc_mhrcgstop,
    dpc._module as dpc_module,
    dpc._otherlstop as dpc_otherlstop,
    dpc._othrstop as dpc_othrstop,
    dpc._pwait as dpc_pwait,
    dpc._rwait as dpc_rwait,
    dpc._scestop as dpc_scestop,
    dpc._scstop as dpc_scstop,
    dpc._swait as dpc_swait,
    dpc._tdispense as dpc_tdispense,
    dpc._tdmiss as dpc_tdmiss,
    dpc._thmiss as dpc_thmiss,
    dpc._tmmiss as dpc_tmmiss,
    dpc._tmount as dpc_tmount,
    dpc._tpickup as dpc_tpickup,
    dpc._tpmiss as dpc_tpmiss,
    dpc._tpriming as dpc_tpriming,
    dpc._trbl as dpc_trbl,
    dpc._trmiss as dpc_trmiss,
    dpc._trserr as dpc_trserr,
    dpc._trsmiss as dpc_trsmiss,
    dpt._filename_id as dpt_filename_id,
    dpt._pcb_id as dpt_pcb_id,
    dpt._pcb_serial as dpt_pcb_serial,
    dpt._machine_order as dpt_machine_order,
    dpt._lane_no as dpt_lane_no,
    dpt._stage_no as dpt_stage_no,
    dpt._timestamp as dpt_timestamp,
    dpt._mjsid as dpt_mjsid,
    dpt._lotname as dpt_lotname,
    dpt._output_no as dpt_output_no,
    dpt._actual as dpt_actual,
    dpt._bndrcgstop as dpt_bndrcgstop,
    dpt._bndstop as dpt_bndstop,
    dpt._brcg as dpt_brcg,
    dpt._brcgstop as dpt_brcgstop,
    dpt._bwait as dpt_bwait,
    dpt._cderr as dpt_cderr,
    dpt._change as dpt_change,
    dpt._cmerr as dpt_cmerr,
    dpt._cnvstop as dpt_cnvstop,
    dpt._cperr as dpt_cperr,
    dpt._crerr as dpt_crerr,
    dpt._cterr as dpt_cterr,
    dpt._cwait as dpt_cwait,
    dpt._dataedit as dpt_dataedit,
    dpt._fbstop as dpt_fbstop,
    dpt._fwait as dpt_fwait,
    dpt._idle as dpt_idle,
    dpt._jointpasswait as dpt_jointpasswait,
    dpt._judgestop as dpt_judgestop,
    dpt._load as dpt_load,
    dpt._mcfwait as dpt_mcfwait,
    dpt._mcrwait as dpt_mcrwait,
    dpt._mente as dpt_mente,
    dpt._mhrcgstop as dpt_mhrcgstop,
    dpt._mount as dpt_mount,
    dpt._otherlstop as dpt_otherlstop,
    dpt._othrstop as dpt_othrstop,
    dpt._poweron as dpt_poweron,
    dpt._prdstop as dpt_prdstop,
    dpt._prod as dpt_prod,
    dpt._prodview as dpt_prodview,
    dpt._pwait as dpt_pwait,
    dpt._rwait as dpt_rwait,
    dpt._scestop as dpt_scestop,
    dpt._scstop as dpt_scstop,
    dpt._swait as dpt_swait,
    dpt._totalstop as dpt_totalstop,
    dpt._trbl as dpt_trbl,
    dpt._trserr as dpt_trserr,
    dpt._unitadjust as dpt_unitadjust
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
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
inner join
    u01.delta_pivot_count dpc
on
    dpc._filename_id = ufd._filename_id
inner join
    u01.delta_pivot_time dpt
on
    dpt._filename_id = ufd._filename_id
where
    ufd._output_no in ( 3, 4 )
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.pa_pcb_counts_aoi_per_machine_view
as
select 
    ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    ftf._filename_timestamp as ftf_filename_timestamp,
    ftf._filename as ftf_filename,
    ftf._filename_type as ftf_filename_type,
    ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    ufd._date as ufd_date,
    ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    ufd._output_no as ufd_output_no,
    ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    upx._filename_id as upx_filename_id,
    upx._author as upx_author,
    upx._authortype as upx_authortype,
    upx._comment as upx_comment,
    upx._date as upx_date,
    upx._diff as upx_diff,
    upx._format as upx_format,
    upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    upx._version as upx_version,
    upi._filename_id as upi_filename_id,
    upi._bcrstatus as upi_bcrstatus,
    upi._code as upi_code,
    upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    upi._lotnumber as upi_lotnumber,
    upi._output as upi_output,
    upi._planid as upi_planid,
    upi._productid as upi_productid,
    upi._rev as upi_rev,
    upi._serial as upi_serial,
    upi._serialstatus as upi_serialstatus,
    upi._stage as upi_stage,
    i._filename_id as i_filename_id,
    i._cid as i_cid,
    i._timestamp as i_timestamp,
    i._crc as i_crc,
    i._c2d as i_c2d,
    i._recipename as i_recipename,
    i._mid as i_mid,
    p._filename_id as p_filename_id,
    p._p as p_p,
    p._cmp as p_cmp,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status,
    p._sc as p_sc,
    p._pid as p_pid,
    p._fc as p_fc,
    dpc._filename_id as dpc_filename_id,
    dpc._pcb_id as dpc_pcb_id,
    dpc._pcb_serial as dpc_pcb_serial,
    dpc._machine_order as dpc_machine_order,
    dpc._lane_no as dpc_lane_no,
    dpc._stage_no as dpc_stage_no,
    dpc._timestamp as dpc_timestamp,
    dpc._mjsid as dpc_mjsid,
    dpc._lotname as dpc_lotname,
    dpc._output_no as dpc_output_no,
    dpc._bndrcgstop as dpc_bndrcgstop,
    dpc._bndstop as dpc_bndstop,
    dpc._board as dpc_board,
    dpc._brcgstop as dpc_brcgstop,
    dpc._bwait as dpc_bwait,
    dpc._cderr as dpc_cderr,
    dpc._cmerr as dpc_cmerr,
    dpc._cnvstop as dpc_cnvstop,
    dpc._cperr as dpc_cperr,
    dpc._crerr as dpc_crerr,
    dpc._cterr as dpc_cterr,
    dpc._cwait as dpc_cwait,
    dpc._fbstop as dpc_fbstop,
    dpc._fwait as dpc_fwait,
    dpc._jointpasswait as dpc_jointpasswait,
    dpc._judgestop as dpc_judgestop,
    dpc._lotboard as dpc_lotboard,
    dpc._lotmodule as dpc_lotmodule,
    dpc._mcfwait as dpc_mcfwait,
    dpc._mcrwait as dpc_mcrwait,
    dpc._mhrcgstop as dpc_mhrcgstop,
    dpc._module as dpc_module,
    dpc._otherlstop as dpc_otherlstop,
    dpc._othrstop as dpc_othrstop,
    dpc._pwait as dpc_pwait,
    dpc._rwait as dpc_rwait,
    dpc._scestop as dpc_scestop,
    dpc._scstop as dpc_scstop,
    dpc._swait as dpc_swait,
    dpc._tdispense as dpc_tdispense,
    dpc._tdmiss as dpc_tdmiss,
    dpc._thmiss as dpc_thmiss,
    dpc._tmmiss as dpc_tmmiss,
    dpc._tmount as dpc_tmount,
    dpc._tpickup as dpc_tpickup,
    dpc._tpmiss as dpc_tpmiss,
    dpc._tpriming as dpc_tpriming,
    dpc._trbl as dpc_trbl,
    dpc._trmiss as dpc_trmiss,
    dpc._trserr as dpc_trserr,
    dpc._trsmiss as dpc_trsmiss
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
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
inner join
    u01.delta_pivot_count dpc
on
    dpc._filename_id = ufd._filename_id
where
    ufd._output_no in ( 3, 4 )
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u03.mqt_pcb_aoi_bad_per_machine_view
as
select distinct
    -- ftf._filename_route as ftf_filename_route,
    ufd._machine_order as ufd_machine_order,
    ufd._lane_no as ufd_lane_no,
    ufd._stage_no as ufd_stage_no,
    -- ftf._filename_timestamp as ftf_filename_timestamp,
    -- ftf._filename as ftf_filename,
    -- ftf._filename_type as ftf_filename_type,
    -- ftf._filename_id as ftf_filename_id,
    ufd._filename_id as ufd_filename_id,
    -- ufd._date as ufd_date,
    -- ufd._pcb_serial as ufd_pcb_serial,
    ufd._pcb_id as ufd_pcb_id,
    -- ufd._output_no as ufd_output_no,
    -- ufd._pcb_id_lot_no as ufd_pcb_id_lot_no,
    -- ufd._pcb_id_serial_no as ufd_pcb_id_serial_no,
    -- upx._filename_id as upx_filename_id,
    -- upx._author as upx_author,
    -- upx._authortype as upx_authortype,
    -- upx._comment as upx_comment,
    -- upx._date as upx_date,
    -- upx._diff as upx_diff,
    -- upx._format as upx_format,
    -- upx._machine as upx_machine,
    upx._mjsid as upx_mjsid,
    -- upx._version as upx_version,
    -- upi._filename_id as upi_filename_id,
    -- upi._bcrstatus as upi_bcrstatus,
    -- upi._code as upi_code,
    -- upi._lane as upi_lane,
    upi._lotname as upi_lotname,
    -- upi._lotnumber as upi_lotnumber,
    -- upi._output as upi_output,
    -- upi._planid as upi_planid,
    -- upi._productid as upi_productid,
    -- upi._rev as upi_rev,
    -- upi._serial as upi_serial,
    -- upi._serialstatus as upi_serialstatus,
    -- upi._stage as upi_stage,
    -- aftf._filename as aftf_filename,
    -- aftf._filename_type as aftf_filename_type,
    -- aftf._filename_timestamp as aftf_filename_timestamp,
    -- aftf._filename_route as aftf_filename_route,
    -- aftf._filename_id as aftf_fid,
    -- aafd._filename_id as aafd_filename_id,
    -- aafd._aoi_pcbid as aafd_aoi_pcbid,
    -- aafd._date_time as aafd_date_time,
    -- ai._filename_id as ai_filename_id,
    -- ai._cid as ai_cid,
    -- ai._timestamp as ai_timestamp,
    -- ai._crc as ai_crc,
    -- ai._c2d as ai_c2d,
    -- ai._recipename as ai_recipename,
    -- ai._mid as ai_mid,
    -- ap._filename_id as ap_filename_id,
    -- ap._p as ap_p,
    ap._cmp as ap_cmp,
    case
        when (ap._cmp = -1) then 'PASSED'
        when (ap._cmp = 1) then 'FAILED'
        else 'UNKNOWN'
    end as ap_board_status,
    -- ap._sc as ap_sc,
    -- ap._pid as ap_pid,
    -- ap._fc as ap_fc,
    -- mqt._filename_id as mqt_filename_id,
    -- mqt._b as mqt_b,
    -- mqt._idnum as mqt_idnum,
    -- mqt._turn as mqt_turn,
    -- mqt._ms as mqt_ms,
    -- mqt._ts as mqt_ts,
    -- mqt._fadd as mqt_fadd,
    -- mqt._fsadd as mqt_fsadd,
    -- mqt._fblkcode as mqt_fblkcode,
    -- mqt._fblkserial as mqt_fblkserial,
    -- mqt._nhadd as mqt_nhadd,
    -- mqt._ncadd as mqt_ncadd,
    -- mqt._nblkcode as mqt_nblkcode,
    -- mqt._nblkserial as mqt_nblkserial,
    -- mqt._reelid as mqt_reelid,
    -- mqt._f as mqt_f,
    -- case
        -- when (mqt._f = 0) then 'MOUNT SUCCESS'
        -- when (mqt._f = 1) then 'EXHAUST'
        -- when (mqt._f = 2) then 'PICK UP ERROR BY VACUUM SENSOR DETECTION'
        -- when (mqt._f = 3) then 'PICK UP ERROR BY RECOGNITION'
        -- when (mqt._f = 4) then 'COMPONENT STAND ERROR'
        -- when (mqt._f = 5) then 'RECOGNITION ERROR'
        -- when (mqt._f = 6) then 'DROP ERROR'
        -- when (mqt._f = 7) then 'MOUNT ERROR'
        -- when (mqt._f = 8) then 'BLOW OUT ERROR'
        -- when (mqt._f = 9) then 'NO MOUNT OR INVALID BY MOUNT SUSPEND'
        -- when (mqt._f = 10) then 'BAD NOZZLE PICK UP ERROR'
        -- when (mqt._f = 11) then 'BAD NOZZLE RECOGNITION ERROR'
        -- when (mqt._f = 12) then 'CONTINUE START'
        -- when (mqt._f = 13) then 'APC MOUNT CANCEL'
        -- when (mqt._f = 14) then 'MOUNT BLOW ERROR'
        -- when (mqt._f = 15) then 'DETECT TAPE CHANGE'
        -- when (mqt._f = 16) then 'COMPONENT THICKNESS ERROR'
        -- when (mqt._f = 17) then 'PICK UP ERROR WHEN COUNT MANDATORY'
        -- when (mqt._f = 18) then 'LEAD/BALL FLOAT ERROR'
        -- when (mqt._f = 19) then 'DETECT SHIFT PICK UP POSITION'
        -- when (mqt._f = 20) then 'COMPONENT DROP DIPPING UNIT'
        -- else 'UNKNOWN FAILURE'
    -- end as mqt_attempt_status,
    -- mqt._rcgx as mqt_rcgx,
    -- mqt._rcgy as mqt_rcgy,
    -- mqt._rcga as mqt_rcga,
    -- mqt._tcx as mqt_tcx,
    -- mqt._tcy as mqt_tcy,
    -- mqt._mposirecx as mqt_mposirecx,
    -- mqt._mposirecy as mqt_mposirecy,
    -- mqt._mposireca as mqt_mposireca,
    -- mqt._mposirecz as mqt_mposirecz,
    -- mqt._thmax as mqt_thmax,
    -- mqt._thave as mqt_thave,
    -- mqt._mntcx as mqt_mntcx,
    -- mqt._mntcy as mqt_mntcy,
    -- mqt._mntca as mqt_mntca,
    -- mqt._tlx as mqt_tlx,
    -- mqt._tly as mqt_tly,
    -- mqt._inspectarea as mqt_inspectarea,
    -- mqt._didnum as mqt_didnum,
    -- mqt._ds as mqt_ds,
    -- mqt._dispenseid as mqt_dispenseid,
    -- mqt._parts as mqt_parts,
    -- mqt._warpz as mqt_warpz,
    -- mqt._prepickuplot as mqt_prepickuplot,
    -- mqt._prepickupsts as mqt_prepickupsts,
    -- ccfd._filename_id as crb_fid,
    -- ccfd._history_id as ccfd_history_id,
    -- ccfd._time_stamp as ccfd_time_stamp,
    -- ccfd._crb_file_name as ccfd_crb_file_name,
    -- ccfd._product_name as ccfd_product_name,
    -- cl._filename_id as cl_filename_id,
    -- cl._idnum as cl_idnum,
    -- cl._lotnum as cl_lotnum,
    -- cl._lot as cl_lot,
    -- cl._mcfilename as cl_mcfilename,
    -- cl._filter as cl_filter,
    -- cl._autochg as cl_autochg,
    -- cl._basechg as cl_basechg,
    -- cl._lane as cl_lane,
    -- cl._productionid as cl_productionid,
    -- cl._simproduct as cl_simproduct,
    -- cl._dgspcbname as cl_dgspcbname,
    -- cl._dgspcbrev as cl_dgspcbrev,
    -- cl._dgspcbside as cl_dgspcbside,
    -- cl._dgsrefpin as cl_dgsrefpin,
    -- cl._c as cl_c,
    -- cl._datagenmode as cl_datagenmode,
    -- cl._mounthead as cl_mounthead,
    -- cl._vstpath as cl_vstpath,
    -- cl._order as cl_order,
    -- cl._targettact as cl_targettact,
    -- cp._filename_id as cp_filename_id,
    -- cp._lot_number as cp_lot_number,
    -- cp._idnum as cp_idnum,
    -- cp._cadid as cp_cadid,
    -- cp._x as cp_x,
    -- cp._y as cp_y,
    -- cp._a as cp_a,
    -- cp._parts as cp_parts,
    -- cp._brm as cp_brm,
    -- cp._turn as cp_turn,
    -- cp._dturn as cp_dturn,
    -- cp._ts as cp_ts,
    -- cp._ms as cp_ms,
    -- cp._ds as cp_ds,
    -- cp._np as cp_np,
    -- cp._dnp as cp_dnp,
    -- cp._pu as cp_pu,
    -- cp._side as cp_side,
    -- cp._dpu as cp_dpu,
    -- cp._head as cp_head,
    -- cp._dhead as cp_dhead,
    -- cp._ihead as cp_ihead,
    -- cp._b as cp_b,
    -- cp._pg as cp_pg,
    -- cp._s as cp_s,
    -- cp._rid as cp_rid,
    -- cp._c as cp_c,
    -- cp._m as cp_m,
    -- cp._mb as cp_mb,
    -- cp._f as cp_f,
    -- cp._pr as cp_pr,
    -- cp._priseq as cp_priseq,
    -- cp._p as cp_p,
    -- cp._pad as cp_pad,
    -- cp._vw as cp_vw,
    -- cp._stdpos as cp_stdpos,
    -- cp._land as cp_land,
    -- cp._depend as cp_depend,
    -- cp._chkflag as cp_chkflag,
    -- cp._exchk as cp_exchk,
    -- cp._grand as cp_grand,
    -- cp._marea as cp_marea,
    -- cp._rmset as cp_rmset,
    -- cp._sh as cp_sh,
    -- cp._scandir1 as cp_scandir1,
    -- cp._scandir2 as cp_scandir2,
    -- cp._ohl as cp_ohl,
    -- cp._ohr as cp_ohr,
    -- cp._apcctrl as cp_apcctrl,
    -- cp._wg as cp_wg,
    -- cp._skipnumber as cp_skipnumber,
    -- acmp._filename_id as acmp_filename_id,
    acmp._p as acmp_p,
    acmp._cmp as acmp_cmp
    -- acmp._cc as acmp_cc,
    -- acmp._ref as acmp_ref,
    -- acmp._type as acmp_type,
    -- ad._filename_id as ad_filename_id,
    -- ad._cmp as ad_cmp,
    -- ad._defect as ad_defect,
    -- ad._insp_type as ad_insp_type,
    -- ad._lead_id as ad_lead_id
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
inner join
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    aoi.insp ai
on
    upper(ai._c2d) = upper(ufd._pcb_id)
inner join
    aoi.filename_to_fid aftf
on
    aftf._filename_id = ai._filename_id
inner join
    aoi.aoi_filename_data aafd
on
    aafd._filename_id = ai._filename_id
inner join
    aoi.p ap
on
    ap._filename_id = ai._filename_id
inner join
    crb.crb_filename_data ccfd
on
    upper(ccfd._product_name) = upper(upx._mjsid)
inner join
    crb.lotnames cl
on
    cl._filename_id = ccfd._filename_id
and
    cl._lot = upi._lotname
inner join
    crb.positiondata cp
on
    cp._filename_id = ccfd._filename_id
and
    cp._lot_number = cl._lotnum
and
    cp._idnum = mqt._idnum
inner join
    aoi.cmp as acmp
on
    acmp._filename_id = ai._filename_id
and
    acmp._p = ap._p
and
    acmp._ref = cp._c
inner join
    aoi.defect ad
on
    ad._filename_id = ai._filename_id
and
    ad._cmp = acmp._cmp
;

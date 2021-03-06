select distinct
    -- ftf._filename_route as ftf_filename_route,
    --ufd._machine_order as ufd_machine_order,
    -- ufd._lane_no as ufd_lane_no,
    -- ufd._stage_no as ufd_stage_no,
    -- ftf._filename_timestamp as ftf_filename_timestamp,
    -- ftf._filename as ftf_filename,
    -- ftf._filename_type as ftf_filename_type,
    -- ftf._filename_id as ftf_filename_id,
    -- ufd._filename_id as ufd_filename_id,
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
    -- upx._mjsid as upx_mjsid,
    -- upx._version as upx_version,
    -- upi._filename_id as upi_filename_id,
    -- upi._bcrstatus as upi_bcrstatus,
    -- upi._code as upi_code,
    -- upi._lane as upi_lane,
    -- upi._lotname as upi_lotname,
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
    --ap._cmp as ap_cmp,
    --case
    --    when (ap._cmp = -1) then 'PASSED'
    --    when (ap._cmp = 1) then 'FAILED'
    --    else 'UNKNOWN'
    --end as ap_board_status,
    -- ap._sc as ap_sc,
    -- ap._pid as ap_pid,
    -- ap._fc as ap_fc,
    -- mqt._filename_id as mqt_filename_id,
    -- mqt._b as mqt_b,
    -- mqt._idnum as mqt_idnum,
    -- mqt._turn as mqt_turn,
    -- mqt._ms as mqt_ms,
    -- mqt._ts as mqt_ts,
    mqt._fadd as mqt_fadd,
    mqt._fsadd as mqt_fsadd,
    -- mqt._fblkcode as mqt_fblkcode,
     mqt._fblkserial as mqt_fblkserial,
     mqt._nhadd as mqt_nhadd,
     mqt._ncadd as mqt_ncadd,
	 cp._c as cp_c,
	 cast(csb._chipl as float) * cast(csb._chipw as float) as area,
    	
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
     mqt._rcgx as mqt_rcgx,
     mqt._rcgy as mqt_rcgy,
     mqt._rcga as mqt_rcga,
     mqt._tcx as mqt_tcx,
     mqt._tcy as mqt_tcy,
    -- mqt._mposirecx as mqt_mposirecx,
    -- mqt._mposirecy as mqt_mposirecy,
    -- mqt._mposireca as mqt_mposireca,
    -- mqt._mposirecz as mqt_mposirecz,
     mqt._thmax as mqt_thmax,
     mqt._thave as mqt_thave,
     mqt._mntcx as mqt_mntcx,
     mqt._mntcy as mqt_mntcy,
     mqt._mntca as mqt_mntca,
     mqt._tlx as mqt_tlx,
     mqt._tly as mqt_tly,
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
    cp._ms as cp_ms,
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
    --acmp._p as acmp_p,
    --acmp._cmp as acmp_cmp,
    -- acmp._cc as acmp_cc,
    --acmp._ref as acmp_ref
    -- acmp._type as acmp_type,
    -- ad._filename_id as ad_filename_id,
    -- ad._cmp as ad_cmp,
    -- ad._defect as ad_defect,
    -- ad._insp_type as ad_insp_type,
    -- ad._lead_id as ad_lead_id,
	null as dummy
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
--inner join
--    aoi.p ap
--on
--    ap._filename_id = ai._filename_id
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
    cp._lot_number = cast(cl._lotnum as integer)
and
    cast(cp._idnum as integer)= mqt._idnum
inner join
    crb.partsdata cpd
on
    cpd._filename_id = ccfd._filename_id
and
    cpd._idnum = cast(cp._parts as integer)
inner join
    crb.shapebase csb
on
    csb._filename_id = ccfd._filename_id
and
    csb._idnum =  cast(cpd._shape as integer) 
--inner join
--    aoi.cmp as acmp
--on
--    acmp._filename_id = ai._filename_id
--and
--    acmp._p = ap._p
--and
--    acmp._ref = cp._c
--inner join
--    aoi.defect ad
--on
--    ad._filename_id = ai._filename_id
--and
--    ad._cmp = acmp._cmp
where 
ftf._filename like '20161201%' AND ftf._filename like '%YEP0PTD171AF%'  
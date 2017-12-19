create table u03.pcb_mqt_pos_aoi_data
as
select
    ftf._filename_route      as ftf_filename_route,
    ufd._machine_order       as ufd_machine_order,
    ufd._lane_no             as ufd_lane_no,
    ufd._stage_no            as ufd_stage_no,
    ftf._filename_timestamp  as ftf_filename_timestamp,
    ftf._filename            as ftf_filename,
    ftf._filename_type       as ftf_filename_type,
    ftf._filename_id         as ftf_filename_id,
    ufd._filename_id         as ufd_filename_id,
    ufd._date                as ufd_date,
    ufd._pcb_serial          as ufd_pcb_serial,
    ufd._pcb_id              as ufd_pcb_id,
    ufd._output_no           as ufd_output_no,
    ufd._pcb_id_lot_no       as ufd_pcb_id_lot_no,
    ufd._pcb_id_serial_no    as ufd_pcb_id_serial_no,
    upx._filename_id         as upx_filename_id,
    upx._author              as upx_author,
    upx._authortype          as upx_authortype,
    upx._comment             as upx_comment,
    upx._date                as upx_date,
    upx._diff                as upx_diff,
    upx._format              as upx_format,
    upx._machine             as upx_machine,
    upx._mjsid               as upx_mjsid,
    upx._version             as upx_version,
    upi._filename_id         as upi_filename_id,
    upi._bcrstatus           as upi_bcrstatus,
    upi._code                as upi_code,
    upi._lane                as upi_lane,
    upi._lotname             as upi_lotname,
    upi._lotnumber           as upi_lotnumber,
    upi._output              as upi_output,
    upi._planid              as upi_planid,
    upi._productid           as upi_productid,
    upi._rev                 as upi_rev,
    upi._serial              as upi_serial,
    upi._serialstatus        as upi_serialstatus,
    upi._stage               as upi_stage,
    aftf._filename           as aftf_filename,
    aftf._filename_type      as aftf_filename_type,
    aftf._filename_timestamp as aftf_filename_timestamp,
    aftf._filename_route     as aftf_filename_route,
    aftf._filename_id        as aftf_fid,
    aafd._filename_id        as aafd_filename_id,
    aafd._aoi_pcbid          as aafd_aoi_pcbid,
    aafd._date_time          as aafd_date_time,
    ai._filename_id          as ai_filename_id,
    ai._cid                  as ai_cid,
    ai._timestamp            as ai_timestamp,
    ai._crc                  as ai_crc,
    ai._c2d                  as ai_c2d,
    ai._recipename           as ai_recipename,
    ai._mid                  as ai_mid,
    ap._filename_id          as ap_filename_id,
    ap._p                    as ap_p,
    ap._cmp                  as ap_cmp,
    case
        when (ap._cmp = -1) then 'PASSED'
        when (ap._cmp = 1) then 'FAILED'
        else 'UNKNOWN'
    end                      as ap_board_status,
    ap._sc                   as ap_sc,
    ap._pid                  as ap_pid,
    ap._fc                   as ap_fc,
    mqt._filename_id         as mqt_filename_id,
    mqt._b                   as mqt_b,
    mqt._idnum               as mqt_idnum,
    mqt._turn                as mqt_turn,
    mqt._ms                  as mqt_ms,
    mqt._ts                  as mqt_ts,
    mqt._fadd                as mqt_fadd,
    mqt._fsadd               as mqt_fsadd,
    mqt._fblkcode            as mqt_fblkcode,
    mqt._fblkserial          as mqt_fblkserial,
    mqt._nhadd               as mqt_nhadd,
    mqt._ncadd               as mqt_ncadd,
    mqt._nblkcode            as mqt_nblkcode,
    mqt._nblkserial          as mqt_nblkserial,
    mqt._reelid              as mqt_reelid,
    mqt._f                   as mqt_f,
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
    end                      as mqt_attempt_status,
    mqt._rcgx                as mqt_rcgx,
    mqt._rcgy                as mqt_rcgy,
    mqt._rcga                as mqt_rcga,
    mqt._tcx                 as mqt_tcx,
    mqt._tcy                 as mqt_tcy,
    mqt._mposirecx           as mqt_mposirecx,
    mqt._mposirecy           as mqt_mposirecy,
    mqt._mposireca           as mqt_mposireca,
    mqt._mposirecz           as mqt_mposirecz,
    mqt._thmax               as mqt_thmax,
    mqt._thave               as mqt_thave,
    mqt._mntcx               as mqt_mntcx,
    mqt._mntcy               as mqt_mntcy,
    mqt._mntca               as mqt_mntca,
    mqt._tlx                 as mqt_tlx,
    mqt._tly                 as mqt_tly,
    mqt._inspectarea         as mqt_inspectarea,
    mqt._didnum              as mqt_didnum,
    mqt._ds                  as mqt_ds,
    mqt._dispenseid          as mqt_dispenseid,
    mqt._parts               as mqt_parts,
    mqt._warpz               as mqt_warpz,
    mqt._prepickuplot        as mqt_prepickuplot,
    mqt._prepickupsts        as mqt_prepickupsts,
    ccfd._filename_id        as crb_fid,
    ccfd._history_id         as ccfd_history_id,
    ccfd._time_stamp         as ccfd_time_stamp,
    ccfd._crb_file_name      as ccfd_crb_file_name,
    ccfd._product_name       as ccfd_product_name,
    cl._filename_id          as cl_filename_id,
    cl._idnum                as cl_idnum,
    cl._lotnum               as cl_lotnum,
    cl._lot                  as cl_lot,
    cl._mcfilename           as cl_mcfilename,
    cl._filter               as cl_filter,
    cl._autochg              as cl_autochg,
    cl._basechg              as cl_basechg,
    cl._lane                 as cl_lane,
    cl._productionid         as cl_productionid,
    cl._simproduct           as cl_simproduct,
    cl._dgspcbname           as cl_dgspcbname,
    cl._dgspcbrev            as cl_dgspcbrev,
    cl._dgspcbside           as cl_dgspcbside,
    cl._dgsrefpin            as cl_dgsrefpin,
    cl._c                    as cl_c,
    cl._datagenmode          as cl_datagenmode,
    cl._mounthead            as cl_mounthead,
    cl._vstpath              as cl_vstpath,
    cl._order                as cl_order,
    cl._targettact           as cl_targettact,
    cp._filename_id          as cp_filename_id,
    cp._lot_number           as cp_lot_number,
    cp._idnum                as cp_idnum,
    cp._cadid                as cp_cadid,
    cp._x                    as cp_x,
    cp._y                    as cp_y,
    cp._a                    as cp_a,
    cp._parts                as cp_parts,
    cp._brm                  as cp_brm,
    cp._turn                 as cp_turn,
    cp._dturn                as cp_dturn,
    cp._ts                   as cp_ts,
    cp._ms                   as cp_ms,
    cp._ds                   as cp_ds,
    cp._np                   as cp_np,
    cp._dnp                  as cp_dnp,
    cp._pu                   as cp_pu,
    cp._side                 as cp_side,
    cp._dpu                  as cp_dpu,
    cp._head                 as cp_head,
    cp._dhead                as cp_dhead,
    cp._ihead                as cp_ihead,
    cp._b                    as cp_b,
    cp._pg                   as cp_pg,
    cp._s                    as cp_s,
    cp._rid                  as cp_rid,
    cp._c                    as cp_c,
    cp._m                    as cp_m,
    cp._mb                   as cp_mb,
    cp._f                    as cp_f,
    cp._pr                   as cp_pr,
    cp._priseq               as cp_priseq,
    cp._p                    as cp_p,
    cp._pad                  as cp_pad,
    cp._vw                   as cp_vw,
    cp._stdpos               as cp_stdpos,
    cp._land                 as cp_land,
    cp._depend               as cp_depend,
    cp._chkflag              as cp_chkflag,
    cp._exchk                as cp_exchk,
    cp._grand                as cp_grand,
    cp._marea                as cp_marea,
    cp._rmset                as cp_rmset,
    cp._sh                   as cp_sh,
    cp._scandir1             as cp_scandir1,
    cp._scandir2             as cp_scandir2,
    cp._ohl                  as cp_ohl,
    cp._ohr                  as cp_ohr,
    cp._apcctrl              as cp_apcctrl,
    cp._wg                   as cp_wg,
    cp._skipnumber           as cp_skipnumber,
    acmp._filename_id        as acmp_filename_id,
    acmp._p                  as acmp_p,
    acmp._cmp                as acmp_cmp,
    acmp._cc                 as acmp_cc,
    acmp._ref                as acmp_ref,
    acmp._type               as acmp_type,
    ad._filename_id          as ad_filename_id,
    ad._cmp                  as ad_cmp,
    ad._defect               as ad_defect,
    ad._insp_type            as ad_insp_type,
    ad._lead_id              as ad_lead_id
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
-- where 
--     ufd._pcb_id in
-- (
--     'YEP0PTD000LA|00|A|101633701823|01',
--     'YEP0PTD000LA|00|A|101633701825|01',
--     'YEP0PTD000LA|00|A|101633701828|01',
--     'YEP0PTD000LA|00|A|101633701830|01',
--     'YEP0PTD000LA|00|A|101633701832|01',
--     'YEP0PTD000LA|00|A|101633701834|01',
--     'YEP0PTD000LA|00|A|101633701836|01',
--     'YEP0PTD000LA|00|A|101633701838|01',
--     'YEP0PTD000LA|00|A|101633701839|01',
--     'YEP0PTD000LA|00|A|101633701840|01',
--     'YEP0PTD000LA|00|A|101633701854|01',
--     'YEP0PTD000LA|00|A|101633701856|01',
--     'YEP0PTD000LA|00|A|101633701858|01',
--     'YEP0PTD000LA|00|A|101633701860|01',
--     'YEP0PTD000LA|00|A|101633701862|01',
--     'YEP0PTD000LA|00|A|101633701864|01',
--     'YEP0PTD000LA|00|A|101633701865|01',
--     'YEP0PTD000LA|00|A|101633701866|01',
--     'YEP0PTD000LA|00|A|101633701867|01',
--     'YEP0PTD000LA|00|A|101633701869|01',
--     'YEP0PTD000LA|00|A|101633701871|01',
--     'YEP0PTD000LA|00|A|101633701872|01',
--     'YEP0PTD000LA|00|A|101633701874|01',
--     'YEP0PTD000LA|00|A|101633701875|01',
--     'YEP0PTD000LA|00|A|101633701879|01',
--     'YEP0PTD000LA|00|A|101633701880|01',
--     'YEP0PTD000LA|00|A|101633701881|01',
--     'YEP0PTD000LA|00|A|101633701889|01',
--     'YEP0PTD000LA|00|A|101633701891|01',
--     'YEP0PTD000LA|00|A|101633701893|01',
--     'YEP0PTD000LA|00|A|101633701895|01',
--     'YEP0PTD000LA|00|A|101633701897|01',
--     'YEP0PTD000LA|00|A|101633701899|01',
--     'YEP0PTD000LA|00|A|101633701901|01',
--     'YEP0PTD000LA|00|A|101633701903|01',
--     'YEP0PTD000LA|00|A|101633701905|01',
--     'YEP0PTD000LA|00|A|101633701907|01',
--     'YEP0PTD000LA|00|A|101633701908|01',
--     'YEP0PTD000LA|00|A|101633701911|01',
--     'YEP0PTD000LA|00|A|101633701913|01',
--     'YEP0PTD000LA|00|A|101633701915|01',
--     'YEP0PTD000LA|00|A|101633701917|01',
--     'YEP0PTD000LA|00|A|101633701919|01',
--     'YEP0PTD000LA|00|A|101633701921|01',
--     'YEP0PTD000LA|00|A|101633701923|01',
--     'YEP0PTD000LA|00|A|101633701963|01',
--     'YEP0PTD000LA|00|A|101633701965|01',
--     'YEP0PTD000LA|00|A|101633701967|01',
--     'YEP0PTD000LA|00|A|101633701982|01',
--     'YEP0PTD000LA|00|A|101633701983|01',
--     'YEP0PTD000LA|00|A|101633701985|01',
--     'YEP0PTD000LA|00|A|101633701987|01',
--     'YEP0PTD000LA|00|A|101633701989|01',
--     'YEP0PTD000LA|00|A|101633701991|01',
--     'YEP0PTD000LA|00|A|101633701993|01',
--     'YEP0PTD000LA|00|A|101633701997|01',
--     'YEP0PTD000LA|00|A|101633701998|01',
--     'YEP0PTD000LA|00|A|101633702000|01',
--     'YEP0PTD000LA|00|A|101633702002|01',
--     'YEP0PTD000LA|00|A|101633702004|01',
--     'YEP0PTD000LA|00|A|101633702009|01',
--     'YEP0PTD000LA|00|A|101633702011|01',
--     'YEP0PTD000LA|00|A|101633702013|01',
--     'YEP0PTD000LA|00|A|101633702015|01',
--     'YEP0PTD000LA|00|A|101633702017|01',
--     'YEP0PTD000LA|00|A|101633702019|01',
--     'YEP0PTD000LA|00|A|101633702021|01',
--     'YEP0PTD000LA|00|A|101633702023|01',
--     'YEP0PTD000LA|00|A|101633702025|01',
--     'YEP0PTD000LA|00|A|101633702027|01',
--     'YEP0PTD000LA|00|A|101633702032|01',
--     'YEP0PTD000LA|00|A|101633702033|01',
--     'YEP0PTD000LA|00|A|101633702034|01',
--     'YEP0PTD000LA|00|A|101633702035|01',
--     'YEP0PTD000LA|00|A|101633702036|01',
--     'YEP0PTD000LA|00|A|101633702037|01',
--     'YEP0PTD000LA|00|A|101633702038|01',
--     'YEP0PTD000LA|00|A|101633702039|01',
--     'YEP0PTD000LA|00|A|101633702040|01',
--     'YEP0PTD000LA|00|A|101633702041|01',
--     'YEP0PTD000LA|00|A|101633702042|01',
--     'YEP0PTD000LA|00|A|101633702043|01',
--     'YEP0PTD000LA|00|A|101633702044|01',
--     'YEP0PTD000LA|00|A|101633702045|01',
--     'YEP0PTD000LA|00|A|101633702046|01',
--     'YEP0PTD000LA|00|A|101633702047|01',
--     'YEP0PTD000LA|00|A|101633702048|01',
--     'YEP0PTD000LA|00|A|101633702049|01',
--     'YEP0PTD000LA|00|A|101633702050|01',
--     'YEP0PTD000LA|00|A|101633702051|01',
--     'YEP0PTD000LA|00|A|101633702060|01',
--     'YEP0PTD000LA|00|A|101633702061|01',
--     'YEP0PTD000LA|00|A|101633702091|01',
--     'YEP0PTD000LA|00|A|101633702093|01',
--     'YEP0PTD000LA|00|A|101633702095|01',
--     'YEP0PTD000LA|00|A|101633702097|01',
--     'YEP0PTD000LA|00|A|101633702099|01',
--     'YEP0PTD000LA|00|A|101633702101|01',
--     'YEP0PTD000LA|00|A|101633702103|01',
--     'YEP0PTD000LA|00|A|101633702105|01',
--     'YEP0PTD000LA|00|A|101633800105|01',
--     'YEP0PTD000LA|00|A|101633800129|01',
--     'YEP0PTD000LA|00|A|101633800190|01',
--     'YEP0PTD000LA|00|A|101633800192|01',
--     'YEP0PTD000LA|00|A|101633800193|01',
--     'YEP0PTD000LA|00|A|101633800195|01',
--     'YEP0PTD000LA|00|A|101633800198|01',
--     'YEP0PTD000LA|00|A|101633800200|01',
--     'YEP0PTD000LA|00|A|101633800202|01',
--     'YEP0PTD000LA|00|A|101633800205|01',
--     'YEP0PTD000LA|00|A|101633800206|01',
--     'YEP0PTD000LA|00|A|101633800208|01',
--     'YEP0PTD000LA|00|A|101633800210|01',
--     'YEP0PTD000LA|00|A|101633800212|01',
--     'YEP0PTD000LA|00|A|101633800214|01',
--     'YEP0PTD000LA|00|A|101633800216|01',
--     'YEP0PTD000LA|00|A|101633800218|01',
--     'YEP0PTD000LA|00|A|101633800220|01',
--     'YEP0PTD000LA|00|A|101633800222|01',
--     'YEP0PTD000LA|00|A|101633800225|01',
--     'YEP0PTD000LA|00|A|101633800227|01',
--     'YEP0PTD000LA|00|A|101633800229|01',
--     'YEP0PTD000LA|00|A|101633800231|01',
--     'YEP0PTD000LA|00|A|101633800233|01',
--     'YEP0PTD000LA|00|A|101633800235|01',
--     'YEP0PTD000LA|00|A|101633800237|01',
--     'YEP0PTD000LA|00|A|101633800239|01',
--     'YEP0PTD000LA|00|A|101633800327|01',
--     'YEP0PTD000LA|00|A|101633800329|01',
--     'YEP0PTD000LA|00|A|101633800330|01',
--     'YEP0PTD000LA|00|A|101633800333|01',
--     'YEP0PTD000LA|00|A|101633800335|01',
--     'YEP0PTD000LA|00|A|101633800337|01',
--     'YEP0PTD000LA|00|A|101633800341|01',
--     'YEP0PTD000LA|00|A|101633800344|01',
--     'YEP0PTD000LA|00|A|101633800346|01',
--     'YEP0PTD000LA|00|A|101633800348|01',
--     'YEP0PTD000LA|00|A|101633800350|01',
--     'YEP0PTD000LA|00|A|101633800351|01',
--     'YEP0PTD000LA|00|A|101633800353|01',
--     'YEP0PTD000LA|00|A|101633800355|01',
--     'YEP0PTD000LA|00|A|101633800357|01',
--     'YEP0PTD000LA|00|A|101633800359|01',
--     'YEP0PTD000LA|00|A|101633800362|01',
--     'YEP0PTD000LA|00|A|101633800364|01',
--     'YEP0PTD000LA|00|A|101633800366|01',
--     'YEP0PTD000LA|00|A|101633800368|01',
--     'YEP0PTD000LA|00|A|101633800370|01',
--     'YEP0PTD000LA|00|A|101633800372|01',
--     'YEP0PTD000LA|00|A|101633800374|01'
-- )
-- order by
    -- ftf._filename_route,
    -- ftf._filename_timestamp,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no
;


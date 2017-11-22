-- 
-- with zcass_cte (
--     pcb_id,
--     pcb_serial,
--     machine_order,
--     lane_no,
--     stage_no,
--     timestamp,
--     fadd,
--     fsadd,
--     mjsid,
--     lotname,
--     reelid,
--     partsname,
--     output_no,
--     blkserial,
--     pickup,
--     pmiss,
--     rmiss,
--     dmiss,
--     mmiss,
--     hmiss,
--     trsmiss,
--     mount,
--     row
-- ) as (
--    select
--        ufd._pcb_id             as pcb_id,
--        ufd._pcb_serial         as pcb_serial,
--        ufd._machine_order      as machine_order,
--        ufd._lane_no            as lane_no,
--        ufd._stage_no           as stage_no,
--        fnf._filename_timestamp as timestamp,
--        mpf._fadd               as fadd,
--        mpf._fsadd              as fsadd,
--        uidx._value             as mjsid,
--        uinf._value             as lotname,
--        mpf._reelid             as reelid,
--        mpf._partsname          as partsname,
--        ufd._output_no          as output_no,
--        mpf._blkserial          as blkserial,
--        mpf._pickup             as pickup,
--        mpf._pmiss              as pmiss,
--        mpf._rmiss              as rmiss,
--        mpf._dmiss              as dmiss,
--        mpf._mmiss              as mmiss,
--        mpf._hmiss              as hmiss,
--        mpf._trsmiss            as trsmiss,
--        mpf._mount              as mount,
--        row_number() over (
--            partition by
--                ufd._machine_order,
--                ufd._lane_no,
--                ufd._stage_no,
--                mpf._fadd,
--                mpf._fsadd,
--                uidx._value,
--                uinf._value,
--                mpf._reelid,
--                mpf._partsname,
--                mpf._blkserial
--            order by
--                ufd._machine_order,
--                ufd._lane_no,
--                ufd._stage_no,
--                mpf._fadd,
--                mpf._fsadd,
--                fnf._filename_timestamp
--        ) as row
--    from
--        u01.mountpickupfeeder mpf
--    inner join
--        u01.filename_to_fid fnf
--    on
--        fnf._filename_id = mpf._filename_id
--    inner join
--        u01.u0x_filename_data ufd
--    on
--        ufd._filename_id = mpf._filename_id
--    inner join
--        u01.index uidx
--    on
--        uidx._filename_id = mpf._filename_id
--    and
--        uidx._name = 'MJSID'
--    inner join
--        u01.information uinf
--    on
--        uinf._filename_id = mpf._filename_id
--    and
--        uinf._name = 'LotName'
--    where
--        ufd._output_no in ( 3, 4, 5 )
--    -- order by
--        -- ufd._machine_order asc,
--        -- ufd._lane_no asc,
--        -- mpf._fadd asc,
--        -- mpf._fsadd asc,
--        -- fnf._filename_timestamp asc
-- ) select
--     curr.pcb_id as pcb_id,
--     curr.pcb_serial as pcb_serial,
--     -- curr.row as curr_row,
--     -- prev.row as prev_row,
--     curr.machine_order as machine_order,
--     -- prev.machine_order as prev_machine_order,
--     curr.lane_no as lane_no,
--     -- prev.lane_no as prev_lane_no,
--     curr.stage_no as stage_no,
--     -- prev.stage_no as prev_stage_no,
--     curr.timestamp as timestamp,
--     -- prev.timestamp as prev_timestamp,
--     curr.fadd as fadd,
--     -- prev.fadd as prev_fadd,
--     curr.fsadd as fsadd,
--     -- prev.fsadd as prev_fsadd,
--     curr.mjsid as mjsid,
--     -- prev.mjsid as prev_mjsid,
--     curr.lotname as lotname,
--     -- prev.lotname as prev_lotname,
--     curr.reelid as reelid,
--     -- prev.reelid as prev_reelid,
--     curr.partsname as partsname,
--     -- prev.partsname as prev_partsname,
--     -- curr.output_no as curr_output_no,
--     -- prev.output_no as prev_output_no,
--     curr.blkserial as blkserial,
--     -- prev.blkserial as prev_blkserial,
-- 
--     -- curr.pickup as curr_pickup,
--     -- prev.pickup as prev_pickup,
--     curr.pickup - prev.pickup as pickup,
-- 
--     -- curr.pmiss as curr_pmiss,
--     -- prev.pmiss as prev_pmiss,
--     curr.pmiss - prev.pmiss as pmiss,
-- 
--     -- curr.rmiss as curr_rmiss,
--     -- prev.rmiss as prev_rmiss,
--     curr.rmiss - prev.rmiss as rmiss,
-- 
--     -- curr.dmiss as curr_dmiss,
--     -- prev.dmiss as prev_dmiss,
--     curr.dmiss - prev.dmiss as dmiss,
-- 
--     -- curr.mmiss as curr_mmiss,
--     -- prev.mmiss as prev_mmiss,
--     curr.mmiss - prev.mmiss as mmiss,
-- 
--     -- curr.hmiss as curr_hmiss,
--     -- prev.hmiss as prev_hmiss,
--     curr.hmiss - prev.hmiss as hmiss,
-- 
--     -- curr.trsmiss as curr_trsmiss,
--     -- prev.trsmiss as prev_trsmiss,
--     curr.trsmiss - prev.trsmiss as trsmiss,
-- 
--     -- curr.mount as curr_mount,
--     -- prev.mount as prev_moun,
--     curr.mount - prev.mount as mount
-- 
-- from 
--     zcass_cte curr
-- inner join
--     zcass_cte prev
-- on
--     curr.row = prev.row + 1
-- and
--     curr.machine_order = prev.machine_order
-- and
--     curr.lane_no = prev.lane_no
-- and
--     curr.stage_no = prev.stage_no
-- and
--     curr.fadd = prev.fadd
-- and
--     curr.fsadd = prev.fsadd
-- and
--     curr.mjsid = prev.mjsid
-- and
--     curr.lotname = prev.lotname
-- and
--     curr.reelid = prev.reelid
-- and
--     curr.partsname = prev.partsname
-- and
--     curr.blkserial = prev.blkserial
-- order by
--     machine_order asc,
--     lane_no asc,
--     timestamp asc,
--     fadd asc,
--     fsadd asc
-- ;

with prod_count_cte (
    pcb_id,
    pcb_serial,
    machine_order,
    lane_no,
    stage_no,
    timestamp,
    mjsid,
    lotname,
    output_no,
    bndrcgstop,
    bndstop,
    board,
    brcgstop,
    bwait,
    cderr,
    cmerr,
    cnvstop,
    cperr,
    crerr,
    cterr,
    cwait,
    fbstop,
    fwait,
    jointpasswait,
    judgestop,
    lotboard,
    lotmodule,
    mcfwait,
    mcrwait,
    mhrcgstop,
    module,
    otherlstop,
    othrstop,
    pwait,
    rwait,
    scestop,
    scstop,
    swait,
    tdispense,
    tdmiss,
    thmiss,
    tmmiss,
    tmount,
    tpickup,
    tpmiss,
    tpriming,
    trbl,
    trmiss,
    trserr,
    trsmiss,
    row
) as (
    select
        ufd._pcb_id             as pcb_id,
        ufd._pcb_serial         as pcb_serial,
        ufd._machine_order      as machine_order,
        ufd._lane_no            as lane_no,
        ufd._stage_no           as stage_no,
        fnf._filename_timestamp as timestamp,
        uidx._value             as mjsid,
        uinf._value             as lotname,
        ufd._output_no          as output_no,
        pc._bndrcgstop          as bndrcgstop,
        pc._bndstop             as bndstop,
        pc._board               as board,
        pc._brcgstop            as brcgstop,
        pc._bwait               as bwait,
        pc._cderr               as cderr,
        pc._cmerr               as cmerr,
        pc._cnvstop             as cnvstop,
        pc._cperr               as cperr,
        pc._crerr               as crerr,
        pc._cterr               as cterr,
        pc._cwait               as cwait,
        pc._fbstop              as fbstop,
        pc._fwait               as fwait,
        pc._jointpasswait       as jointpasswait,
        pc._judgestop           as judgestop,
        pc._lotboard            as lotboard,
        pc._lotmodule           as lotmodule,
        pc._mcfwait             as mcfwait,
        pc._mcrwait             as mcrwait,
        pc._mhrcgstop           as mhrcgstop,
        pc._module              as module,
        pc._otherlstop          as otherlstop,
        pc._othrstop            as othrstop,
        pc._pwait               as pwait,
        pc._rwait               as rwait,
        pc._scestop             as scestop,
        pc._scstop              as scstop,
        pc._swait               as swait,
        pc._tdispense           as tdispense,
        pc._tdmiss              as tdmiss,
        pc._thmiss              as thmiss,
        pc._tmmiss              as tmmiss,
        pc._tmount              as tmount,
        pc._tpickup             as tpickup,
        pc._tpmiss              as tpmiss,
        pc._tpriming            as tpriming,
        pc._trbl                as trbl,
        pc._trmiss              as trmiss,
        pc._trserr              as trserr,
        pc._trsmiss             as trsmiss,
        row_number() over (
            partition by
                ufd._machine_order,
                ufd._lane_no,
                ufd._stage_no,
                uidx._value,
                uinf._value
            order by
                ufd._machine_order,
                ufd._lane_no,
                ufd._stage_no,
                fnf._filename_timestamp
        ) as row
    from
        u01.pivot_count pc
    inner join
        u01.filename_to_fid fnf
    on
        fnf._filename_id = pc._filename_id
    inner join
        u01.u0x_filename_data ufd
    on
        ufd._filename_id = pc._filename_id
    inner join
        u01.index uidx
    on
        uidx._filename_id = pc._filename_id
    and
        uidx._name = 'MJSID'
    inner join
        u01.information uinf
    on
        uinf._filename_id = pc._filename_id
    and
        uinf._name = 'LotName'
    where
        ufd._output_no in ( 3, 4, 5 )
) select
    curr.pcb_id as pcb_id,
    curr.pcb_serial as pcb_serial,
    curr.machine_order as machine_order,
    curr.lane_no as lane_no,
    curr.stage_no as stage_no,
    curr.timestamp as timestamp,
    curr.mjsid as mjsid,
    curr.lotname as lotname,
    curr.bndrcgstop - prev.bndrcgstop as bndrcgstop,
    curr.bndstop - prev.bndstop as bndstop,
    curr.board - prev.board as board,
    curr.brcgstop - prev.brcgstop as brcgstop,
    curr.bwait - prev.bwait as bwait,
    curr.cderr - prev.cderr as cderr,
    curr.cmerr - prev.cmerr as cmerr,
    curr.cnvstop - prev.cnvstop as cnvstop,
    curr.cperr - prev.cperr as cperr,
    curr.crerr - prev.crerr as crerr,
    curr.cterr - prev.cterr as cterr,
    curr.cwait - prev.cwait as cwait,
    curr.fbstop - prev.fbstop as fbstop,
    curr.fwait - prev.fwait as fwait,
    curr.jointpasswait - prev.jointpasswait as jointpasswait,
    curr.judgestop - prev.judgestop as judgestop,
    curr.lotboard - prev.lotboard as lotboard,
    curr.lotmodule - prev.lotmodule as lotmodule,
    curr.mcfwait - prev.mcfwait as mcfwait,
    curr.mcrwait - prev.mcrwait as mcrwait,
    curr.mhrcgstop - prev.mhrcgstop as mhrcgstop,
    curr.module - prev.module as module,
    curr.otherlstop - prev.otherlstop as otherlstop,
    curr.othrstop - prev.othrstop as othrstop,
    curr.pwait - prev.pwait as pwait,
    curr.rwait - prev.rwait as rwait,
    curr.scestop - prev.scestop as scestop,
    curr.scstop - prev.scstop as scstop,
    curr.swait - prev.swait as swait,
    curr.tdispense - prev.tdispense as tdispense,
    curr.tdmiss - prev.tdmiss as tdmiss,
    curr.thmiss - prev.thmiss as thmiss,
    curr.tmmiss - prev.tmmiss as tmmiss,
    curr.tmount - prev.tmount as tmount,
    curr.tpickup - prev.tpickup as tpickup,
    curr.tpmiss - prev.tpmiss as tpmiss,
    curr.tpriming - prev.tpriming as tpriming,
    curr.trbl - prev.trbl as trbl,
    curr.trmiss - prev.trmiss as trmiss,
    curr.trserr - prev.trserr as trserr,
    curr.trsmiss - prev.trsmiss as trsmiss

    -- curr.pickup as curr_pickup,
    -- prev.pickup as prev_pickup,
    -- curr.pickup - prev.pickup as pickup,
from 
    prod_count_cte curr
inner join
    prod_count_cte prev
on
    curr.row = prev.row + 1
and
    curr.machine_order = prev.machine_order
and
    curr.lane_no = prev.lane_no
and
    curr.stage_no = prev.stage_no
and
    curr.mjsid = prev.mjsid
and
    curr.lotname = prev.lotname
order by
    machine_order asc,
    lane_no asc,
    timestamp asc
;


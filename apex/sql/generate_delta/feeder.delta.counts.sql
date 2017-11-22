--select
--    fnf._filename,
--    fnf._filename_type,
--    fnf._filename_timestamp,
--    fnf._filename_route,
--    fnf._filename_id,
--    ufd._filename_id,
--    ufd._date,
--    ufd._machine_order,
--    ufd._stage_no,
--    ufd._lane_no,
--    ufd._pcb_serial,
--    ufd._pcb_id,
--    ufd._output_no,
--    ufd._pcb_id_lot_no,
--    ufd._pcb_id_serial_no,
--    mpf._filename_id,
--    mpf._blkcode,
--    mpf._blkserial,
--    mpf._usef,
--    mpf._partsname,
--    mpf._fadd,
--    mpf._fsadd,
--    mpf._reelid,
--    mpf._user,
--    mpf._pickup,
--    mpf._pmiss,
--    mpf._rmiss,
--    mpf._dmiss,
--    mpf._mmiss,
--    mpf._hmiss,
--    mpf._trsmiss,
--    mpf._mount,
--    mpf._lname,
--    mpf._tgserial,
--    null as dummy
--from
--    u01.mountpickupfeeder mpf
--inner join
--    u01.filename_to_fid fnf
--on
--    fnf._filename_id = mpf._filename_id
--inner join
--    u01.u0x_filename_data ufd
--on
--    ufd._filename_id = mpf._filename_id
--order by
--    ufd._machine_order,
--    ufd._lane_no,
--    fnf._filename_timestamp ;
----limit (100);

-- select
--     -- fnf._filename_id,
--     ufd._machine_order,
--     ufd._lane_no,
--     ufd._stage_no,
--     -- fnf._filename,
--     -- fnf._filename_type,
--     fnf._filename_timestamp,
--     mpf._fadd,
--     mpf._fsadd,
--     uidx._value as mjsid,
--     uinf._value as lotname,
--     mpf._reelid,
--     mpf._partsname,
--     -- fnf._filename_route,
--     -- fnf._filename_id,
--     -- ufd._filename_id,
--     -- ufd._date,
--     -- ufd._pcb_serial,
--     -- ufd._pcb_id,
--     ufd._output_no,
--     -- ufd._pcb_id_lot_no,
--     -- ufd._pcb_id_serial_no,
--     -- mpf._filename_id,
--     -- mpf._blkcode,
--     mpf._blkserial,
--     -- mpf._usef,
--     -- mpf._user,
--     mpf._pickup,
--     mpf._pmiss,
--     mpf._rmiss,
--     mpf._dmiss,
--     mpf._mmiss,
--     mpf._hmiss,
--     mpf._trsmiss,
--     mpf._mount,
--     -- mpf._lname,
--     -- mpf._tgserial,
--     null as dummy
-- from
--     u01.mountpickupfeeder mpf
-- inner join
--     u01.filename_to_fid fnf
-- on
--     fnf._filename_id = mpf._filename_id
-- inner join
--     u01.u0x_filename_data ufd
-- on
--     ufd._filename_id = mpf._filename_id
-- inner join
--     u01.index uidx
-- on
--     uidx._filename_id = mpf._filename_id
-- and
--     uidx._name = 'MJSID'
-- inner join
--     u01.information uinf
-- on
--     uinf._filename_id = mpf._filename_id
-- and
--     uinf._name = 'LotName'
-- where
--     ufd._output_no in ( 3, 4, 5 )
-- order by
--     ufd._machine_order asc,
--     ufd._lane_no asc,
--     mpf._fadd asc,
--     mpf._fsadd asc,
--     fnf._filename_timestamp asc
-- ;

-- with 
--     z_cass_cte (
--         eqid, 
--         lnno, 
--         rid,
--         fadd, 
--         fsadd, 
--         pkup,
--         plc,
--         tmiss,
--         rmiss,
--         hmiss,
--         fmiss,
--         mmiss,
--         row
--     )
-- as (
--     select
--         eq.equipment_name as eqid,
--         zhr.lane_no as lnno,
--         zhr.report_id as rid,
--         zr.fadd as fadd,
--         zr.fsadd as fsadd,
--         zr.tcnt as pkup,
--         zr.place_count as plc,
--         zr.tmiss as tmiss,
--         zr.rmiss as rmiss,
--         zr.hmiss as hmiss,
--         zr.fmiss as fmiss,
--         zr.mmiss as mmiss,
--         row_number() over (
--             partition by 
--                 eq.equipment_name, 
--                 zhr.lane_no, 
--                 zr.fadd, 
--                 zr.fsadd
--             order by
--                 eq.equipment_name asc, 
--                 zhr.lane_no asc, 
--                 zr.report_id asc,
--                 zr.fadd asc,
--                 zr.fsadd asc
--         ) as row
--     from
--         z_cass_npm_hdr_raw zhr
--     inner join
--         z_cass_npm_raw zr
--     on
--         zhr.report_id = zr.report_id
--     inner join
--         equipment eq
--     on
--         zhr.equipment_id = eq.equipment_id
-- )
-- select
--     curr.row as curr_row,
--     prev.row as prev_row,
--     curr.eqid as curr_eqid, 
--     curr.lnno as curr_lnno, 
--     curr.fadd as curr_fadd, 
--     curr.fsadd as curr_fsadd, 
--     curr.pkup as curr_pkup,
--     curr.plc as curr_plc,
--     curr.tmiss as curr_tmiss,
--     curr.rmiss as curr_rmiss,
--     curr.hmiss as curr_hmiss,
--     curr.fmiss as curr_fmiss,
--     curr.mmiss as curr_mmiss,
--     prev.fadd as prev_fadd, 
--     prev.fsadd as prev_fsadd, 
--     prev.pkup as prev_pkup,
--     prev.plc as prev_plc,
--     prev.tmiss as tmiss,
--     prev.rmiss as rmiss,
--     prev.hmiss as hmiss,
--     prev.fmiss as fmiss,
--     prev.mmiss as mmiss,
--     curr.pkup - prev.pkup as delta_pkup,
--     curr.plc - prev.plc as delta_plc,
--     curr.tmiss - prev.tmiss as delta_tmiss,
--     curr.rmiss - prev.rmiss as delta_rmiss,
--     curr.hmiss - prev.hmiss as delta_hmiss,
--     curr.fmiss - prev.fmiss as delta_fmiss,
--     curr.mmiss - prev.mmiss as delta_mmiss
-- from
--     z_cass_cte curr
-- left outer join
--     z_cass_cte prev
-- on
--     curr.row = prev.row + 1
-- where
--     curr.eqid = prev.eqid
-- and 
--     curr.lnno = prev.lnno
-- and
--     curr.fadd = prev.fadd
-- and 
--     curr.fsadd = prev.fsadd
-- order by
--     curr.eqid asc,
--     curr.lnno asc,
--     curr.fadd asc,
--     curr.fsadd asc
-- go

with zcass_cte (
    pcb_id,
    pcb_serial,
    machine_order,
    lane_no,
    stage_no,
    timestamp,
    fadd,
    fsadd,
    mjsid,
    lotname,
    reelid,
    partsname,
    output_no,
    blkserial,
    pickup,
    pmiss,
    rmiss,
    dmiss,
    mmiss,
    hmiss,
    trsmiss,
    mount,
    row
) as (
   select
       ufd._pcb_id             as pcb_id,
       ufd._pcb_serial         as pcb_serial,
       ufd._machine_order      as machine_order,
       ufd._lane_no            as lane_no,
       ufd._stage_no           as stage_no,
       fnf._filename_timestamp as timestamp,
       mpf._fadd               as fadd,
       mpf._fsadd              as fsadd,
       uidx._value             as mjsid,
       uinf._value             as lotname,
       mpf._reelid             as reelid,
       mpf._partsname          as partsname,
       ufd._output_no          as output_no,
       mpf._blkserial          as blkserial,
       mpf._pickup             as pickup,
       mpf._pmiss              as pmiss,
       mpf._rmiss              as rmiss,
       mpf._dmiss              as dmiss,
       mpf._mmiss              as mmiss,
       mpf._hmiss              as hmiss,
       mpf._trsmiss            as trsmiss,
       mpf._mount              as mount,
       row_number() over (
           partition by
               ufd._machine_order,
               ufd._lane_no,
               ufd._stage_no,
               mpf._fadd,
               mpf._fsadd,
               uidx._value,
               uinf._value,
               mpf._reelid,
               mpf._partsname,
               mpf._blkserial
           order by
               ufd._machine_order,
               ufd._lane_no,
               ufd._stage_no,
               mpf._fadd,
               mpf._fsadd,
               fnf._filename_timestamp
       ) as row
   from
       u01.mountpickupfeeder mpf
   inner join
       u01.filename_to_fid fnf
   on
       fnf._filename_id = mpf._filename_id
   inner join
       u01.u0x_filename_data ufd
   on
       ufd._filename_id = mpf._filename_id
   inner join
       u01.index uidx
   on
       uidx._filename_id = mpf._filename_id
   and
       uidx._name = 'MJSID'
   inner join
       u01.information uinf
   on
       uinf._filename_id = mpf._filename_id
   and
       uinf._name = 'LotName'
   where
       ufd._output_no in ( 3, 4, 5 )
   -- order by
       -- ufd._machine_order asc,
       -- ufd._lane_no asc,
       -- mpf._fadd asc,
       -- mpf._fsadd asc,
       -- fnf._filename_timestamp asc
) select
    curr.pcb_id as pcb_id,
    curr.pcb_serial as pcb_serial,
    -- curr.row as curr_row,
    -- prev.row as prev_row,
    curr.machine_order as machine_order,
    -- prev.machine_order as prev_machine_order,
    curr.lane_no as lane_no,
    -- prev.lane_no as prev_lane_no,
    curr.stage_no as stage_no,
    -- prev.stage_no as prev_stage_no,
    curr.timestamp as timestamp,
    -- prev.timestamp as prev_timestamp,
    curr.fadd as fadd,
    -- prev.fadd as prev_fadd,
    curr.fsadd as fsadd,
    -- prev.fsadd as prev_fsadd,
    curr.mjsid as mjsid,
    -- prev.mjsid as prev_mjsid,
    curr.lotname as lotname,
    -- prev.lotname as prev_lotname,
    curr.reelid as reelid,
    -- prev.reelid as prev_reelid,
    curr.partsname as partsname,
    -- prev.partsname as prev_partsname,
    -- curr.output_no as curr_output_no,
    -- prev.output_no as prev_output_no,
    curr.blkserial as blkserial,
    -- prev.blkserial as prev_blkserial,

    -- curr.pickup as curr_pickup,
    -- prev.pickup as prev_pickup,
    curr.pickup - prev.pickup as pickup,

    -- curr.pmiss as curr_pmiss,
    -- prev.pmiss as prev_pmiss,
    curr.pmiss - prev.pmiss as pmiss,

    -- curr.rmiss as curr_rmiss,
    -- prev.rmiss as prev_rmiss,
    curr.rmiss - prev.rmiss as rmiss,

    -- curr.dmiss as curr_dmiss,
    -- prev.dmiss as prev_dmiss,
    curr.dmiss - prev.dmiss as dmiss,

    -- curr.mmiss as curr_mmiss,
    -- prev.mmiss as prev_mmiss,
    curr.mmiss - prev.mmiss as mmiss,

    -- curr.hmiss as curr_hmiss,
    -- prev.hmiss as prev_hmiss,
    curr.hmiss - prev.hmiss as hmiss,

    -- curr.trsmiss as curr_trsmiss,
    -- prev.trsmiss as prev_trsmiss,
    curr.trsmiss - prev.trsmiss as trsmiss,

    -- curr.mount as curr_mount,
    -- prev.mount as prev_moun,
    curr.mount - prev.mount as mount

from 
    zcass_cte curr
inner join
    zcass_cte prev
on
    curr.row = prev.row + 1
and
    curr.machine_order = prev.machine_order
and
    curr.lane_no = prev.lane_no
and
    curr.stage_no = prev.stage_no
and
    curr.fadd = prev.fadd
and
    curr.fsadd = prev.fsadd
and
    curr.mjsid = prev.mjsid
and
    curr.lotname = prev.lotname
and
    curr.reelid = prev.reelid
and
    curr.partsname = prev.partsname
and
    curr.blkserial = prev.blkserial
order by
    machine_order asc,
    lane_no asc,
    timestamp asc,
    fadd asc,
    fsadd asc
;


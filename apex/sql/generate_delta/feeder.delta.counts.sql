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
    mount
) as (
   select
       ufd._machine_order as machine_order,
       ufd._lane_no as lane_no,
       ufd._stage_no as stage_no,
       fnf._filename_timestamp as timestamp,
       mpf._fadd as fadd,
       mpf._fsadd as fsadd,
       uidx._value as mjsid,
       uinf._value as lotname,
       mpf._reelid as reelid,
       mpf._partsname as partsname,
       ufd._output_no as output_no,
       mpf._blkserial as blkserial,
       mpf._pickup as pickup,
       mpf._pmiss as pmiss,
       mpf._rmiss as rmiss,
       mpf._dmiss as dmiss,
       mpf._mmiss as mmiss,
       mpf._hmiss as hmiss,
       mpf._trsmiss as trsmiss,
       mpf._mount as mount
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
   order by
       ufd._machine_order asc,
       ufd._lane_no asc,
       mpf._fadd asc,
       mpf._fsadd asc,
       fnf._filename_timestamp asc
) select * from zcass_cte;


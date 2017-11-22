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

select
    fnf._filename_id,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    -- fnf._filename,
    -- fnf._filename_type,
    fnf._filename_timestamp,
    mpf._fadd,
    mpf._fsadd,
    uidx._value as mjsid,
    uinf._value as lotname,
    mpf._reelid,
    mpf._partsname,
    -- fnf._filename_route,
    -- fnf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    -- ufd._pcb_serial,
    -- ufd._pcb_id,
    ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no,
    -- mpf._filename_id,
    mpf._blkcode,
    mpf._blkserial,
    mpf._usef,
    mpf._user,
    mpf._pickup,
    mpf._pmiss,
    mpf._rmiss,
    mpf._dmiss,
    mpf._mmiss,
    mpf._hmiss,
    mpf._trsmiss,
    mpf._mount,
    -- mpf._lname,
    -- mpf._tgserial,
    null as dummy
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
-- where
    -- ufd._output_no in ( 3, 4, 5 )
-- and
    -- mpf._blkserial <> ''
order by
    ufd._machine_order asc,
    ufd._lane_no asc,
    mpf._fadd asc,
    mpf._fsadd asc,
    fnf._filename_timestamp asc
;


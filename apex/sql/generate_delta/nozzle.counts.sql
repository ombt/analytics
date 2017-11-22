select
    fnf._filename_id,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    -- fnf._filename,
    -- fnf._filename_type,
    fnf._filename_timestamp,
    mpn._nhadd,
    mpn._ncadd,
    uidx._value as mjsid,
    uinf._value as lotname,
    -- fnf._filename_route,
    -- fnf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    -- ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no,
    -- mpn._filename_id,
    mpn._blkcode,
    mpn._blkserial,
    mpn._user,
    mpn._pickup,
    mpn._pmiss,
    mpn._rmiss,
    mpn._dmiss,
    mpn._mmiss,
    mpn._hmiss,
    mpn._trsmiss,
    mpn._mount,
    -- mpn._lname,
    -- mpn._tgserial,
    null as dummy
from
    u01.mountpickupnozzle mpn
inner join
    u01.filename_to_fid fnf
on
    fnf._filename_id = mpn._filename_id
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = mpn._filename_id
inner join
    u01.index uidx
on
    uidx._filename_id = mpn._filename_id
and
    uidx._name = 'MJSID'
inner join
    u01.information uinf
on
    uinf._filename_id = mpn._filename_id
and
    uinf._name = 'LotName'
-- where
    -- ufd._output_no in ( 3, 4, 5 )
-- and
    -- mpn._blkserial <> ''
order by
    ufd._machine_order asc,
    ufd._lane_no asc,
    mpn._nhadd asc,
    mpn._ncadd asc,
    fnf._filename_timestamp asc
;


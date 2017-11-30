select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    dpc._filename_id,
    dpc._pcb_id,
    dpc._pcb_serial,
    dpc._machine_order,
    dpc._lane_no,
    dpc._stage_no,
    dpc._timestamp,
    dpc._mjsid,
    dpc._lotname,
    dpc._output_no,
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

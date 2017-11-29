select
    ftf._filename,
    ftf._filename_type,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    pc._filename_id,
    pc._bndrcgstop,
    pc._bndstop,
    pc._board,
    pc._brcgstop,
    pc._bwait,
    pc._cderr,
    pc._cmerr,
    pc._cnvstop,
    pc._cperr,
    pc._crerr,
    pc._cterr,
    pc._cwait,
    pc._fbstop,
    pc._fwait,
    pc._jointpasswait,
    pc._judgestop,
    pc._lotboard,
    pc._lotmodule,
    pc._mcfwait,
    pc._mcrwait,
    pc._mhrcgstop,
    pc._module,
    pc._otherlstop,
    pc._othrstop,
    pc._pwait,
    pc._rwait,
    pc._scestop,
    pc._scstop,
    pc._swait,
    pc._tdispense,
    pc._tdmiss,
    pc._thmiss,
    pc._tmmiss,
    pc._tmount,
    pc._tpickup,
    pc._tpmiss,
    pc._tpriming,
    pc._trbl,
    pc._trmiss,
    pc._trserr,
    pc._trsmiss
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_count pc
on
    pc._filename_id = ftf._filename_id
order by
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;



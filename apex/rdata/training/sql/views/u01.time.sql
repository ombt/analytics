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
    dpt._filename_id,
    dpt._pcb_id,
    dpt._pcb_serial,
    dpt._machine_order,
    dpt._lane_no,
    dpt._stage_no,
    dpt._timestamp,
    dpt._mjsid,
    dpt._lotname,
    dpt._output_no,
    dpt._actual,
    dpt._bndrcgstop,
    dpt._bndstop,
    dpt._brcg,
    dpt._brcgstop,
    dpt._bwait,
    dpt._cderr,
    dpt._change,
    dpt._cmerr,
    dpt._cnvstop,
    dpt._cperr,
    dpt._crerr,
    dpt._cterr,
    dpt._cwait,
    dpt._dataedit,
    dpt._fbstop,
    dpt._fwait,
    dpt._idle,
    dpt._jointpasswait,
    dpt._judgestop,
    dpt._load,
    dpt._mcfwait,
    dpt._mcrwait,
    dpt._mente,
    dpt._mhrcgstop,
    dpt._mount,
    dpt._otherlstop,
    dpt._othrstop,
    dpt._poweron,
    dpt._prdstop,
    dpt._prod,
    dpt._prodview,
    dpt._pwait,
    dpt._rwait,
    dpt._scestop,
    dpt._scstop,
    dpt._swait,
    dpt._totalstop,
    dpt._trbl,
    dpt._trserr,
    dpt._unitadjust
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_pivot_time dpt
on
    dpt._filename_id = ftf._filename_id
and
    dpt._lane_no = ufd._lane_no
and
    dpt._stage_no = ufd._stage_no
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

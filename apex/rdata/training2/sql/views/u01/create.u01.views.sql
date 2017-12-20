
create view u01.count_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- dpc._filename_id,
    -- dpc._pcb_id,
    -- dpc._pcb_serial,
    -- dpc._machine_order,
    -- dpc._lane_no,
    -- dpc._stage_no,
    dpc._timestamp,
    dpc._mjsid,
    dpc._lotname,
    -- dpc._output_no,
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
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.time_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- dpt._filename_id,
    -- dpt._pcb_id,
    -- dpt._pcb_serial,
    -- dpt._machine_order,
    -- dpt._lane_no,
    -- dpt._stage_no,
    dpt._timestamp,
    dpt._mjsid,
    dpt._lotname,
    -- dpt._output_no,
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
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.feeder_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    df._fadd,
    df._fsadd,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- df._filename_id,
    -- df._pcb_id,
    -- df._pcb_serial,
    -- df._machine_order,
    -- df._lane_no,
    -- df._stage_no,
    df._timestamp,
    df._mjsid,
    df._lotname,
    df._reelid,
    df._partsname,
    -- df._output_no,
    df._blkserial,
    df._pickup,
    df._pmiss,
    df._rmiss,
    df._dmiss,
    df._mmiss,
    df._hmiss,
    df._trsmiss,
    df._mount
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_feeder df
on
    df._filename_id = ftf._filename_id
and
    df._lane_no = ufd._lane_no
and
    df._stage_no = ufd._stage_no
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp,
    -- df._fadd,
    -- df._fsadd
;

create view u01.nozzle_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- dn._filename_id,
    -- dn._pcb_id,
    -- dn._pcb_serial,
    -- dn._machine_order,
    -- dn._lane_no,
    -- dn._stage_no,
    dn._timestamp,
    dn._nhadd,
    dn._ncadd,
    dn._mjsid,
    dn._lotname,
    -- dn._output_no,
    dn._pickup,
    dn._pmiss,
    dn._rmiss,
    dn._dmiss,
    dn._mmiss,
    dn._hmiss,
    dn._trsmiss,
    dn._mount
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.delta_nozzle as dn
on
    dn._filename_id = ftf._filename_id
and
    dn._lane_no = ufd._lane_no
and
    dn._stage_no = ufd._stage_no
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp,
    -- dn._nhadd,
    -- dn._ncadd
;

create view u01.index_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upi._filename_id,
    upi._author,
    upi._authortype,
    upi._comment,
    upi._date as index_date,
    upi._diff,
    upi._format,
    upi._machine,
    upi._mjsid,
    upi._version
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_index upi
on
    upi._filename_id = ftf._filename_id
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.information_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upi._filename_id,
    upi._bcrstatus,
    upi._code,
    -- upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus
    -- upi._stage
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_information upi
on
    upi._filename_id = ftf._filename_id
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;

create view u01.index_information_view
as
select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
    -- upx._filename_id,
    upx._author,
    upx._authortype,
    upx._comment,
    upx._date as idx_date,
    upx._diff,
    upx._format,
    upx._machine,
    upx._mjsid,
    upx._version,
    -- upi._filename_id,
    upi._bcrstatus,
    upi._code,
    upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus,
    upi._stage
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u01.pivot_information upi
on
    upi._filename_id = ftf._filename_id
-- order by
    -- ftf._filename_route,
    -- ufd._machine_order,
    -- ufd._lane_no,
    -- ufd._stage_no,
    -- ftf._filename_timestamp
;


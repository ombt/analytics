
-- 
-- select
--     fnf._filename_id,
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
--     mpf._blkcode,
--     mpf._blkserial,
--     mpf._usef,
--     mpf._user,
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
-- -- where
--     -- ufd._output_no in ( 3, 4, 5 )
-- -- and
--     -- mpf._blkserial <> ''
-- order by
--     ufd._machine_order asc,
--     ufd._lane_no asc,
--     mpf._fadd asc,
--     mpf._fsadd asc,
--     fnf._filename_timestamp asc
-- ;
-- 

-- create table if not exists u01.pivot_count
-- (
--     _filename_id numeric(30,0),
--     _bndrcgstop numeric(10,3),
--     _bndstop numeric(10,3),
--     _board numeric(10,3),
--     _brcgstop numeric(10,3),
--     _bwait numeric(10,3),
--     _cderr numeric(10,3),
--     _cmerr numeric(10,3),
--     _cnvstop numeric(10,3),
--     _cperr numeric(10,3),
--     _crerr numeric(10,3),
--     _cterr numeric(10,3),
--     _cwait numeric(10,3),
--     _fbstop numeric(10,3),
--     _fwait numeric(10,3),
--     _jointpasswait numeric(10,3),
--     _judgestop numeric(10,3),
--     _lotboard numeric(10,3),
--     _lotmodule numeric(10,3),
--     _mcfwait numeric(10,3),
--     _mcrwait numeric(10,3),
--     _mhrcgstop numeric(10,3),
--     _module numeric(10,3),
--     _otherlstop numeric(10,3),
--     _othrstop numeric(10,3),
--     _pwait numeric(10,3),
--     _rwait numeric(10,3),
--     _scestop numeric(10,3),
--     _scstop numeric(10,3),
--     _swait numeric(10,3),
--     _tdispense numeric(10,3),
--     _tdmiss numeric(10,3),
--     _thmiss numeric(10,3),
--     _tmmiss numeric(10,3),
--     _tmount numeric(10,3),
--     _tpickup numeric(10,3),
--     _tpmiss numeric(10,3),
--     _tpriming numeric(10,3),
--     _trbl numeric(10,3),
--     _trmiss numeric(10,3),
--     _trserr numeric(10,3),
--     _trsmiss numeric(10,3)
-- ) ;

select
    fnf._filename_id,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    -- fnf._filename,
    -- fnf._filename_type,
    fnf._filename_timestamp,
    uidx._value as mjsid,
    uinf._value as lotname,
    -- fnf._filename_route,
    -- fnf._filename_id,
    -- ufd._filename_id,
    -- ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no,
    -- pc._filename_id,
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
    pc._trsmiss,
    null as dummy
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
    ufd._output_no in ( 3, 4 )
order by
    ufd._machine_order asc,
    ufd._lane_no asc,
    fnf._filename_timestamp asc
;

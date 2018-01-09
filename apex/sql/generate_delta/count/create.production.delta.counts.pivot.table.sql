-- 
-- create table if not exists u01.delta_pivot_time
-- (
--     _filename_id numeric(30,0),
--     _pcb_id text,
--     _pcb_serial text,
--     _machine_order integer,
--     _lane_no integer,
--     _stage_no integer,
--     _timestamp bigint,
--     _mjsid text,
--     _lotname text,
--     _output_no integer,
--     _actual numeric(10,3),
--     _bndrcgstop numeric(10,3),
--     _bndstop numeric(10,3),
--     _brcg numeric(10,3),
--     _brcgstop numeric(10,3),
--     _bwait numeric(10,3),
--     _cderr numeric(10,3),
--     _change numeric(10,3),
--     _cmerr numeric(10,3),
--     _cnvstop numeric(10,3),
--     _cperr numeric(10,3),
--     _crerr numeric(10,3),
--     _cterr numeric(10,3),
--     _cwait numeric(10,3),
--     _dataedit numeric(10,3),
--     _fbstop numeric(10,3),
--     _fwait numeric(10,3),
--     _idle numeric(10,3),
--     _jointpasswait numeric(10,3),
--     _judgestop numeric(10,3),
--     _load numeric(10,3),
--     _mcfwait numeric(10,3),
--     _mcrwait numeric(10,3),
--     _mente numeric(10,3),
--     _mhrcgstop numeric(10,3),
--     _mount numeric(10,3),
--     _otherlstop numeric(10,3),
--     _othrstop numeric(10,3),
--     _poweron numeric(10,3),
--     _prdstop numeric(10,3),
--     _prod numeric(10,3),
--     _prodview numeric(10,3),
--     _pwait numeric(10,3),
--     _rwait numeric(10,3),
--     _scestop numeric(10,3),
--     _scstop numeric(10,3),
--     _swait numeric(10,3),
--     _totalstop numeric(10,3),
--     _trbl numeric(10,3),
--     _trserr numeric(10,3),
--     _unitadjust numeric(10,3)
-- ) ;
-- 
-- create index if not exists idx_delta_pivot_time on u01.delta_pivot_time
-- (
--     _filename_id
-- ) ;
-- 
-- with prod_time_cte (
--     filename_id,
--     pcb_id,
--     pcb_serial,
--     machine_order,
--     lane_no,
--     stage_no,
--     timestamp,
--     mjsid,
--     lotname,
--     output_no,
--     actual,
--     bndrcgstop,
--     bndstop,
--     brcg,
--     brcgstop,
--     bwait,
--     cderr,
--     change,
--     cmerr,
--     cnvstop,
--     cperr,
--     crerr,
--     cterr,
--     cwait,
--     dataedit,
--     fbstop,
--     fwait,
--     idle,
--     jointpasswait,
--     judgestop,
--     load,
--     mcfwait,
--     mcrwait,
--     mente,
--     mhrcgstop,
--     mount,
--     otherlstop,
--     othrstop,
--     poweron,
--     prdstop,
--     prod,
--     prodview,
--     pwait,
--     rwait,
--     scestop,
--     scstop,
--     swait,
--     totalstop,
--     trbl,
--     trserr,
--     unitadjust,
--     row
-- ) as (
--     select
--         fnf._filename_id        as filename_id,
--         ufd._pcb_id             as pcb_id,
--         ufd._pcb_serial         as pcb_serial,
--         ufd._machine_order      as machine_order,
--         ufd._lane_no            as lane_no,
--         ufd._stage_no           as stage_no,
--         fnf._filename_timestamp as timestamp,
--         uidx._value             as mjsid,
--         uinf._value             as lotname,
--         ufd._output_no          as output_no,
--         pt._actual              as _actual,
--         pt._bndrcgstop          as bndrcgstop,
--         pt._bndstop             as bndstop,
--         pt._brcg                as brcg,
--         pt._brcgstop            as brcgstop,
--         pt._bwait               as bwait,
--         pt._cderr               as cderr,
--         pt._change              as change,
--         pt._cmerr               as cmerr,
--         pt._cnvstop             as cnvstop,
--         pt._cperr               as cperr,
--         pt._crerr               as crerr,
--         pt._cterr               as cterr,
--         pt._cwait               as cwait,
--         pt._dataedit            as dataedit,
--         pt._fbstop              as fbstop,
--         pt._fwait               as fwait,
--         pt._idle                as idle,
--         pt._jointpasswait       as jointpasswait,
--         pt._judgestop           as judgestop,
--         pt._load                as load,
--         pt._mcfwait             as mcfwait,
--         pt._mcrwait             as mcrwait,
--         pt._mente               as mente,
--         pt._mhrcgstop           as mhrcgstop,
--         pt._mount               as mount,
--         pt._otherlstop          as otherlstop,
--         pt._othrstop            as othrstop,
--         pt._poweron             as poweron,
--         pt._prdstop             as prdstop,
--         pt._prod                as prod,
--         pt._prodview            as prodview,
--         pt._pwait               as pwait,
--         pt._rwait               as rwait,
--         pt._scestop             as scestop,
--         pt._scstop              as scstop,
--         pt._swait               as swait,
--         pt._totalstop           as totalstop,
--         pt._trbl                as trbl,
--         pt._trserr              as trserr,
--         pt._unitadjust          as unitadjust,
--         row_number() over (
--             partition by
--                 ufd._machine_order,
--                 ufd._lane_no,
--                 ufd._stage_no,
--                 uidx._value,
--                 uinf._value
--             order by
--                 ufd._machine_order,
--                 ufd._lane_no,
--                 ufd._stage_no,
--                 fnf._filename_timestamp
--         ) as row
--     from
--         u01.pivot_time pt
--     inner join
--         u01.filename_to_fid fnf
--     on
--         fnf._filename_id = pt._filename_id
--     inner join
--         u01.u0x_filename_data ufd
--     on
--         ufd._filename_id = pt._filename_id
--     inner join
--         u01.index uidx
--     on
--         uidx._filename_id = pt._filename_id
--     and
--         uidx._name = 'MJSID'
--     inner join
--         u01.information uinf
--     on
--         uinf._filename_id = pt._filename_id
--     and
--         uinf._name = 'LotName'
--     where
--         ufd._output_no in ( 3, 4, 5 )
-- ) 
-- insert into u01.delta_pivot_time
-- (
--     _filename_id,
--     _pcb_id,
--     _pcb_serial,
--     _machine_order,
--     _lane_no,
--     _stage_no,
--     _timestamp,
--     _mjsid,
--     _lotname,
--     _output_no,
--     _actual,
--     _bndrcgstop,
--     _bndstop,
--     _brcg,
--     _brcgstop,
--     _bwait,
--     _cderr,
--     _change,
--     _cmerr,
--     _cnvstop,
--     _cperr,
--     _crerr,
--     _cterr,
--     _cwait,
--     _dataedit,
--     _fbstop,
--     _fwait,
--     _idle,
--     _jointpasswait,
--     _judgestop,
--     _load,
--     _mcfwait,
--     _mcrwait,
--     _mente,
--     _mhrcgstop,
--     _mount,
--     _otherlstop,
--     _othrstop,
--     _poweron,
--     _prdstop,
--     _prod,
--     _prodview,
--     _pwait,
--     _rwait,
--     _scestop,
--     _scstop,
--     _swait,
--     _totalstop,
--     _trbl,
--     _trserr,
--     _unitadjust
-- )
-- select
--     curr.filename_id as filename_id,
--     curr.pcb_id as pcb_id,
--     curr.pcb_serial as pcb_serial,
--     curr.machine_order as machine_order,
--     curr.lane_no as lane_no,
--     curr.stage_no as stage_no,
--     curr.timestamp as timestamp,
--     curr.mjsid as mjsid,
--     curr.lotname as lotname,
--     curr.output_no as output_no,
--     curr.actual - prev.actual as actual,
--     curr.bndrcgstop - prev.bndrcgstop as bndrcgstop,
--     curr.bndstop - prev.bndstop as bndstop,
--     curr.brcg - prev.brcg as brcg,
--     curr.brcgstop - prev.brcgstop as brcgstop,
--     curr.bwait - prev.bwait as bwait,
--     curr.cderr - prev.cderr as cderr,
--     curr.change - prev.change as change,
--     curr.cmerr - prev.cmerr as cmerr,
--     curr.cnvstop - prev.cnvstop as cnvstop,
--     curr.cperr - prev.cperr as cperr,
--     curr.crerr - prev.crerr as crerr,
--     curr.cterr - prev.cterr as cterr,
--     curr.cwait - prev.cwait as cwait,
--     curr.dataedit - prev.dataedit as dataedit,
--     curr.fbstop - prev.fbstop as fbstop,
--     curr.fwait - prev.fwait as fwait,
--     curr.idle - prev.idle as idle,
--     curr.jointpasswait - prev.jointpasswait as jointpasswait,
--     curr.judgestop - prev.judgestop as judgestop,
--     curr.load - prev.load as load,
--     curr.mcfwait - prev.mcfwait as mcfwait,
--     curr.mcrwait - prev.mcrwait as mcrwait,
--     curr.mente - prev.mente as mente,
--     curr.mhrcgstop - prev.mhrcgstop as mhrcgstop,
--     curr.mount - prev.mount as mount,
--     curr.otherlstop - prev.otherlstop as otherlstop,
--     curr.othrstop - prev.othrstop as othrstop,
--     curr.poweron - prev.poweron as poweron,
--     curr.prdstop - prev.prdstop as prdstop,
--     curr.prod - prev.prod as prod,
--     curr.prodview - prev.prodview as prodview,
--     curr.pwait - prev.pwait as pwait,
--     curr.rwait - prev.rwait as rwait,
--     curr.scestop - prev.scestop as scestop,
--     curr.scstop - prev.scstop as scstop,
--     curr.swait - prev.swait as swait,
--     curr.totalstop - prev.totalstop as totalstop,
--     curr.trbl - prev.trbl as trbl,
--     curr.trserr - prev.trserr as trserr,
--     curr.unitadjust - prev.unitadjust as unitadjust
-- from 
--     prod_time_cte curr
-- inner join
--     prod_time_cte prev
-- on
--     curr.row = prev.row + 1
-- and
--     curr.machine_order = prev.machine_order
-- and
--     curr.lane_no = prev.lane_no
-- and
--     curr.stage_no = prev.stage_no
-- and
--     curr.mjsid = prev.mjsid
-- and
--     curr.lotname = prev.lotname
-- order by
--     machine_order asc,
--     lane_no asc,
--     timestamp asc
-- ;
-- 

create or replace function
get_delta
(
    curr numeric(10,3),
    prev numeric(10,3)
)
returns numeric(10,3) as $$
begin
    if (curr > prev)
    then
        return (curr - prev);
    elseif (curr < prev)
    then
        return (curr);
    else
        return (0);
    end if;
end;
$$ language plpgsql;

create table if not exists u01.delta_pivot_count
(
    _filename_id numeric(30,0),
    _pcb_id text,
    _pcb_serial text,
    _machine_order integer,
    _lane_no integer,
    _stage_no integer,
    _timestamp bigint,
    _mjsid text,
    _lotname text,
    _output_no integer,
    _bndrcgstop numeric(10,3),
    _bndstop numeric(10,3),
    _board numeric(10,3),
    _brcgstop numeric(10,3),
    _bwait numeric(10,3),
    _cderr numeric(10,3),
    _cmerr numeric(10,3),
    _cnvstop numeric(10,3),
    _cperr numeric(10,3),
    _crerr numeric(10,3),
    _cterr numeric(10,3),
    _cwait numeric(10,3),
    _fbstop numeric(10,3),
    _fwait numeric(10,3),
    _jointpasswait numeric(10,3),
    _judgestop numeric(10,3),
    _lotboard numeric(10,3),
    _lotmodule numeric(10,3),
    _mcfwait numeric(10,3),
    _mcrwait numeric(10,3),
    _mhrcgstop numeric(10,3),
    _module numeric(10,3),
    _otherlstop numeric(10,3),
    _othrstop numeric(10,3),
    _pwait numeric(10,3),
    _rwait numeric(10,3),
    _scestop numeric(10,3),
    _scstop numeric(10,3),
    _swait numeric(10,3),
    _tdispense numeric(10,3),
    _tdmiss numeric(10,3),
    _thmiss numeric(10,3),
    _tmmiss numeric(10,3),
    _tmount numeric(10,3),
    _tpickup numeric(10,3),
    _tpmiss numeric(10,3),
    _tpriming numeric(10,3),
    _trbl numeric(10,3),
    _trmiss numeric(10,3),
    _trserr numeric(10,3),
    _trsmiss numeric(10,3)
) ;

create index if not exists idx_delta_pivot_count on u01.delta_pivot_count
(
    _filename_id
) ;

with prod_count_cte (
    filename_id,
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
        fnf._filename_id        as filename_id,
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
) 
insert into u01.delta_pivot_count
(
    _filename_id,
    _pcb_id,
    _pcb_serial,
    _machine_order,
    _lane_no,
    _stage_no,
    _timestamp,
    _mjsid,
    _lotname,
    _output_no,
    _bndrcgstop,
    _bndstop,
    _board,
    _brcgstop,
    _bwait,
    _cderr,
    _cmerr,
    _cnvstop,
    _cperr,
    _crerr,
    _cterr,
    _cwait,
    _fbstop,
    _fwait,
    _jointpasswait,
    _judgestop,
    _lotboard,
    _lotmodule,
    _mcfwait,
    _mcrwait,
    _mhrcgstop,
    _module,
    _otherlstop,
    _othrstop,
    _pwait,
    _rwait,
    _scestop,
    _scstop,
    _swait,
    _tdispense,
    _tdmiss,
    _thmiss,
    _tmmiss,
    _tmount,
    _tpickup,
    _tpmiss,
    _tpriming,
    _trbl,
    _trmiss,
    _trserr,
    _trsmiss
)
select
    curr.filename_id as filename_id,
    curr.pcb_id as pcb_id,
    curr.pcb_serial as pcb_serial,
    curr.machine_order as machine_order,
    curr.lane_no as lane_no,
    curr.stage_no as stage_no,
    curr.timestamp as timestamp,
    curr.mjsid as mjsid,
    curr.lotname as lotname,
    curr.output_no as output_no,

    get_delta(curr.bndrcgstop,
              prev.bndrcgstop) as bndrcgstop,
    get_delta(curr.bndstop,
              prev.bndstop) as bndstop,
    get_delta(curr.board,
              prev.board) as board,
    get_delta(curr.brcgstop,
              prev.brcgstop) as brcgstop,
    get_delta(curr.bwait,
              prev.bwait) as bwait,
    get_delta(curr.cderr,
              prev.cderr) as cderr,
    get_delta(curr.cmerr,
              prev.cmerr) as cmerr,
    get_delta(curr.cnvstop,
              prev.cnvstop) as cnvstop,
    get_delta(curr.cperr,
              prev.cperr) as cperr,
    get_delta(curr.crerr,
              prev.crerr) as crerr,
    get_delta(curr.cterr,
              prev.cterr) as cterr,
    get_delta(curr.cwait,
              prev.cwait) as cwait,
    get_delta(curr.fbstop,
              prev.fbstop) as fbstop,
    get_delta(curr.fwait,
              prev.fwait) as fwait,
    get_delta(curr.jointpasswait,
              prev.jointpasswait) as jointpasswait,
    get_delta(curr.judgestop,
              prev.judgestop) as judgestop,
    get_delta(curr.lotboard,
              prev.lotboard) as lotboard,
    get_delta(curr.lotmodule,
              prev.lotmodule) as lotmodule,
    get_delta(curr.mcfwait,
              prev.mcfwait) as mcfwait,
    get_delta(curr.mcrwait,
              prev.mcrwait) as mcrwait,
    get_delta(curr.mhrcgstop,
              prev.mhrcgstop) as mhrcgstop,
    get_delta(curr.module,
              prev.module) as module,
    get_delta(curr.otherlstop,
              prev.otherlstop) as otherlstop,
    get_delta(curr.othrstop,
              prev.othrstop) as othrstop,
    get_delta(curr.pwait,
              prev.pwait) as pwait,
    get_delta(curr.rwait,
              prev.rwait) as rwait,
    get_delta(curr.scestop,
              prev.scestop) as scestop,
    get_delta(curr.scstop,
              prev.scstop) as scstop,
    get_delta(curr.swait,
              prev.swait) as swait,
    get_delta(curr.tdispense,
              prev.tdispense) as tdispense,
    get_delta(curr.tdmiss,
              prev.tdmiss) as tdmiss,
    get_delta(curr.thmiss,
              prev.thmiss) as thmiss,
    get_delta(curr.tmmiss,
              prev.tmmiss) as tmmiss,
    get_delta(curr.tmount,
              prev.tmount) as tmount,
    get_delta(curr.tpickup,
              prev.tpickup) as tpickup,
    get_delta(curr.tpmiss,
              prev.tpmiss) as tpmiss,
    get_delta(curr.tpriming,
              prev.tpriming) as tpriming,
    get_delta(curr.trbl,
              prev.trbl) as trbl,
    get_delta(curr.trmiss,
              prev.trmiss) as trmiss,
    get_delta(curr.trserr,
              prev.trserr) as trserr,
    get_delta(curr.trsmiss,
              prev.trsmiss) as trsmiss

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

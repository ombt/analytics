
create table if not exists u01.delta_pivot_time
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
    _actual numeric(10,3),
    _bndrcgstop numeric(10,3),
    _bndstop numeric(10,3),
    _brcg numeric(10,3),
    _brcgstop numeric(10,3),
    _bwait numeric(10,3),
    _cderr numeric(10,3),
    _change numeric(10,3),
    _cmerr numeric(10,3),
    _cnvstop numeric(10,3),
    _cperr numeric(10,3),
    _crerr numeric(10,3),
    _cterr numeric(10,3),
    _cwait numeric(10,3),
    _dataedit numeric(10,3),
    _fbstop numeric(10,3),
    _fwait numeric(10,3),
    _idle numeric(10,3),
    _jointpasswait numeric(10,3),
    _judgestop numeric(10,3),
    _load numeric(10,3),
    _mcfwait numeric(10,3),
    _mcrwait numeric(10,3),
    _mente numeric(10,3),
    _mhrcgstop numeric(10,3),
    _mount numeric(10,3),
    _otherlstop numeric(10,3),
    _othrstop numeric(10,3),
    _poweron numeric(10,3),
    _prdstop numeric(10,3),
    _prod numeric(10,3),
    _prodview numeric(10,3),
    _pwait numeric(10,3),
    _rwait numeric(10,3),
    _scestop numeric(10,3),
    _scstop numeric(10,3),
    _swait numeric(10,3),
    _totalstop numeric(10,3),
    _trbl numeric(10,3),
    _trserr numeric(10,3),
    _unitadjust numeric(10,3)
) ;

create index if not exists idx_delta_pivot_time on u01.delta_pivot_time
(
    _filename_id
) ;

with prod_time_cte (
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
    actual,
    bndrcgstop,
    bndstop,
    brcg,
    brcgstop,
    bwait,
    cderr,
    change,
    cmerr,
    cnvstop,
    cperr,
    crerr,
    cterr,
    cwait,
    dataedit,
    fbstop,
    fwait,
    idle,
    jointpasswait,
    judgestop,
    load,
    mcfwait,
    mcrwait,
    mente,
    mhrcgstop,
    mount,
    otherlstop,
    othrstop,
    poweron,
    prdstop,
    prod,
    prodview,
    pwait,
    rwait,
    scestop,
    scstop,
    swait,
    totalstop,
    trbl,
    trserr,
    unitadjust,
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
        pt._actual              as _actual,
        pt._bndrcgstop          as bndrcgstop,
        pt._bndstop             as bndstop,
        pt._brcg                as brcg,
        pt._brcgstop            as brcgstop,
        pt._bwait               as bwait,
        pt._cderr               as cderr,
        pt._change              as change,
        pt._cmerr               as cmerr,
        pt._cnvstop             as cnvstop,
        pt._cperr               as cperr,
        pt._crerr               as crerr,
        pt._cterr               as cterr,
        pt._cwait               as cwait,
        pt._dataedit            as dataedit,
        pt._fbstop              as fbstop,
        pt._fwait               as fwait,
        pt._idle                as idle,
        pt._jointpasswait       as jointpasswait,
        pt._judgestop           as judgestop,
        pt._load                as load,
        pt._mcfwait             as mcfwait,
        pt._mcrwait             as mcrwait,
        pt._mente               as mente,
        pt._mhrcgstop           as mhrcgstop,
        pt._mount               as mount,
        pt._otherlstop          as otherlstop,
        pt._othrstop            as othrstop,
        pt._poweron             as poweron,
        pt._prdstop             as prdstop,
        pt._prod                as prod,
        pt._prodview            as prodview,
        pt._pwait               as pwait,
        pt._rwait               as rwait,
        pt._scestop             as scestop,
        pt._scstop              as scstop,
        pt._swait               as swait,
        pt._totalstop           as totalstop,
        pt._trbl                as trbl,
        pt._trserr              as trserr,
        pt._unitadjust          as unitadjust,
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
        u01.pivot_time pt
    inner join
        u01.filename_to_fid fnf
    on
        fnf._filename_id = pt._filename_id
    inner join
        u01.u0x_filename_data ufd
    on
        ufd._filename_id = pt._filename_id
    inner join
        u01.index uidx
    on
        uidx._filename_id = pt._filename_id
    and
        uidx._name = 'MJSID'
    inner join
        u01.information uinf
    on
        uinf._filename_id = pt._filename_id
    and
        uinf._name = 'LotName'
    where
        ufd._output_no in ( 3, 4, 5 )
) 
insert into u01.delta_pivot_time
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
    _actual,
    _bndrcgstop,
    _bndstop,
    _brcg,
    _brcgstop,
    _bwait,
    _cderr,
    _change,
    _cmerr,
    _cnvstop,
    _cperr,
    _crerr,
    _cterr,
    _cwait,
    _dataedit,
    _fbstop,
    _fwait,
    _idle,
    _jointpasswait,
    _judgestop,
    _load,
    _mcfwait,
    _mcrwait,
    _mente,
    _mhrcgstop,
    _mount,
    _otherlstop,
    _othrstop,
    _poweron,
    _prdstop,
    _prod,
    _prodview,
    _pwait,
    _rwait,
    _scestop,
    _scstop,
    _swait,
    _totalstop,
    _trbl,
    _trserr,
    _unitadjust
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
    curr.actual - prev.actual as actual,
    curr.bndrcgstop - prev.bndrcgstop as bndrcgstop,
    curr.bndstop - prev.bndstop as bndstop,
    curr.brcg - prev.brcg as brcg,
    curr.brcgstop - prev.brcgstop as brcgstop,
    curr.bwait - prev.bwait as bwait,
    curr.cderr - prev.cderr as cderr,
    curr.change - prev.change as change,
    curr.cmerr - prev.cmerr as cmerr,
    curr.cnvstop - prev.cnvstop as cnvstop,
    curr.cperr - prev.cperr as cperr,
    curr.crerr - prev.crerr as crerr,
    curr.cterr - prev.cterr as cterr,
    curr.cwait - prev.cwait as cwait,
    curr.dataedit - prev.dataedit as dataedit,
    curr.fbstop - prev.fbstop as fbstop,
    curr.fwait - prev.fwait as fwait,
    curr.idle - prev.idle as idle,
    curr.jointpasswait - prev.jointpasswait as jointpasswait,
    curr.judgestop - prev.judgestop as judgestop,
    curr.load - prev.load as load,
    curr.mcfwait - prev.mcfwait as mcfwait,
    curr.mcrwait - prev.mcrwait as mcrwait,
    curr.mente - prev.mente as mente,
    curr.mhrcgstop - prev.mhrcgstop as mhrcgstop,
    curr.mount - prev.mount as mount,
    curr.otherlstop - prev.otherlstop as otherlstop,
    curr.othrstop - prev.othrstop as othrstop,
    curr.poweron - prev.poweron as poweron,
    curr.prdstop - prev.prdstop as prdstop,
    curr.prod - prev.prod as prod,
    curr.prodview - prev.prodview as prodview,
    curr.pwait - prev.pwait as pwait,
    curr.rwait - prev.rwait as rwait,
    curr.scestop - prev.scestop as scestop,
    curr.scstop - prev.scstop as scstop,
    curr.swait - prev.swait as swait,
    curr.totalstop - prev.totalstop as totalstop,
    curr.trbl - prev.trbl as trbl,
    curr.trserr - prev.trserr as trserr,
    curr.unitadjust - prev.unitadjust as unitadjust
from 
    prod_time_cte curr
inner join
    prod_time_cte prev
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


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
    mcfwait,
    mcrwait,
    mhrcgstop,
    otherlstop,
    othrstop,
    pwait,
    rwait,
    scestop,
    scstop,
    swait,
    trbl,
    trserr,
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
        pt._brcgstop            as brcgstop,
        pt._bwait               as bwait,
        pt._cderr               as cderr,
        pt._cmerr               as cmerr,
        pt._cnvstop             as cnvstop,
        pt._cperr               as cperr,
        pt._crerr               as crerr,
        pt._cterr               as cterr,
        pt._cwait               as cwait,
        pt._fbstop              as fbstop,
        pt._fwait               as fwait,
        pt._jointpasswait       as jointpasswait,
        pt._judgestop           as judgestop,
        pt._mcfwait             as mcfwait,
        pt._mcrwait             as mcrwait,
        pt._mhrcgstop           as mhrcgstop,
        pt._otherlstop          as otherlstop,
        pt._othrstop            as othrstop,
        pt._pwait               as pwait,
        pt._rwait               as rwait,
        pt._scestop             as scestop,
        pt._scstop              as scstop,
        pt._swait               as swait,
        pt._trbl                as trbl,
        pt._trserr              as trserr,
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
) select
    curr.filename_id as filename_id,
    curr.pcb_id as pcb_id,
    curr.pcb_serial as pcb_serial,
    curr.machine_order as machine_order,
    curr.lane_no as lane_no,
    curr.stage_no as stage_no,
    curr.timestamp as timestamp,
    curr.mjsid as mjsid,
    curr.lotname as lotname,
    curr.actual - prev.actual as actual,
    curr.bndrcgstop - prev.bndrcgstop as bndrcgstop,
    curr.bndstop - prev.bndstop as bndstop,
    curr.brcgstop - prev.brcgstop as brcgstop,
    curr.bwait - prev.bwait as bwait,
    curr.cderr - prev.cderr as cderr,
    curr.cmerr - prev.cmerr as cmerr,
    curr.cnvstop - prev.cnvstop as cnvstop,
    curr.cperr - prev.cperr as cperr,
    curr.crerr - prev.crerr as crerr,
    curr.cterr - prev.cterr as cterr,
    curr.cwait - prev.cwait as cwait,
    curr.fbstop - prev.fbstop as fbstop,
    curr.fwait - prev.fwait as fwait,
    curr.jointpasswait - prev.jointpasswait as jointpasswait,
    curr.judgestop - prev.judgestop as judgestop,
    curr.mcfwait - prev.mcfwait as mcfwait,
    curr.mcrwait - prev.mcrwait as mcrwait,
    curr.mhrcgstop - prev.mhrcgstop as mhrcgstop,
    curr.otherlstop - prev.otherlstop as otherlstop,
    curr.othrstop - prev.othrstop as othrstop,
    curr.pwait - prev.pwait as pwait,
    curr.rwait - prev.rwait as rwait,
    curr.scestop - prev.scestop as scestop,
    curr.scstop - prev.scstop as scstop,
    curr.swait - prev.swait as swait,
    curr.trbl - prev.trbl as trbl,
    curr.trserr - prev.trserr as trserr
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


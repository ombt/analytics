
with prod_time_cte (
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
        pc._mcfwait             as mcfwait,
        pc._mcrwait             as mcrwait,
        pc._mhrcgstop           as mhrcgstop,
        pc._otherlstop          as otherlstop,
        pc._othrstop            as othrstop,
        pc._pwait               as pwait,
        pc._rwait               as rwait,
        pc._scestop             as scestop,
        pc._scstop              as scstop,
        pc._swait               as swait,
        pc._trbl                as trbl,
        pc._trserr              as trserr,
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
        u01.pivot_time pc
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
) select
    curr.pcb_id as pcb_id,
    curr.pcb_serial as pcb_serial,
    curr.machine_order as machine_order,
    curr.lane_no as lane_no,
    curr.stage_no as stage_no,
    curr.timestamp as timestamp,
    curr.mjsid as mjsid,
    curr.lotname as lotname,
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


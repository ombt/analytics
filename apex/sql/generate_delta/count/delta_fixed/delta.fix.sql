-- create a delta function.

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
select
    curr.filename_id                        as curr_filename_id,
    curr.pcb_id                             as curr_pcb_id,
    curr.pcb_serial                         as curr_pcb_serial,
    curr.machine_order                      as curr_machine_order,
    curr.lane_no                            as curr_lane_no,
    curr.stage_no                           as curr_stage_no,
    curr.timestamp                          as curr_timestamp,
    curr.mjsid                              as curr_mjsid,
    curr.lotname                            as curr_lotname,
    curr.output_no                          as curr_output_no,
    curr.row                                as curr_row,

    prev.filename_id                        as prev_filename_id,
    prev.pcb_id                             as prev_pcb_id,
    prev.pcb_serial                         as prev_pcb_serial,
    prev.machine_order                      as prev_machine_order,
    prev.lane_no                            as prev_lane_no,
    prev.stage_no                           as prev_stage_no,
    prev.timestamp                          as prev_timestamp,
    prev.mjsid                              as prev_mjsid,
    prev.lotname                            as prev_lotname,
    prev.output_no                          as prev_output_no,
    prev.row                                as prev_row,

    curr.board as curr_board,
    prev.board as prev_board,
    curr.board - prev.board                 as board,
    get_delta(curr.board, prev.board) as fixed_board,

    curr.lotboard as curr_lotboard,
    prev.lotboard as prev_lotboard,
    curr.lotboard - prev.lotboard           as lotboard,
    get_delta(curr.lotboard, prev.lotboard) as fixed_lotboard,

    curr.lotmodule as curr_lotmodule,
    prev.lotmodule as prev_lotmodule,
    curr.lotmodule - prev.lotmodule         as lotmodule,
    get_delta(curr.lotmodule, prev.lotmodule) as fixed_lotmodule,

    curr.tmount as curr_tmount,
    prev.tmount as prev_tmount,
    curr.tmount - prev.tmount               as tmount,
    get_delta(curr.tmount, prev.tmount) as fixed_tmount,

    curr.tpickup as curr_tpickup,
    prev.tpickup as prev_tpickup,
    curr.tpickup - prev.tpickup             as tpickup,
    get_delta(curr.tpickup, prev.tpickup) as fixed_tpickup,

    curr.tpmiss as curr_tpmiss,
    prev.tpmiss as prev_tpmiss,
    curr.tpmiss - prev.tpmiss               as tpmiss,
    get_delta(curr.tpmiss, prev.tpmiss) as fixed_tpmiss,

    curr.trmiss as curr_trmiss,
    prev.trmiss as prev_trmiss,
    curr.trmiss - prev.trmiss               as trmiss,
    get_delta(curr.trmiss, prev.trmiss) as fixed_trmiss,

    curr.trserr as curr_trserr,
    prev.trserr as prev_trserr,
    curr.trserr - prev.trserr               as trserr,
    get_delta(curr.trserr, prev.trserr) as fixed_trserr,

    curr.trsmiss as curr_trsmiss,
    prev.trsmiss as prev_trsmiss,
    curr.trsmiss - prev.trsmiss             as trsmiss,
    get_delta(curr.trsmiss, prev.trsmiss) as fixed_trsmiss

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
    curr.machine_order asc,
    curr.lane_no asc,
    curr.timestamp asc
;

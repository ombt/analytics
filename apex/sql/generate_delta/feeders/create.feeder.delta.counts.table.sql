
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

create table if not exists u01.delta_feeder
(
    _filename_id   numeric(30),
    _pcb_id        text,
    _pcb_serial    text,
    _machine_order integer,
    _lane_no       integer,
    _stage_no      integer,
    _timestamp     bigint,
    _fadd          integer,
    _fsadd         integer,
    _mjsid         text,
    _lotname       text,
    _reelid        text,
    _partsname     text,
    _output_no     integer,
    _blkserial     text,
    _pickup        integer,
    _pmiss         integer,
    _rmiss         integer,
    _dmiss         integer,
    _mmiss         integer,
    _hmiss         integer,
    _trsmiss       integer,
    _mount         integer
) ;

create index if not exists idx_delta_feeder on u01.delta_feeder
(
    _filename_id
) ;

with feeder_cte (
    filename_id,
    pcb_id,
    pcb_serial,
    machine_order,
    lane_no,
    stage_no,
    timestamp,
    fadd,
    fsadd,
    mjsid,
    lotname,
    reelid,
    partsname,
    output_no,
    blkserial,
    pickup,
    pmiss,
    rmiss,
    dmiss,
    mmiss,
    hmiss,
    trsmiss,
    mount,
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
        mpf._fadd               as fadd,
        mpf._fsadd              as fsadd,
        uidx._value             as mjsid,
        uinf._value             as lotname,
        mpf._reelid             as reelid,
        mpf._partsname          as partsname,
        ufd._output_no          as output_no,
        mpf._blkserial          as blkserial,
        mpf._pickup             as pickup,
        mpf._pmiss              as pmiss,
        mpf._rmiss              as rmiss,
        mpf._dmiss              as dmiss,
        mpf._mmiss              as mmiss,
        mpf._hmiss              as hmiss,
        mpf._trsmiss            as trsmiss,
        mpf._mount              as mount,
        row_number() over (
            partition by
                ufd._machine_order,
                ufd._lane_no,
                ufd._stage_no,
                mpf._fadd,
                mpf._fsadd,
                uidx._value,
                uinf._value,
                mpf._reelid,
                mpf._partsname,
                mpf._blkserial
            order by
                ufd._machine_order,
                ufd._lane_no,
                ufd._stage_no,
                mpf._fadd,
                mpf._fsadd,
                fnf._filename_timestamp
        ) as row
    from
        u01.mountpickupfeeder mpf
    inner join
        u01.filename_to_fid fnf
    on
        fnf._filename_id = mpf._filename_id
    inner join
        u01.u0x_filename_data ufd
    on
        ufd._filename_id = mpf._filename_id
    inner join
        u01.index uidx
    on
        uidx._filename_id = mpf._filename_id
    and
        uidx._name = 'MJSID'
    inner join
        u01.information uinf
    on
        uinf._filename_id = mpf._filename_id
    and
        uinf._name = 'LotName'
    where
        ufd._output_no in ( 3, 4, 5 )
) 
insert into u01.delta_feeder
(
    _filename_id,
    _pcb_id,
    _pcb_serial,
    _machine_order,
    _lane_no,
    _stage_no,
    _timestamp,
    _fadd,
    _fsadd,
    _mjsid,
    _lotname,
    _reelid,
    _partsname,
    _blkserial,
    _output_no,
    _pickup,
    _pmiss,
    _rmiss,
    _dmiss,
    _mmiss,
    _hmiss,
    _trsmiss,
    _mount
)
select
    curr.filename_id,
    curr.pcb_id,
    curr.pcb_serial,
    curr.machine_order,
    curr.lane_no,
    curr.stage_no,
    curr.timestamp,
    curr.fadd,
    curr.fsadd,
    curr.mjsid,
    curr.lotname,
    curr.reelid,
    curr.partsname,
    curr.blkserial,
    curr.output_no,
    get_delta(curr.pickup, prev.pickup),
    get_delta(curr.pmiss, prev.pmiss),
    get_delta(curr.rmiss, prev.rmiss),
    get_delta(curr.dmiss, prev.dmiss),
    get_delta(curr.mmiss, prev.mmiss),
    get_delta(curr.hmiss, prev.hmiss),
    get_delta(curr.trsmiss, prev.trsmiss),
    get_delta(curr.mount, prev.mount)
from 
    feeder_cte curr
inner join
    feeder_cte prev
on
    curr.row = prev.row + 1
and
    curr.machine_order = prev.machine_order
and
    curr.lane_no = prev.lane_no
and
    curr.stage_no = prev.stage_no
and
    curr.fadd = prev.fadd
and
    curr.fsadd = prev.fsadd
and
    curr.mjsid = prev.mjsid
and
    curr.lotname = prev.lotname
and
    curr.reelid = prev.reelid
and
    curr.partsname = prev.partsname
and
    curr.blkserial = prev.blkserial
order by
    machine_order asc,
    lane_no asc,
    timestamp asc,
    fadd asc,
    fsadd asc
;


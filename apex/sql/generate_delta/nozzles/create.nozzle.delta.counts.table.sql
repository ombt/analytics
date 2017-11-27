
create table if not exists u01.delta_nozzle
(
    _filename_id   numeric(30),
    _pcb_id        text,
    _pcb_serial    text,
    _machine_order integer,
    _lane_no       integer,
    _stage_no      integer,
    _timestamp     bigint,
    _nhadd         integer,
    _ncadd         integer,
    _mjsid         text,
    _lotname       text,
    _output_no     integer,
    -- _blkserial     text,
    _pickup        integer,
    _pmiss         integer,
    _rmiss         integer,
    _dmiss         integer,
    _mmiss         integer,
    _hmiss         integer,
    _trsmiss       integer,
    _mount         integer
) ;

create index if not exists idx_delta_nozzle on u01.delta_nozzle
(
    _filename_id
) ;

with nozzle_cte (
    filename_id,
    pcb_id,
    pcb_serial,
    machine_order,
    lane_no,
    stage_no,
    timestamp,
    nhadd,
    ncadd,
    mjsid,
    lotname,
    output_no,
    -- blkserial,
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
        mpn._nhadd              as nhadd,
        mpn._ncadd              as ncadd,
        uidx._value             as mjsid,
        uinf._value             as lotname,
        ufd._output_no          as output_no,
        -- mpn._blkserial          as blkserial,
        mpn._pickup             as pickup,
        mpn._pmiss              as pmiss,
        mpn._rmiss              as rmiss,
        mpn._dmiss              as dmiss,
        mpn._mmiss              as mmiss,
        mpn._hmiss              as hmiss,
        mpn._trsmiss            as trsmiss,
        mpn._mount              as mount,
        row_number() over (
            partition by
                ufd._machine_order,
                ufd._lane_no,
                ufd._stage_no,
                mpn._nhadd,
                mpn._ncadd,
                uidx._value,
                uinf._value
                -- mpn._blkserial
            order by
                ufd._machine_order,
                ufd._lane_no,
                ufd._stage_no,
                mpn._nhadd,
                mpn._ncadd,
                fnf._filename_timestamp
        ) as row
    from
        u01.mountpickupnozzle mpn
    inner join
        u01.filename_to_fid fnf
    on
        fnf._filename_id = mpn._filename_id
    inner join
        u01.u0x_filename_data ufd
    on
        ufd._filename_id = mpn._filename_id
    inner join
        u01.index uidx
    on
        uidx._filename_id = mpn._filename_id
    and
        uidx._name = 'MJSID'
    inner join
        u01.information uinf
    on
        uinf._filename_id = mpn._filename_id
    and
        uinf._name = 'LotName'
    where
        ufd._output_no in ( 3, 4, 5 )
) 
insert into u01.delta_nozzle
(
    _filename_id,
    _pcb_id,
    _pcb_serial,
    _machine_order,
    _lane_no,
    _stage_no,
    _timestamp,
    _nhadd,
    _ncadd,
    _mjsid,
    _lotname,
    -- _blkserial,
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
    curr.nhadd,
    curr.ncadd,
    curr.mjsid,
    curr.lotname,
    -- curr.blkserial,
    curr.output_no,
    curr.pickup - prev.pickup,
    curr.pmiss - prev.pmiss,
    curr.rmiss - prev.rmiss,
    curr.dmiss - prev.dmiss,
    curr.mmiss - prev.mmiss,
    curr.hmiss - prev.hmiss,
    curr.trsmiss - prev.trsmiss,
    curr.mount - prev.mount
from 
    nozzle_cte curr
inner join
    nozzle_cte prev
on
    curr.row = prev.row + 1
and
    curr.machine_order = prev.machine_order
and
    curr.lane_no = prev.lane_no
and
    curr.stage_no = prev.stage_no
and
    curr.nhadd = prev.nhadd
and
    curr.ncadd = prev.ncadd
and
    curr.mjsid = prev.mjsid
and
    curr.lotname = prev.lotname
-- and
    -- curr.blkserial = prev.blkserial
order by
    machine_order asc,
    lane_no asc,
    timestamp asc,
    nhadd asc,
    ncadd asc
;


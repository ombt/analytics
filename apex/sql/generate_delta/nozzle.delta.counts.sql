with nozzle_cte (
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
) select
    curr.pcb_id as pcb_id,
    curr.pcb_serial as pcb_serial,
    -- curr.row as curr_row,
    -- prev.row as prev_row,
    curr.machine_order as machine_order,
    -- prev.machine_order as prev_machine_order,
    curr.lane_no as lane_no,
    -- prev.lane_no as prev_lane_no,
    curr.stage_no as stage_no,
    -- prev.stage_no as prev_stage_no,
    curr.timestamp as timestamp,
    -- prev.timestamp as prev_timestamp,
    curr.nhadd as nhadd,
    -- prev.nhadd as prev_nhadd,
    curr.ncadd as ncadd,
    -- prev.ncadd as prev_ncadd,
    curr.mjsid as mjsid,
    -- prev.mjsid as prev_mjsid,
    curr.lotname as lotname,
    -- prev.lotname as prev_lotname,
    -- curr.output_no as curr_output_no,
    -- prev.output_no as prev_output_no,
    -- curr.blkserial as blkserial,
    -- prev.blkserial as prev_blkserial,

    -- curr.pickup as curr_pickup,
    -- prev.pickup as prev_pickup,
    curr.pickup - prev.pickup as pickup,

    -- curr.pmiss as curr_pmiss,
    -- prev.pmiss as prev_pmiss,
    curr.pmiss - prev.pmiss as pmiss,

    -- curr.rmiss as curr_rmiss,
    -- prev.rmiss as prev_rmiss,
    curr.rmiss - prev.rmiss as rmiss,

    -- curr.dmiss as curr_dmiss,
    -- prev.dmiss as prev_dmiss,
    curr.dmiss - prev.dmiss as dmiss,

    -- curr.mmiss as curr_mmiss,
    -- prev.mmiss as prev_mmiss,
    curr.mmiss - prev.mmiss as mmiss,

    -- curr.hmiss as curr_hmiss,
    -- prev.hmiss as prev_hmiss,
    curr.hmiss - prev.hmiss as hmiss,

    -- curr.trsmiss as curr_trsmiss,
    -- prev.trsmiss as prev_trsmiss,
    curr.trsmiss - prev.trsmiss as trsmiss,

    -- curr.mount as curr_mount,
    -- prev.mount as prev_moun,
    curr.mount - prev.mount as mount

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


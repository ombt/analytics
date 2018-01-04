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
    pc._board               as board,
    pc._lotboard            as lotboard,
    pc._lotmodule           as lotmodule,
    pc._tmount              as tmount,
    pc._tpickup             as tpickup,
    -- pc._tpmiss              as tpmiss,
    -- pc._trmiss              as trmiss,
    -- pc._trserr              as trserr,
    -- pc._trsmiss             as trsmiss,
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
;


select 
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    -- ftf._filename,
    -- ftf._filename_type,
    -- ftf._filename_id,
    -- ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    -- ufd._output_no,
    -- ufd._pcb_id_lot_no,
    -- ufd._pcb_id_serial_no
    upi._filename_id,
    upi._bcrstatus,
    upi._code,
    upi._lane,
    upi._lotname,
    upi._lotnumber,
    upi._output,
    upi._planid,
    upi._productid,
    upi._rev,
    upi._serial,
    upi._serialstatus,
    upi._stage,
    -- i._filename_id,
    -- i._cid,
    -- i._timestamp,
    -- i._crc,
    i._c2d,
    i._recipename,
    -- i._mid,
    -- p._filename_id,
    -- p._p,
    -- p._cmp as cmp_idx,
    case
        when (p._cmp = -1) then 'PASS'
        when (p._cmp = 1) then 'FAIL'
        else 'UNKNOWN'
    END as aoi_status,
    -- p._sc,
    -- p._pid,
    -- p._fc,
    null as dummy
from
    u01.filename_to_fid ftf
inner join
    u01.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u01.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    upper(i._c2d) = upper(ufd._pcb_id)
inner join
    aoi.p p
on
    p._filename_id = i._filename_id
where
    ufd._output_no in ( 3, 4 )
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;


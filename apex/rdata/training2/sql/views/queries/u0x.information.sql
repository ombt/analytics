--        Table "u01.pivot_information"
--     Column     |     Type      | Modifiers 
-- ---------------+---------------+-----------
--  _filename_id  | numeric(30,0) | 
--  _bcrstatus    | text          | 
--  _code         | text          | 
--  _lane         | integer       | 
--  _lotname      | text          | 
--  _lotnumber    | integer       | 
--  _output       | integer       | 
--  _planid       | text          | 
--  _productid    | text          | 
--  _rev          | text          | 
--  _serial       | text          | 
--  _serialstatus | text          | 
--  _stage        | integer       | 
-- Indexes:
--     "idx_pivot_information" btree (_filename_id)
-- 
--        Table "u03.pivot_information"
--     Column     |     Type      | Modifiers 
-- ---------------+---------------+-----------
--  _filename_id  | numeric(30,0) | 
--  _bcrstatus    | text          | 
--  _code         | text          | 
--  _lane         | integer       | 
--  _lotname      | text          | 
--  _lotnumber    | integer       | 
--  _output       | integer       | 
--  _planid       | text          | 
--  _productid    | text          | 
--  _rev          | text          | 
--  _serial       | text          | 
--  _serialstatus | text          | 
--  _stage        | integer       | 
-- Indexes:
--     "idx_pivot_information" btree (_filename_id)

select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
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
    upi._stage
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
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

select
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    ufd._filename_id,
    ufd._date,
    ufd._pcb_serial,
    ufd._pcb_id,
    ufd._output_no,
    ufd._pcb_id_lot_no,
    ufd._pcb_id_serial_no,
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
    upi._stage
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;

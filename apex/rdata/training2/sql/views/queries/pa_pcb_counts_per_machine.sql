-- 
--             Table "u01.count"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_count" btree (_filename_id)
-- 
--               View "u01.count_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _timestamp          | bigint        | 
--  _mjsid              | text          | 
--  _lotname            | text          | 
--  _bndrcgstop         | numeric(10,3) | 
--  _bndstop            | numeric(10,3) | 
--  _board              | numeric(10,3) | 
--  _brcgstop           | numeric(10,3) | 
--  _bwait              | numeric(10,3) | 
--  _cderr              | numeric(10,3) | 
--  _cmerr              | numeric(10,3) | 
--  _cnvstop            | numeric(10,3) | 
--  _cperr              | numeric(10,3) | 
--  _crerr              | numeric(10,3) | 
--  _cterr              | numeric(10,3) | 
--  _cwait              | numeric(10,3) | 
--  _fbstop             | numeric(10,3) | 
--  _fwait              | numeric(10,3) | 
--  _jointpasswait      | numeric(10,3) | 
--  _judgestop          | numeric(10,3) | 
--  _lotboard           | numeric(10,3) | 
--  _lotmodule          | numeric(10,3) | 
--  _mcfwait            | numeric(10,3) | 
--  _mcrwait            | numeric(10,3) | 
--  _mhrcgstop          | numeric(10,3) | 
--  _module             | numeric(10,3) | 
--  _otherlstop         | numeric(10,3) | 
--  _othrstop           | numeric(10,3) | 
--  _pwait              | numeric(10,3) | 
--  _rwait              | numeric(10,3) | 
--  _scestop            | numeric(10,3) | 
--  _scstop             | numeric(10,3) | 
--  _swait              | numeric(10,3) | 
--  _tdispense          | numeric(10,3) | 
--  _tdmiss             | numeric(10,3) | 
--  _thmiss             | numeric(10,3) | 
--  _tmmiss             | numeric(10,3) | 
--  _tmount             | numeric(10,3) | 
--  _tpickup            | numeric(10,3) | 
--  _tpmiss             | numeric(10,3) | 
--  _tpriming           | numeric(10,3) | 
--  _trbl               | numeric(10,3) | 
--  _trmiss             | numeric(10,3) | 
--  _trserr             | numeric(10,3) | 
--  _trsmiss            | numeric(10,3) | 
-- 
--        Table "u01.crb_filename_data"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _history_id    | text          | 
--  _time_stamp    | text          | 
--  _crb_file_name | text          | 
--  _product_name  | text          | 
-- Indexes:
--     "idx_crb_filename_data" btree (_filename_id)
-- 
--           Table "u01.cycletime"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_cycletime" btree (_filename_id)
-- 
--           Table "u01.delta_feeder"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _pcb_id        | text          | 
--  _pcb_serial    | text          | 
--  _machine_order | integer       | 
--  _lane_no       | integer       | 
--  _stage_no      | integer       | 
--  _timestamp     | bigint        | 
--  _fadd          | integer       | 
--  _fsadd         | integer       | 
--  _mjsid         | text          | 
--  _lotname       | text          | 
--  _reelid        | text          | 
--  _partsname     | text          | 
--  _output_no     | integer       | 
--  _blkserial     | text          | 
--  _pickup        | integer       | 
--  _pmiss         | integer       | 
--  _rmiss         | integer       | 
--  _dmiss         | integer       | 
--  _mmiss         | integer       | 
--  _hmiss         | integer       | 
--  _trsmiss       | integer       | 
--  _mount         | integer       | 
-- Indexes:
--     "idx_delta_feeder" btree (_filename_id)
-- 
--           Table "u01.delta_nozzle"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _pcb_id        | text          | 
--  _pcb_serial    | text          | 
--  _machine_order | integer       | 
--  _lane_no       | integer       | 
--  _stage_no      | integer       | 
--  _timestamp     | bigint        | 
--  _nhadd         | integer       | 
--  _ncadd         | integer       | 
--  _mjsid         | text          | 
--  _lotname       | text          | 
--  _output_no     | integer       | 
--  _pickup        | integer       | 
--  _pmiss         | integer       | 
--  _rmiss         | integer       | 
--  _dmiss         | integer       | 
--  _mmiss         | integer       | 
--  _hmiss         | integer       | 
--  _trsmiss       | integer       | 
--  _mount         | integer       | 
-- Indexes:
--     "idx_delta_nozzle" btree (_filename_id)
-- 
--        Table "u01.delta_pivot_count"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _pcb_id        | text          | 
--  _pcb_serial    | text          | 
--  _machine_order | integer       | 
--  _lane_no       | integer       | 
--  _stage_no      | integer       | 
--  _timestamp     | bigint        | 
--  _mjsid         | text          | 
--  _lotname       | text          | 
--  _output_no     | integer       | 
--  _bndrcgstop    | numeric(10,3) | 
--  _bndstop       | numeric(10,3) | 
--  _board         | numeric(10,3) | 
--  _brcgstop      | numeric(10,3) | 
--  _bwait         | numeric(10,3) | 
--  _cderr         | numeric(10,3) | 
--  _cmerr         | numeric(10,3) | 
--  _cnvstop       | numeric(10,3) | 
--  _cperr         | numeric(10,3) | 
--  _crerr         | numeric(10,3) | 
--  _cterr         | numeric(10,3) | 
--  _cwait         | numeric(10,3) | 
--  _fbstop        | numeric(10,3) | 
--  _fwait         | numeric(10,3) | 
--  _jointpasswait | numeric(10,3) | 
--  _judgestop     | numeric(10,3) | 
--  _lotboard      | numeric(10,3) | 
--  _lotmodule     | numeric(10,3) | 
--  _mcfwait       | numeric(10,3) | 
--  _mcrwait       | numeric(10,3) | 
--  _mhrcgstop     | numeric(10,3) | 
--  _module        | numeric(10,3) | 
--  _otherlstop    | numeric(10,3) | 
--  _othrstop      | numeric(10,3) | 
--  _pwait         | numeric(10,3) | 
--  _rwait         | numeric(10,3) | 
--  _scestop       | numeric(10,3) | 
--  _scstop        | numeric(10,3) | 
--  _swait         | numeric(10,3) | 
--  _tdispense     | numeric(10,3) | 
--  _tdmiss        | numeric(10,3) | 
--  _thmiss        | numeric(10,3) | 
--  _tmmiss        | numeric(10,3) | 
--  _tmount        | numeric(10,3) | 
--  _tpickup       | numeric(10,3) | 
--  _tpmiss        | numeric(10,3) | 
--  _tpriming      | numeric(10,3) | 
--  _trbl          | numeric(10,3) | 
--  _trmiss        | numeric(10,3) | 
--  _trserr        | numeric(10,3) | 
--  _trsmiss       | numeric(10,3) | 
-- Indexes:
--     "idx_delta_pivot_count" btree (_filename_id)
-- 
--         Table "u01.delta_pivot_time"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _pcb_id        | text          | 
--  _pcb_serial    | text          | 
--  _machine_order | integer       | 
--  _lane_no       | integer       | 
--  _stage_no      | integer       | 
--  _timestamp     | bigint        | 
--  _mjsid         | text          | 
--  _lotname       | text          | 
--  _output_no     | integer       | 
--  _actual        | numeric(10,3) | 
--  _bndrcgstop    | numeric(10,3) | 
--  _bndstop       | numeric(10,3) | 
--  _brcg          | numeric(10,3) | 
--  _brcgstop      | numeric(10,3) | 
--  _bwait         | numeric(10,3) | 
--  _cderr         | numeric(10,3) | 
--  _change        | numeric(10,3) | 
--  _cmerr         | numeric(10,3) | 
--  _cnvstop       | numeric(10,3) | 
--  _cperr         | numeric(10,3) | 
--  _crerr         | numeric(10,3) | 
--  _cterr         | numeric(10,3) | 
--  _cwait         | numeric(10,3) | 
--  _dataedit      | numeric(10,3) | 
--  _fbstop        | numeric(10,3) | 
--  _fwait         | numeric(10,3) | 
--  _idle          | numeric(10,3) | 
--  _jointpasswait | numeric(10,3) | 
--  _judgestop     | numeric(10,3) | 
--  _load          | numeric(10,3) | 
--  _mcfwait       | numeric(10,3) | 
--  _mcrwait       | numeric(10,3) | 
--  _mente         | numeric(10,3) | 
--  _mhrcgstop     | numeric(10,3) | 
--  _mount         | numeric(10,3) | 
--  _otherlstop    | numeric(10,3) | 
--  _othrstop      | numeric(10,3) | 
--  _poweron       | numeric(10,3) | 
--  _prdstop       | numeric(10,3) | 
--  _prod          | numeric(10,3) | 
--  _prodview      | numeric(10,3) | 
--  _pwait         | numeric(10,3) | 
--  _rwait         | numeric(10,3) | 
--  _scestop       | numeric(10,3) | 
--  _scstop        | numeric(10,3) | 
--  _swait         | numeric(10,3) | 
--  _totalstop     | numeric(10,3) | 
--  _trbl          | numeric(10,3) | 
--  _trserr        | numeric(10,3) | 
--  _unitadjust    | numeric(10,3) | 
-- Indexes:
--     "idx_delta_pivot_time" btree (_filename_id)
-- 
--           Table "u01.dispenser"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _head        | text          | 
--  _nhadd       | text          | 
--  _blkcode     | text          | 
--  _blkserial   | text          | 
--  _usen        | text          | 
--  _nozzlename  | text          | 
--  _bondid      | text          | 
--  _useb        | text          | 
--  _bondlibname | text          | 
--  _dispense    | text          | 
--  _priming     | text          | 
--  _psrerr      | text          | 
-- Indexes:
--     "idx_dispenser" btree (_filename_id)
-- 
--              View "u01.feeder_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _fadd               | integer       | 
--  _fsadd              | integer       | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _timestamp          | bigint        | 
--  _mjsid              | text          | 
--  _lotname            | text          | 
--  _reelid             | text          | 
--  _partsname          | text          | 
--  _blkserial          | text          | 
--  _pickup             | integer       | 
--  _pmiss              | integer       | 
--  _rmiss              | integer       | 
--  _dmiss              | integer       | 
--  _mmiss              | integer       | 
--  _hmiss              | integer       | 
--  _trsmiss            | integer       | 
--  _mount              | integer       | 
-- 
--            Table "u01.filename_to_fid"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
-- Indexes:
--     "idx_filename_to_fid_1" btree (_filename_id)
--     "idx_filename_to_fid_2" btree (_filename_timestamp)
--     "idx_filename_to_fid_3" btree (_filename_id, _filename_timestamp)
--     "idx_filename_to_fid_4" btree (_filename_timestamp, _filename_id)
-- 
--             Index "u01.idx_count"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.count"
-- 
--       Index "u01.idx_crb_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.crb_filename_data"
-- 
--           Index "u01.idx_cycletime"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.cycletime"
-- 
--         Index "u01.idx_delta_feeder"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.delta_feeder"
-- 
--         Index "u01.idx_delta_nozzle"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.delta_nozzle"
-- 
--       Index "u01.idx_delta_pivot_count"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.delta_pivot_count"
-- 
--       Index "u01.idx_delta_pivot_time"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.delta_pivot_time"
-- 
--           Index "u01.idx_dispenser"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.dispenser"
-- 
--       Index "u01.idx_filename_to_fid_1"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.filename_to_fid"
-- 
--          Index "u01.idx_filename_to_fid_2"
--        Column        |  Type  |     Definition      
-- ---------------------+--------+---------------------
--  _filename_timestamp | bigint | _filename_timestamp
-- btree, for table "u01.filename_to_fid"
-- 
--              Index "u01.idx_filename_to_fid_3"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_id        | numeric(30,0) | _filename_id
--  _filename_timestamp | bigint        | _filename_timestamp
-- btree, for table "u01.filename_to_fid"
-- 
--              Index "u01.idx_filename_to_fid_4"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_timestamp | bigint        | _filename_timestamp
--  _filename_id        | numeric(30,0) | _filename_id
-- btree, for table "u01.filename_to_fid"
-- 
--             Index "u01.idx_index"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.index"
-- 
--          Index "u01.idx_information"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.information"
-- 
--        Index "u01.idx_inspectiondata"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.inspectiondata"
-- 
--       Index "u01.idx_mountpickupfeeder"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.mountpickupfeeder"
-- 
--       Index "u01.idx_mountpickupnozzle"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.mountpickupnozzle"
-- 
--          Index "u01.idx_pivot_count"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.pivot_count"
-- 
--          Index "u01.idx_pivot_index"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.pivot_index"
-- 
--       Index "u01.idx_pivot_information"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.pivot_information"
-- 
--          Index "u01.idx_pivot_time"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.pivot_time"
-- 
--       Index "u01.idx_rst_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.rst_filename_data"
-- 
--             Index "u01.idx_time"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.time"
-- 
--       Index "u01.idx_u0x_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u01.u0x_filename_data"
-- 
--             Table "u01.index"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_index" btree (_filename_id)
-- 
--         View "u01.index_information_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _author             | text          | 
--  _authortype         | text          | 
--  _comment            | text          | 
--  idx_date            | text          | 
--  _diff               | text          | 
--  _format             | text          | 
--  _machine            | text          | 
--  _mjsid              | text          | 
--  _version            | text          | 
--  _bcrstatus          | text          | 
--  _code               | text          | 
--  _lane               | integer       | 
--  _lotname            | text          | 
--  _lotnumber          | integer       | 
--  _output             | integer       | 
--  _planid             | text          | 
--  _productid          | text          | 
--  _rev                | text          | 
--  _serial             | text          | 
--  _serialstatus       | text          | 
--  _stage              | integer       | 
-- 
--               View "u01.index_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _author             | text          | 
--  _authortype         | text          | 
--  _comment            | text          | 
--  index_date          | text          | 
--  _diff               | text          | 
--  _format             | text          | 
--  _machine            | text          | 
--  _mjsid              | text          | 
--  _version            | text          | 
-- 
--          Table "u01.information"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_information" btree (_filename_id)
-- 
--            View "u01.information_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _bcrstatus          | text          | 
--  _code               | text          | 
--  _lotname            | text          | 
--  _lotnumber          | integer       | 
--  _output             | integer       | 
--  _planid             | text          | 
--  _productid          | text          | 
--  _rev                | text          | 
--  _serial             | text          | 
--  _serialstatus       | text          | 
-- 
--         Table "u01.inspectiondata"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_inspectiondata" btree (_filename_id)
-- 
--       Table "u01.mountpickupfeeder"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _blkcode     | text          | 
--  _blkserial   | text          | 
--  _usef        | integer       | 
--  _partsname   | text          | 
--  _fadd        | integer       | 
--  _fsadd       | integer       | 
--  _reelid      | text          | 
--  _user        | integer       | 
--  _pickup      | integer       | 
--  _pmiss       | integer       | 
--  _rmiss       | integer       | 
--  _dmiss       | integer       | 
--  _mmiss       | integer       | 
--  _hmiss       | integer       | 
--  _trsmiss     | integer       | 
--  _mount       | integer       | 
--  _lname       | text          | 
--  _tgserial    | text          | 
-- Indexes:
--     "idx_mountpickupfeeder" btree (_filename_id)
-- 
--       Table "u01.mountpickupnozzle"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _head        | integer       | 
--  _nhadd       | integer       | 
--  _ncadd       | integer       | 
--  _blkcode     | text          | 
--  _blkserial   | text          | 
--  _user        | integer       | 
--  _nozzlename  | integer       | 
--  _pickup      | integer       | 
--  _pmiss       | integer       | 
--  _rmiss       | integer       | 
--  _dmiss       | integer       | 
--  _mmiss       | integer       | 
--  _hmiss       | integer       | 
--  _trsmiss     | integer       | 
--  _mount       | integer       | 
-- Indexes:
--     "idx_mountpickupnozzle" btree (_filename_id)
-- 
--              View "u01.nozzle_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _timestamp          | bigint        | 
--  _nhadd              | integer       | 
--  _ncadd              | integer       | 
--  _mjsid              | text          | 
--  _lotname            | text          | 
--  _pickup             | integer       | 
--  _pmiss              | integer       | 
--  _rmiss              | integer       | 
--  _dmiss              | integer       | 
--  _mmiss              | integer       | 
--  _hmiss              | integer       | 
--  _trsmiss            | integer       | 
--  _mount              | integer       | 
-- 
--   View "u01.pa_pcb_status_per_machine_no_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename_id        | numeric(30,0) | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _lotname            | text          | 
--  _lotnumber          | integer       | 
--  _output             | integer       | 
--  _productid          | text          | 
--  _serial             | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  aoi_status          | text          | 
-- 
--     View "u01.pa_pcb_status_per_machine_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename_id        | numeric(30,0) | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _lotname            | text          | 
--  _lotnumber          | integer       | 
--  _output             | integer       | 
--  _productid          | text          | 
--  _serial             | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  aoi_status          | text          | 
-- 
--           Table "u01.pivot_count"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _bndrcgstop    | numeric(10,3) | 
--  _bndstop       | numeric(10,3) | 
--  _board         | numeric(10,3) | 
--  _brcgstop      | numeric(10,3) | 
--  _bwait         | numeric(10,3) | 
--  _cderr         | numeric(10,3) | 
--  _cmerr         | numeric(10,3) | 
--  _cnvstop       | numeric(10,3) | 
--  _cperr         | numeric(10,3) | 
--  _crerr         | numeric(10,3) | 
--  _cterr         | numeric(10,3) | 
--  _cwait         | numeric(10,3) | 
--  _fbstop        | numeric(10,3) | 
--  _fwait         | numeric(10,3) | 
--  _jointpasswait | numeric(10,3) | 
--  _judgestop     | numeric(10,3) | 
--  _lotboard      | numeric(10,3) | 
--  _lotmodule     | numeric(10,3) | 
--  _mcfwait       | numeric(10,3) | 
--  _mcrwait       | numeric(10,3) | 
--  _mhrcgstop     | numeric(10,3) | 
--  _module        | numeric(10,3) | 
--  _otherlstop    | numeric(10,3) | 
--  _othrstop      | numeric(10,3) | 
--  _pwait         | numeric(10,3) | 
--  _rwait         | numeric(10,3) | 
--  _scestop       | numeric(10,3) | 
--  _scstop        | numeric(10,3) | 
--  _swait         | numeric(10,3) | 
--  _tdispense     | numeric(10,3) | 
--  _tdmiss        | numeric(10,3) | 
--  _thmiss        | numeric(10,3) | 
--  _tmmiss        | numeric(10,3) | 
--  _tmount        | numeric(10,3) | 
--  _tpickup       | numeric(10,3) | 
--  _tpmiss        | numeric(10,3) | 
--  _tpriming      | numeric(10,3) | 
--  _trbl          | numeric(10,3) | 
--  _trmiss        | numeric(10,3) | 
--  _trserr        | numeric(10,3) | 
--  _trsmiss       | numeric(10,3) | 
-- Indexes:
--     "idx_pivot_count" btree (_filename_id)
-- 
--          Table "u01.pivot_index"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _author      | text          | 
--  _authortype  | text          | 
--  _comment     | text          | 
--  _date        | text          | 
--  _diff        | text          | 
--  _format      | text          | 
--  _machine     | text          | 
--  _mjsid       | text          | 
--  _version     | text          | 
-- Indexes:
--     "idx_pivot_index" btree (_filename_id)
-- 
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
--            Table "u01.pivot_time"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _actual        | numeric(10,3) | 
--  _bndrcgstop    | numeric(10,3) | 
--  _bndstop       | numeric(10,3) | 
--  _brcg          | numeric(10,3) | 
--  _brcgstop      | numeric(10,3) | 
--  _bwait         | numeric(10,3) | 
--  _cderr         | numeric(10,3) | 
--  _change        | numeric(10,3) | 
--  _cmerr         | numeric(10,3) | 
--  _cnvstop       | numeric(10,3) | 
--  _cperr         | numeric(10,3) | 
--  _crerr         | numeric(10,3) | 
--  _cterr         | numeric(10,3) | 
--  _cwait         | numeric(10,3) | 
--  _dataedit      | numeric(10,3) | 
--  _fbstop        | numeric(10,3) | 
--  _fwait         | numeric(10,3) | 
--  _idle          | numeric(10,3) | 
--  _jointpasswait | numeric(10,3) | 
--  _judgestop     | numeric(10,3) | 
--  _load          | numeric(10,3) | 
--  _mcfwait       | numeric(10,3) | 
--  _mcrwait       | numeric(10,3) | 
--  _mente         | numeric(10,3) | 
--  _mhrcgstop     | numeric(10,3) | 
--  _mount         | numeric(10,3) | 
--  _otherlstop    | numeric(10,3) | 
--  _othrstop      | numeric(10,3) | 
--  _poweron       | numeric(10,3) | 
--  _prdstop       | numeric(10,3) | 
--  _prod          | numeric(10,3) | 
--  _prodview      | numeric(10,3) | 
--  _pwait         | numeric(10,3) | 
--  _rwait         | numeric(10,3) | 
--  _scestop       | numeric(10,3) | 
--  _scstop        | numeric(10,3) | 
--  _swait         | numeric(10,3) | 
--  _totalstop     | numeric(10,3) | 
--  _trbl          | numeric(10,3) | 
--  _trserr        | numeric(10,3) | 
--  _unitadjust    | numeric(10,3) | 
-- Indexes:
--     "idx_pivot_time" btree (_filename_id)
-- 
--          Table "u01.rst_filename_data"
--        Column       |     Type      | Modifiers 
-- --------------------+---------------+-----------
--  _filename_id       | numeric(30,0) | 
--  _machine           | text          | 
--  _lane              | integer       | 
--  _date_time         | text          | 
--  _serial_number     | text          | 
--  _inspection_result | text          | 
--  _board_removed     | text          | 
-- Indexes:
--     "idx_rst_filename_data" btree (_filename_id)
-- 
--              Table "u01.time"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_time" btree (_filename_id)
-- 
--               View "u01.time_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _timestamp          | bigint        | 
--  _mjsid              | text          | 
--  _lotname            | text          | 
--  _actual             | numeric(10,3) | 
--  _bndrcgstop         | numeric(10,3) | 
--  _bndstop            | numeric(10,3) | 
--  _brcg               | numeric(10,3) | 
--  _brcgstop           | numeric(10,3) | 
--  _bwait              | numeric(10,3) | 
--  _cderr              | numeric(10,3) | 
--  _change             | numeric(10,3) | 
--  _cmerr              | numeric(10,3) | 
--  _cnvstop            | numeric(10,3) | 
--  _cperr              | numeric(10,3) | 
--  _crerr              | numeric(10,3) | 
--  _cterr              | numeric(10,3) | 
--  _cwait              | numeric(10,3) | 
--  _dataedit           | numeric(10,3) | 
--  _fbstop             | numeric(10,3) | 
--  _fwait              | numeric(10,3) | 
--  _idle               | numeric(10,3) | 
--  _jointpasswait      | numeric(10,3) | 
--  _judgestop          | numeric(10,3) | 
--  _load               | numeric(10,3) | 
--  _mcfwait            | numeric(10,3) | 
--  _mcrwait            | numeric(10,3) | 
--  _mente              | numeric(10,3) | 
--  _mhrcgstop          | numeric(10,3) | 
--  _mount              | numeric(10,3) | 
--  _otherlstop         | numeric(10,3) | 
--  _othrstop           | numeric(10,3) | 
--  _poweron            | numeric(10,3) | 
--  _prdstop            | numeric(10,3) | 
--  _prod               | numeric(10,3) | 
--  _prodview           | numeric(10,3) | 
--  _pwait              | numeric(10,3) | 
--  _rwait              | numeric(10,3) | 
--  _scestop            | numeric(10,3) | 
--  _scstop             | numeric(10,3) | 
--  _swait              | numeric(10,3) | 
--  _totalstop          | numeric(10,3) | 
--  _trbl               | numeric(10,3) | 
--  _trserr             | numeric(10,3) | 
--  _unitadjust         | numeric(10,3) | 
-- 
--          Table "u01.u0x_filename_data"
--       Column       |     Type      | Modifiers 
-- -------------------+---------------+-----------
--  _filename_id      | numeric(30,0) | 
--  _date             | text          | 
--  _machine_order    | integer       | 
--  _stage_no         | integer       | 
--  _lane_no          | integer       | 
--  _pcb_serial       | text          | 
--  _pcb_id           | text          | 
--  _output_no        | integer       | 
--  _pcb_id_lot_no    | text          | 
--  _pcb_id_serial_no | text          | 
-- Indexes:
--     "idx_u0x_filename_data" btree (_filename_id)

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
    dpc._filename_id,
    dpc._pcb_id,
    dpc._pcb_serial,
    dpc._machine_order,
    dpc._lane_no,
    dpc._stage_no,
    dpc._timestamp,
    dpc._mjsid,
    dpc._lotname,
    dpc._output_no,
    dpc._bndrcgstop,
    dpc._bndstop,
    dpc._board,
    dpc._brcgstop,
    dpc._bwait,
    dpc._cderr,
    dpc._cmerr,
    dpc._cnvstop,
    dpc._cperr,
    dpc._crerr,
    dpc._cterr,
    dpc._cwait,
    dpc._fbstop,
    dpc._fwait,
    dpc._jointpasswait,
    dpc._judgestop,
    dpc._lotboard,
    dpc._lotmodule,
    dpc._mcfwait,
    dpc._mcrwait,
    dpc._mhrcgstop,
    dpc._module,
    dpc._otherlstop,
    dpc._othrstop,
    dpc._pwait,
    dpc._rwait,
    dpc._scestop,
    dpc._scstop,
    dpc._swait,
    dpc._tdispense,
    dpc._tdmiss,
    dpc._thmiss,
    dpc._tmmiss,
    dpc._tmount,
    dpc._tpickup,
    dpc._tpmiss,
    dpc._tpriming,
    dpc._trbl,
    dpc._trmiss,
    dpc._trserr,
    dpc._trsmiss,
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
inner join
    u01.delta_pivot_count dpc
on
    dpc._filename_id = ftf._filename_id
where
    ufd._output_no in ( 3, 4 )
order by
    ftf._filename_route,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no,
    ftf._filename_timestamp
;


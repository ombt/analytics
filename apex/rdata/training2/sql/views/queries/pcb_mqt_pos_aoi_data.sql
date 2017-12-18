-- 
--        Table "crb.crb_filename_data"
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
--            Table "crb.filename_to_fid"
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
--       Index "crb.idx_crb_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "crb.crb_filename_data"
-- 
--       Index "crb.idx_filename_to_fid_1"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "crb.filename_to_fid"
-- 
--          Index "crb.idx_filename_to_fid_2"
--        Column        |  Type  |     Definition      
-- ---------------------+--------+---------------------
--  _filename_timestamp | bigint | _filename_timestamp
-- btree, for table "crb.filename_to_fid"
-- 
--              Index "crb.idx_filename_to_fid_3"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_id        | numeric(30,0) | _filename_id
--  _filename_timestamp | bigint        | _filename_timestamp
-- btree, for table "crb.filename_to_fid"
-- 
--              Index "crb.idx_filename_to_fid_4"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_timestamp | bigint        | _filename_timestamp
--  _filename_id        | numeric(30,0) | _filename_id
-- btree, for table "crb.filename_to_fid"
-- 
--       Index "crb.idx_rst_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "crb.rst_filename_data"
-- 
--       Index "crb.idx_u0x_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "crb.u0x_filename_data"
-- 
--          Table "crb.rst_filename_data"
--        Column       |     Type      | Modifiers 
-- --------------------+---------------+-----------
--  _filename_id       | numeric(30,0) | 
--  _machine           | text          | 
--  _lane              | text          | 
--  _date_time         | text          | 
--  _serial_number     | text          | 
--  _inspection_result | text          | 
--  _board_removed     | text          | 
-- Indexes:
--     "idx_rst_filename_data" btree (_filename_id)
-- 
--          Table "crb.u0x_filename_data"
--       Column       |     Type      | Modifiers 
-- -------------------+---------------+-----------
--  _filename_id      | numeric(30,0) | 
--  _date             | text          | 
--  _machine_order    | text          | 
--  _stage_no         | text          | 
--  _lane_no          | text          | 
--  _pcb_serial       | text          | 
--  _pcb_id           | text          | 
--  _output_no        | text          | 
--  _pcb_id_lot_no    | text          | 
--  _pcb_id_serial_no | text          | 
-- Indexes:
--     "idx_u0x_filename_data" btree (_filename_id)
-- 
--              View "crb.lot_no_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _history_id         | text          | 
--  _time_stamp         | text          | 
--  _crb_file_name      | text          | 
--  _product_name       | text          | 
--  lot_idnum           | integer       | 
--  _lotnum             | integer       | 
--  _lot                | text          | 
--  _mcfilename         | text          | 
--  _filter             | text          | 
--  _autochg            | text          | 
--  _basechg            | text          | 
--  _lane               | text          | 
--  _productionid       | text          | 
--  _simproduct         | text          | 
--  _dgspcbname         | text          | 
--  _dgspcbrev          | text          | 
--  _dgspcbside         | text          | 
--  _dgsrefpin          | text          | 
--  lot_c               | text          | 
--  _datagenmode        | text          | 
--  _mounthead          | text          | 
--  _vstpath            | text          | 
--  _targettact         | text          | 
--  _order              | text          | 
-- 
--       View "crb.lot_position_data_no_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _history_id         | text          | 
--  _time_stamp         | text          | 
--  _crb_file_name      | text          | 
--  _product_name       | text          | 
--  lot_idnum           | integer       | 
--  _lotnum             | integer       | 
--  _lot                | text          | 
--  _mcfilename         | text          | 
--  _filter             | text          | 
--  _autochg            | text          | 
--  _basechg            | text          | 
--  _lane               | text          | 
--  _productionid       | text          | 
--  _simproduct         | text          | 
--  _dgspcbname         | text          | 
--  _dgspcbrev          | text          | 
--  _dgspcbside         | text          | 
--  _dgsrefpin          | text          | 
--  lot_c               | text          | 
--  _datagenmode        | text          | 
--  _mounthead          | text          | 
--  _vstpath            | text          | 
--  _targettact         | text          | 
--  _order              | text          | 
--  _lot_number         | integer       | 
--  pos_idnum           | integer       | 
--  _cadid              | text          | 
--  _x                  | text          | 
--  _y                  | text          | 
--  _a                  | text          | 
--  _parts              | text          | 
--  _brm                | text          | 
--  _turn               | text          | 
--  _dturn              | text          | 
--  _ts                 | text          | 
--  _ms                 | text          | 
--  _ds                 | text          | 
--  _np                 | text          | 
--  _dnp                | text          | 
--  _pu                 | text          | 
--  _side               | text          | 
--  _dpu                | text          | 
--  _head               | text          | 
--  _dhead              | text          | 
--  _ihead              | text          | 
--  _b                  | text          | 
--  _pg                 | text          | 
--  _s                  | text          | 
--  _rid                | text          | 
--  pos_c               | text          | 
--  _m                  | text          | 
--  _mb                 | text          | 
--  _f                  | text          | 
--  _pr                 | text          | 
--  _priseq             | text          | 
--  _p                  | text          | 
--  _pad                | text          | 
--  _vw                 | text          | 
--  _stdpos             | text          | 
--  _land               | text          | 
--  _depend             | text          | 
--  _chkflag            | text          | 
--  _exchk              | text          | 
--  _grand              | text          | 
--  _marea              | text          | 
--  _rmset              | text          | 
--  _sh                 | text          | 
--  _scandir1           | text          | 
--  _scandir2           | text          | 
--  _ohl                | text          | 
--  _ohr                | text          | 
--  _apcctrl            | text          | 
--  _wg                 | text          | 
--  _skipnumber         | text          | 
-- 
--         View "crb.lot_position_data_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _history_id         | text          | 
--  _time_stamp         | text          | 
--  _crb_file_name      | text          | 
--  _product_name       | text          | 
--  lot_idnum           | integer       | 
--  _lotnum             | integer       | 
--  _lot                | text          | 
--  _mcfilename         | text          | 
--  _filter             | text          | 
--  _autochg            | text          | 
--  _basechg            | text          | 
--  _lane               | text          | 
--  _productionid       | text          | 
--  _simproduct         | text          | 
--  _dgspcbname         | text          | 
--  _dgspcbrev          | text          | 
--  _dgspcbside         | text          | 
--  _dgsrefpin          | text          | 
--  lot_c               | text          | 
--  _datagenmode        | text          | 
--  _mounthead          | text          | 
--  _vstpath            | text          | 
--  _targettact         | text          | 
--  _order              | text          | 
--  _lot_number         | integer       | 
--  pos_idnum           | integer       | 
--  _cadid              | text          | 
--  _x                  | text          | 
--  _y                  | text          | 
--  _a                  | text          | 
--  _parts              | text          | 
--  _brm                | text          | 
--  _turn               | text          | 
--  _dturn              | text          | 
--  _ts                 | text          | 
--  _ms                 | text          | 
--  _ds                 | text          | 
--  _np                 | text          | 
--  _dnp                | text          | 
--  _pu                 | text          | 
--  _side               | text          | 
--  _dpu                | text          | 
--  _head               | text          | 
--  _dhead              | text          | 
--  _ihead              | text          | 
--  _b                  | text          | 
--  _pg                 | text          | 
--  _s                  | text          | 
--  _rid                | text          | 
--  pos_c               | text          | 
--  _m                  | text          | 
--  _mb                 | text          | 
--  _f                  | text          | 
--  _pr                 | text          | 
--  _priseq             | text          | 
--  _p                  | text          | 
--  _pad                | text          | 
--  _vw                 | text          | 
--  _stdpos             | text          | 
--  _land               | text          | 
--  _depend             | text          | 
--  _chkflag            | text          | 
--  _exchk              | text          | 
--  _grand              | text          | 
--  _marea              | text          | 
--  _rmset              | text          | 
--  _sh                 | text          | 
--  _scandir1           | text          | 
--  _scandir2           | text          | 
--  _ohl                | text          | 
--  _ohr                | text          | 
--  _apcctrl            | text          | 
--  _wg                 | text          | 
--  _skipnumber         | text          | 
-- 
--                View "crb.lot_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _filename_timestamp | bigint        | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _history_id         | text          | 
--  _time_stamp         | text          | 
--  _crb_file_name      | text          | 
--  _product_name       | text          | 
--  lot_idnum           | integer       | 
--  _lotnum             | integer       | 
--  _lot                | text          | 
--  _mcfilename         | text          | 
--  _filter             | text          | 
--  _autochg            | text          | 
--  _basechg            | text          | 
--  _lane               | text          | 
--  _productionid       | text          | 
--  _simproduct         | text          | 
--  _dgspcbname         | text          | 
--  _dgspcbrev          | text          | 
--  _dgspcbside         | text          | 
--  _dgsrefpin          | text          | 
--  lot_c               | text          | 
--  _datagenmode        | text          | 
--  _mounthead          | text          | 
--  _vstpath            | text          | 
--  _targettact         | text          | 
--  _order              | text          | 
-- 
--            Table "crb.lotnames"
--     Column     |     Type      | Modifiers 
-- ---------------+---------------+-----------
--  _filename_id  | numeric(30,0) | 
--  _idnum        | integer       | 
--  _lotnum       | integer       | 
--  _lot          | text          | 
--  _mcfilename   | text          | 
--  _filter       | text          | 
--  _autochg      | text          | 
--  _basechg      | text          | 
--  _lane         | text          | 
--  _productionid | text          | 
--  _simproduct   | text          | 
--  _dgspcbname   | text          | 
--  _dgspcbrev    | text          | 
--  _dgspcbside   | text          | 
--  _dgsrefpin    | text          | 
--  _c            | text          | 
--  _datagenmode  | text          | 
--  _mounthead    | text          | 
--  _vstpath      | text          | 
--  _order        | text          | 
--  _targettact   | text          | 
-- Indexes:
--     "idx_lotnames" btree (_filename_id)
-- 
--           Table "crb.lotoptions"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _lot_number  | integer       | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_lotoptions" btree (_filename_id)
-- 
--          Table "crb.positiondata"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _lot_number  | integer       | 
--  _idnum       | integer       | 
--  _cadid       | text          | 
--  _x           | text          | 
--  _y           | text          | 
--  _a           | text          | 
--  _parts       | text          | 
--  _brm         | text          | 
--  _turn        | text          | 
--  _dturn       | text          | 
--  _ts          | text          | 
--  _ms          | text          | 
--  _ds          | text          | 
--  _np          | text          | 
--  _dnp         | text          | 
--  _pu          | text          | 
--  _side        | text          | 
--  _dpu         | text          | 
--  _head        | text          | 
--  _dhead       | text          | 
--  _ihead       | text          | 
--  _b           | text          | 
--  _pg          | text          | 
--  _s           | text          | 
--  _rid         | text          | 
--  _c           | text          | 
--  _m           | text          | 
--  _mb          | text          | 
--  _f           | text          | 
--  _pr          | text          | 
--  _priseq      | text          | 
--  _p           | text          | 
--  _pad         | text          | 
--  _vw          | text          | 
--  _stdpos      | text          | 
--  _land        | text          | 
--  _depend      | text          | 
--  _chkflag     | text          | 
--  _exchk       | text          | 
--  _grand       | text          | 
--  _marea       | text          | 
--  _rmset       | text          | 
--  _sh          | text          | 
--  _scandir1    | text          | 
--  _scandir2    | text          | 
--  _ohl         | text          | 
--  _ohr         | text          | 
--  _apcctrl     | text          | 
--  _wg          | text          | 
--  _skipnumber  | text          | 
-- Indexes:
--     "idx_positiondata" btree (_filename_id)
-- 
--          Table "crb.pivot_index"
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
-- 
--              View "aoi.all_no_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
--  _cmp                | integer       | 
--  _cc                 | text          | 
--  _ref                | text          | 
--  _type               | text          | 
--  _defect             | integer       | 
--  _insp_type          | text          | 
--  _lead_id            | text          | 
-- 
--                View "aoi.all_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
--  _cmp                | integer       | 
--  _cc                 | text          | 
--  _ref                | text          | 
--  _type               | text          | 
--  _defect             | integer       | 
--  _insp_type          | text          | 
--  _lead_id            | text          | 
-- 
--       Table "aoi.aoi_filename_data"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _aoi_pcbid   | text          | 
--  _date_time   | text          | 
-- Indexes:
--     "idx_aoi_filename_data" btree (_filename_id)
-- 
--              Table "aoi.cmp"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _p           | integer       | 
--  _cmp         | integer       | 
--  _cc          | text          | 
--  _ref         | text          | 
--  _type        | text          | 
-- Indexes:
--     "idx_cmp_fid" btree (_filename_id)
--     "idx_cmp_fid_cmp" btree (_filename_id, _cmp)
--     "idx_cmp_fid_p" btree (_filename_id, _p)
--     "idx_cmp_fid_p_cmp" btree (_filename_id, _p, _cmp)
-- 
--             Table "aoi.defect"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _cmp         | integer       | 
--  _defect      | integer       | 
--  _insp_type   | text          | 
--  _lead_id     | text          | 
-- Indexes:
--     "idx_defect_fid" btree (_filename_id)
--     "idx_defect_fid_cmp" btree (_filename_id, _cmp)
--     "idx_defect_fid_cmp_defect" btree (_filename_id, _cmp, _defect)
--     "idx_defect_fid_defect" btree (_filename_id, _defect)
-- 
--             View "aoi.file_data_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
-- 
--            Table "aoi.filename_to_fid"
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
--              View "aoi.good_no_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
-- 
--               View "aoi.good_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
-- 
--       Index "aoi.idx_aoi_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "aoi.aoi_filename_data"
-- 
--            Index "aoi.idx_cmp_fid"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "aoi.cmp"
-- 
--          Index "aoi.idx_cmp_fid_cmp"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _cmp         | integer       | _cmp
-- btree, for table "aoi.cmp"
-- 
--           Index "aoi.idx_cmp_fid_p"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _p           | integer       | _p
-- btree, for table "aoi.cmp"
-- 
--         Index "aoi.idx_cmp_fid_p_cmp"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _p           | integer       | _p
--  _cmp         | integer       | _cmp
-- btree, for table "aoi.cmp"
-- 
--          Index "aoi.idx_defect_fid"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "aoi.defect"
-- 
--        Index "aoi.idx_defect_fid_cmp"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _cmp         | integer       | _cmp
-- btree, for table "aoi.defect"
-- 
--     Index "aoi.idx_defect_fid_cmp_defect"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _cmp         | integer       | _cmp
--  _defect      | integer       | _defect
-- btree, for table "aoi.defect"
-- 
--       Index "aoi.idx_defect_fid_defect"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _defect      | integer       | _defect
-- btree, for table "aoi.defect"
-- 
--       Index "aoi.idx_filename_to_fid_1"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "aoi.filename_to_fid"
-- 
--          Index "aoi.idx_filename_to_fid_2"
--        Column        |  Type  |     Definition      
-- ---------------------+--------+---------------------
--  _filename_timestamp | bigint | _filename_timestamp
-- btree, for table "aoi.filename_to_fid"
-- 
--              Index "aoi.idx_filename_to_fid_3"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_id        | numeric(30,0) | _filename_id
--  _filename_timestamp | bigint        | _filename_timestamp
-- btree, for table "aoi.filename_to_fid"
-- 
--              Index "aoi.idx_filename_to_fid_4"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_timestamp | bigint        | _filename_timestamp
--  _filename_id        | numeric(30,0) | _filename_id
-- btree, for table "aoi.filename_to_fid"
-- 
--           Index "aoi.idx_insp_fid"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "aoi.insp"
-- 
--             Index "aoi.idx_p_fid"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "aoi.p"
-- 
--           Index "aoi.idx_p_fid_cmp"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _cmp         | integer       | _cmp
-- btree, for table "aoi.p"
-- 
--            Index "aoi.idx_p_fid_p"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _p           | integer       | _p
-- btree, for table "aoi.p"
-- 
--          Index "aoi.idx_p_fid_p_cmp"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
--  _p           | integer       | _p
--  _cmp         | integer       | _cmp
-- btree, for table "aoi.p"
-- 
--              Table "aoi.insp"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _cid         | text          | 
--  _timestamp   | text          | 
--  _crc         | text          | 
--  _c2d         | text          | 
--  _recipename  | text          | 
--  _mid         | text          | 
-- Indexes:
--     "idx_insp_fid" btree (_filename_id)
-- 
--            View "aoi.no_good_no_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
--  _cmp                | integer       | 
--  _cc                 | text          | 
--  _ref                | text          | 
--  _type               | text          | 
--  _defect             | integer       | 
--  _insp_type          | text          | 
--  _lead_id            | text          | 
-- 
--              View "aoi.no_good_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
--  _cmp                | integer       | 
--  _cc                 | text          | 
--  _ref                | text          | 
--  _type               | text          | 
--  _defect             | integer       | 
--  _insp_type          | text          | 
--  _lead_id            | text          | 
-- 
--               Table "aoi.p"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _p           | integer       | 
--  _cmp         | integer       | 
--  _sc          | text          | 
--  _pid         | text          | 
--  _fc          | text          | 
-- Indexes:
--     "idx_p_fid" btree (_filename_id)
--     "idx_p_fid_cmp" btree (_filename_id, _cmp)
--     "idx_p_fid_p" btree (_filename_id, _p)
--     "idx_p_fid_p_cmp" btree (_filename_id, _p, _cmp)
-- 
--            View "aoi.pcb_status_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_timestamp | bigint        | 
--  _filename_route     | text          | 
--  _filename_id        | numeric(30,0) | 
--  _aoi_pcbid          | text          | 
--  _date_time          | text          | 
--  _cid                | text          | 
--  _timestamp          | text          | 
--  _crc                | text          | 
--  _c2d                | text          | 
--  _recipename         | text          | 
--  _mid                | text          | 
--  _p                  | integer       | 
--  cmp_idx             | integer       | 
--  _sc                 | text          | 
--  _pid                | text          | 
--  _fc                 | text          | 
-- 
--             Table "u03.brecg"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _idnum       | text          | 
--  _brecx       | text          | 
--  _brecy       | text          | 
-- Indexes:
--     "idx_brecg" btree (_filename_id)
-- 
--           Table "u03.brecgcalc"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _idnum       | text          | 
--  _breccalcx   | text          | 
--  _breccalcy   | text          | 
-- Indexes:
--     "idx_brecgcalc" btree (_filename_id)
-- 
--        Table "u03.crb_filename_data"
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
--        Table "u03.elapsetimerecog"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _beamno      | text          | 
--  _targetno    | text          | 
--  _f           | text          | 
--  _recx        | text          | 
--  _recy        | text          | 
--  _recz        | text          | 
--  _rect        | text          | 
--  _stockerno   | text          | 
--  _turnno      | text          | 
-- Indexes:
--     "idx_elapsetimerecog" btree (_filename_id)
-- 
--            Table "u03.filename_to_fid"
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
--          Table "u03.heightcorrect"
--      Column     |     Type      | Modifiers 
-- ----------------+---------------+-----------
--  _filename_id   | numeric(30,0) | 
--  _b             | text          | 
--  _idnum         | text          | 
--  _measureresult | text          | 
-- Indexes:
--     "idx_heightcorrect" btree (_filename_id)
-- 
--             Index "u03.idx_brecg"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.brecg"
-- 
--           Index "u03.idx_brecgcalc"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.brecgcalc"
-- 
--       Index "u03.idx_crb_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.crb_filename_data"
-- 
--        Index "u03.idx_elapsetimerecog"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.elapsetimerecog"
-- 
--       Index "u03.idx_filename_to_fid_1"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.filename_to_fid"
-- 
--          Index "u03.idx_filename_to_fid_2"
--        Column        |  Type  |     Definition      
-- ---------------------+--------+---------------------
--  _filename_timestamp | bigint | _filename_timestamp
-- btree, for table "u03.filename_to_fid"
-- 
--              Index "u03.idx_filename_to_fid_3"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_id        | numeric(30,0) | _filename_id
--  _filename_timestamp | bigint        | _filename_timestamp
-- btree, for table "u03.filename_to_fid"
-- 
--              Index "u03.idx_filename_to_fid_4"
--        Column        |     Type      |     Definition      
-- ---------------------+---------------+---------------------
--  _filename_timestamp | bigint        | _filename_timestamp
--  _filename_id        | numeric(30,0) | _filename_id
-- btree, for table "u03.filename_to_fid"
-- 
--         Index "u03.idx_heightcorrect"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.heightcorrect"
-- 
--             Index "u03.idx_index"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.index"
-- 
--          Index "u03.idx_information"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.information"
-- 
--       Index "u03.idx_mountexchangereel"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.mountexchangereel"
-- 
--        Index "u03.idx_mountlatestreel"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.mountlatestreel"
-- 
--       Index "u03.idx_mountnormaltrace"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.mountnormaltrace"
-- 
--       Index "u03.idx_mountqualitytrace"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.mountqualitytrace"
-- 
--          Index "u03.idx_pivot_index"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.pivot_index"
-- 
--       Index "u03.idx_pivot_information"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.pivot_information"
-- 
--       Index "u03.idx_rst_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.rst_filename_data"
-- 
--            Index "u03.idx_sboard"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.sboard"
-- 
--       Index "u03.idx_u0x_filename_data"
--     Column    |     Type      |  Definition  
-- --------------+---------------+--------------
--  _filename_id | numeric(30,0) | _filename_id
-- btree, for table "u03.u0x_filename_data"
-- 
--             Table "u03.index"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_index" btree (_filename_id)
-- 
--         View "u03.index_info_mqt_no_view"
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
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _mjsid              | text          | 
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
--  _b                  | integer       | 
--  _idnum              | integer       | 
--  _turn               | integer       | 
--  _ms                 | integer       | 
--  _ts                 | integer       | 
--  _fadd               | integer       | 
--  _fsadd              | integer       | 
--  _nhadd              | integer       | 
--  _ncadd              | integer       | 
--  _fblkcode           | text          | 
--  _fblkserial         | text          | 
--  _nblkcode           | text          | 
--  _nblkserial         | text          | 
--  _reelid             | text          | 
--  _f                  | integer       | 
--  _rcgx               | numeric(10,3) | 
--  _rcgy               | numeric(10,3) | 
--  _rcga               | numeric(10,3) | 
--  _tcx                | numeric(10,3) | 
--  _tcy                | numeric(10,3) | 
--  _mposirecx          | numeric(10,3) | 
--  _mposirecy          | numeric(10,3) | 
--  _mposireca          | numeric(10,3) | 
--  _mposirecz          | numeric(10,3) | 
--  _thmax              | numeric(10,3) | 
--  _thave              | numeric(10,3) | 
--  _mntcx              | numeric(10,3) | 
--  _mntcy              | numeric(10,3) | 
--  _mntca              | numeric(10,3) | 
--  _tlx                | numeric(10,3) | 
--  _tly                | numeric(10,3) | 
--  _inspectarea        | integer       | 
--  _didnum             | integer       | 
--  _ds                 | integer       | 
--  _dispenseid         | text          | 
--  _parts              | integer       | 
--  _warpz              | numeric(10,3) | 
--  _prepickuplot       | text          | 
--  _prepickupsts       | text          | 
-- 
--          View "u03.index_info_mqt_view"
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
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _mjsid              | text          | 
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
--  _b                  | integer       | 
--  _idnum              | integer       | 
--  _turn               | integer       | 
--  _ms                 | integer       | 
--  _ts                 | integer       | 
--  _fadd               | integer       | 
--  _fsadd              | integer       | 
--  _nhadd              | integer       | 
--  _ncadd              | integer       | 
--  _fblkcode           | text          | 
--  _fblkserial         | text          | 
--  _nblkcode           | text          | 
--  _nblkserial         | text          | 
--  _reelid             | text          | 
--  _f                  | integer       | 
--  _rcgx               | numeric(10,3) | 
--  _rcgy               | numeric(10,3) | 
--  _rcga               | numeric(10,3) | 
--  _tcx                | numeric(10,3) | 
--  _tcy                | numeric(10,3) | 
--  _mposirecx          | numeric(10,3) | 
--  _mposirecy          | numeric(10,3) | 
--  _mposireca          | numeric(10,3) | 
--  _mposirecz          | numeric(10,3) | 
--  _thmax              | numeric(10,3) | 
--  _thave              | numeric(10,3) | 
--  _mntcx              | numeric(10,3) | 
--  _mntcy              | numeric(10,3) | 
--  _mntca              | numeric(10,3) | 
--  _tlx                | numeric(10,3) | 
--  _tly                | numeric(10,3) | 
--  _inspectarea        | integer       | 
--  _didnum             | integer       | 
--  _ds                 | integer       | 
--  _dispenseid         | text          | 
--  _parts              | integer       | 
--  _warpz              | numeric(10,3) | 
--  _prepickuplot       | text          | 
--  _prepickupsts       | text          | 
-- 
--         View "u03.index_information_view"
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
--               View "u03.index_view"
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
--  index_date          | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _author             | text          | 
--  _authortype         | text          | 
--  _comment            | text          | 
--  _date               | text          | 
--  _diff               | text          | 
--  _format             | text          | 
--  _machine            | text          | 
--  _mjsid              | text          | 
--  _version            | text          | 
-- 
--          Table "u03.information"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _name        | text          | 
--  _value       | text          | 
-- Indexes:
--     "idx_information" btree (_filename_id)
-- 
--            View "u03.information_view"
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
--       Table "u03.mountexchangereel"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _blkcode     | text          | 
--  _blkserial   | text          | 
--  _ftype       | text          | 
--  _fadd        | text          | 
--  _fsadd       | text          | 
--  _use         | text          | 
--  _pestatus    | text          | 
--  _pcstatus    | text          | 
--  _remain      | text          | 
--  _init        | text          | 
--  _partsname   | text          | 
--  _custom1     | text          | 
--  _custom2     | text          | 
--  _custom3     | text          | 
--  _custom4     | text          | 
--  _reelid      | text          | 
--  _partsemp    | text          | 
--  _active      | text          | 
-- Indexes:
--     "idx_mountexchangereel" btree (_filename_id)
-- 
--         View "u03.mountexchangereel_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _fadd               | text          | 
--  _fsadd              | text          | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _blkcode            | text          | 
--  _blkserial          | text          | 
--  _ftype              | text          | 
--  _use                | text          | 
--  _pestatus           | text          | 
--  _pcstatus           | text          | 
--  _remain             | text          | 
--  _init               | text          | 
--  _partsname          | text          | 
--  _custom1            | text          | 
--  _custom2            | text          | 
--  _custom3            | text          | 
--  _custom4            | text          | 
--  _reelid             | text          | 
--  _partsemp           | text          | 
--  _active             | text          | 
-- 
--        Table "u03.mountlatestreel"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _blkcode     | text          | 
--  _blkserial   | text          | 
--  _ftype       | text          | 
--  _fadd        | text          | 
--  _fsadd       | text          | 
--  _use         | text          | 
--  _pestatus    | text          | 
--  _pcstatus    | text          | 
--  _remain      | text          | 
--  _init        | text          | 
--  _partsname   | text          | 
--  _custom1     | text          | 
--  _custom2     | text          | 
--  _custom3     | text          | 
--  _custom4     | text          | 
--  _reelid      | text          | 
--  _partsemp    | text          | 
--  _active      | text          | 
--  _tgserial    | text          | 
-- Indexes:
--     "idx_mountlatestreel" btree (_filename_id)
-- 
--          View "u03.mountlatestreel_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _fadd               | text          | 
--  _fsadd              | text          | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _blkcode            | text          | 
--  _blkserial          | text          | 
--  _ftype              | text          | 
--  _use                | text          | 
--  _pestatus           | text          | 
--  _pcstatus           | text          | 
--  _remain             | text          | 
--  _init               | text          | 
--  _partsname          | text          | 
--  _custom1            | text          | 
--  _custom2            | text          | 
--  _custom3            | text          | 
--  _custom4            | text          | 
--  _reelid             | text          | 
--  _partsemp           | text          | 
--  _active             | text          | 
--  _tgserial           | text          | 
-- 
--        Table "u03.mountnormaltrace"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _b           | text          | 
--  _idnum       | text          | 
--  _fadd        | text          | 
--  _fsadd       | text          | 
--  _nhadd       | text          | 
--  _ncadd       | text          | 
--  _reelid      | text          | 
-- Indexes:
--     "idx_mountnormaltrace" btree (_filename_id)
-- 
--         View "u03.mountnormaltrace_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _fadd               | text          | 
--  _fsadd              | text          | 
--  _nhadd              | text          | 
--  _ncadd              | text          | 
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
--  _b                  | text          | 
--  _idnum              | text          | 
--  _reelid             | text          | 
-- 
--        Table "u03.mountqualitytrace"
--     Column     |     Type      | Modifiers 
-- ---------------+---------------+-----------
--  _filename_id  | numeric(30,0) | 
--  _b            | integer       | 
--  _idnum        | integer       | 
--  _turn         | integer       | 
--  _ms           | integer       | 
--  _ts           | integer       | 
--  _fadd         | integer       | 
--  _fsadd        | integer       | 
--  _fblkcode     | text          | 
--  _fblkserial   | text          | 
--  _nhadd        | integer       | 
--  _ncadd        | integer       | 
--  _nblkcode     | text          | 
--  _nblkserial   | text          | 
--  _reelid       | text          | 
--  _f            | integer       | 
--  _rcgx         | numeric(10,3) | 
--  _rcgy         | numeric(10,3) | 
--  _rcga         | numeric(10,3) | 
--  _tcx          | numeric(10,3) | 
--  _tcy          | numeric(10,3) | 
--  _mposirecx    | numeric(10,3) | 
--  _mposirecy    | numeric(10,3) | 
--  _mposireca    | numeric(10,3) | 
--  _mposirecz    | numeric(10,3) | 
--  _thmax        | numeric(10,3) | 
--  _thave        | numeric(10,3) | 
--  _mntcx        | numeric(10,3) | 
--  _mntcy        | numeric(10,3) | 
--  _mntca        | numeric(10,3) | 
--  _tlx          | numeric(10,3) | 
--  _tly          | numeric(10,3) | 
--  _inspectarea  | integer       | 
--  _didnum       | integer       | 
--  _ds           | integer       | 
--  _dispenseid   | text          | 
--  _parts        | integer       | 
--  _warpz        | numeric(10,3) | 
--  _prepickuplot | text          | 
--  _prepickupsts | text          | 
-- Indexes:
--     "idx_mountqualitytrace" btree (_filename_id)
-- 
--         View "u03.mountqualitytrace_view"
--        Column        |     Type      | Modifiers 
-- ---------------------+---------------+-----------
--  _filename_route     | text          | 
--  _machine_order      | integer       | 
--  _lane_no            | integer       | 
--  _stage_no           | integer       | 
--  _filename_timestamp | bigint        | 
--  _fadd               | integer       | 
--  _fsadd              | integer       | 
--  _nhadd              | integer       | 
--  _ncadd              | integer       | 
--  _filename           | text          | 
--  _filename_type      | text          | 
--  _filename_id        | numeric(30,0) | 
--  _date               | text          | 
--  _pcb_serial         | text          | 
--  _pcb_id             | text          | 
--  _output_no          | integer       | 
--  _pcb_id_lot_no      | text          | 
--  _pcb_id_serial_no   | text          | 
--  _b                  | integer       | 
--  _idnum              | integer       | 
--  _turn               | integer       | 
--  _ms                 | integer       | 
--  _ts                 | integer       | 
--  _fblkcode           | text          | 
--  _fblkserial         | text          | 
--  _nblkcode           | text          | 
--  _nblkserial         | text          | 
--  _reelid             | text          | 
--  _f                  | integer       | 
--  _rcgx               | numeric(10,3) | 
--  _rcgy               | numeric(10,3) | 
--  _rcga               | numeric(10,3) | 
--  _tcx                | numeric(10,3) | 
--  _tcy                | numeric(10,3) | 
--  _mposirecx          | numeric(10,3) | 
--  _mposirecy          | numeric(10,3) | 
--  _mposireca          | numeric(10,3) | 
--  _mposirecz          | numeric(10,3) | 
--  _thmax              | numeric(10,3) | 
--  _thave              | numeric(10,3) | 
--  _mntcx              | numeric(10,3) | 
--  _mntcy              | numeric(10,3) | 
--  _mntca              | numeric(10,3) | 
--  _tlx                | numeric(10,3) | 
--  _tly                | numeric(10,3) | 
--  _inspectarea        | integer       | 
--  _didnum             | integer       | 
--  _ds                 | integer       | 
--  _dispenseid         | text          | 
--  _parts              | integer       | 
--  _warpz              | numeric(10,3) | 
--  _prepickuplot       | text          | 
--  _prepickupsts       | text          | 
-- 
--        View "u03.mqt_pos_data_aoi_good_view"
--          Column         |     Type      | Modifiers 
-- ------------------------+---------------+-----------
--  mqt_filename_route     | text          | 
--  mqt_machine_order      | integer       | 
--  mqt_lane_no            | integer       | 
--  mqt_stage_no           | integer       | 
--  mqt_filename_timestamp | bigint        | 
--  mqt_filename_id        | numeric(30,0) | 
--  mqt_pcb_serial         | text          | 
--  mqt_pcb_id             | text          | 
--  mqt_output_no          | integer       | 
--  mqt_pcb_id_lot_no      | text          | 
--  mqt_pcb_id_serial_no   | text          | 
--  mqt_mjsid              | text          | 
--  mqt_bcrstatus          | text          | 
--  mqt_code               | text          | 
--  mqt_lane               | integer       | 
--  mqt_lotname            | text          | 
--  mqt_lotnumber          | integer       | 
--  mqt_output             | integer       | 
--  mqt_planid             | text          | 
--  mqt_productid          | text          | 
--  mqt_rev                | text          | 
--  mqt_serial             | text          | 
--  mqt_serialstatus       | text          | 
--  mqt_stage              | integer       | 
--  mqt_b                  | integer       | 
--  mqt_idnum              | integer       | 
--  mqt_turn               | integer       | 
--  mqt_ms                 | integer       | 
--  mqt_ts                 | integer       | 
--  mqt_fadd               | integer       | 
--  mqt_fsadd              | integer       | 
--  mqt_nhadd              | integer       | 
--  mqt_ncadd              | integer       | 
--  mqt_fblkcode           | text          | 
--  mqt_fblkserial         | text          | 
--  mqt_nblkcode           | text          | 
--  mqt_nblkserial         | text          | 
--  mqt_reelid             | text          | 
--  mqt_f                  | integer       | 
--  mqt_rcgx               | numeric(10,3) | 
--  mqt_rcgy               | numeric(10,3) | 
--  mqt_rcga               | numeric(10,3) | 
--  mqt_tcx                | numeric(10,3) | 
--  mqt_tcy                | numeric(10,3) | 
--  mqt_mposirecx          | numeric(10,3) | 
--  mqt_mposirecy          | numeric(10,3) | 
--  mqt_mposireca          | numeric(10,3) | 
--  mqt_mposirecz          | numeric(10,3) | 
--  mqt_thmax              | numeric(10,3) | 
--  mqt_thave              | numeric(10,3) | 
--  mqt_mntcx              | numeric(10,3) | 
--  mqt_mntcy              | numeric(10,3) | 
--  mqt_mntca              | numeric(10,3) | 
--  mqt_tlx                | numeric(10,3) | 
--  mqt_tly                | numeric(10,3) | 
--  mqt_inspectarea        | integer       | 
--  mqt_didnum             | integer       | 
--  mqt_ds                 | integer       | 
--  mqt_dispenseid         | text          | 
--  mqt_parts              | integer       | 
--  mqt_warpz              | numeric(10,3) | 
--  mqt_prepickuplot       | text          | 
--  mqt_prepickupsts       | text          | 
--  pos_filename_route     | text          | 
--  pos_filename_timestamp | bigint        | 
--  pos_filename           | text          | 
--  pos_filename_type      | text          | 
--  pos_filename_id        | numeric(30,0) | 
--  pos_history_id         | text          | 
--  pos_time_stamp         | text          | 
--  pos_crb_file_name      | text          | 
--  pos_product_name       | text          | 
--  pos_lot_idnum          | integer       | 
--  pos_lotnum             | integer       | 
--  pos_lot                | text          | 
--  pos_mcfilename         | text          | 
--  pos_filter             | text          | 
--  pos_autochg            | text          | 
--  pos_basechg            | text          | 
--  pos_lane               | text          | 
--  pos_productionid       | text          | 
--  pos_simproduct         | text          | 
--  pos_dgspcbname         | text          | 
--  pos_dgspcbrev          | text          | 
--  pos_dgspcbside         | text          | 
--  pos_dgsrefpin          | text          | 
--  pos_lot_c              | text          | 
--  pos_datagenmode        | text          | 
--  pos_mounthead          | text          | 
--  pos_vstpath            | text          | 
--  pos_targettact         | text          | 
--  pos_order              | text          | 
--  pos_lot_number         | integer       | 
--  pos_idnum              | integer       | 
--  pos_cadid              | text          | 
--  pos_x                  | text          | 
--  pos_y                  | text          | 
--  pos_a                  | text          | 
--  pos_parts              | text          | 
--  pos_brm                | text          | 
--  pos_turn               | text          | 
--  pos_dturn              | text          | 
--  pos_ts                 | text          | 
--  pos_ms                 | text          | 
--  pos_ds                 | text          | 
--  pos_np                 | text          | 
--  pos_dnp                | text          | 
--  pos_pu                 | text          | 
--  pos_side               | text          | 
--  pos_dpu                | text          | 
--  pos_head               | text          | 
--  pos_dhead              | text          | 
--  pos_ihead              | text          | 
--  pos_b                  | text          | 
--  pos_pg                 | text          | 
--  pos_s                  | text          | 
--  pos_rid                | text          | 
--  pos_c                  | text          | 
--  pos_m                  | text          | 
--  pos_mb                 | text          | 
--  pos_f                  | text          | 
--  pos_pr                 | text          | 
--  pos_priseq             | text          | 
--  pos_p                  | text          | 
--  pos_pad                | text          | 
--  pos_vw                 | text          | 
--  pos_stdpos             | text          | 
--  pos_land               | text          | 
--  pos_depend             | text          | 
--  pos_chkflag            | text          | 
--  pos_exchk              | text          | 
--  pos_grand              | text          | 
--  pos_marea              | text          | 
--  pos_rmset              | text          | 
--  pos_sh                 | text          | 
--  pos_scandir1           | text          | 
--  pos_scandir2           | text          | 
--  pos_ohl                | text          | 
--  pos_ohr                | text          | 
--  pos_apcctrl            | text          | 
--  pos_wg                 | text          | 
--  pos_skipnumber         | text          | 
--  aoi_filename           | text          | 
--  aoi_filename_type      | text          | 
--  aoi_filename_timestamp | bigint        | 
--  aoi_filename_route     | text          | 
--  aoi_filename_id        | numeric(30,0) | 
--  aoi_aoi_pcbid          | text          | 
--  aoi_date_time          | text          | 
--  aoi_cid                | text          | 
--  aoi_timestamp          | text          | 
--  aoi_crc                | text          | 
--  aoi_c2d                | text          | 
--  aoi_recipename         | text          | 
--  aoi_mid                | text          | 
--  aoi_p                  | integer       | 
--  aoi_cmp_idx            | integer       | 
--  aoi_sc                 | text          | 
--  aoi_pid                | text          | 
--  aoi_fc                 | text          | 
-- 
--       View "u03.mqt_pos_data_aoi_no_good_view"
--          Column         |     Type      | Modifiers 
-- ------------------------+---------------+-----------
--  mqt_filename_route     | text          | 
--  mqt_machine_order      | integer       | 
--  mqt_lane_no            | integer       | 
--  mqt_stage_no           | integer       | 
--  mqt_filename_timestamp | bigint        | 
--  mqt_filename_id        | numeric(30,0) | 
--  mqt_pcb_serial         | text          | 
--  mqt_pcb_id             | text          | 
--  mqt_output_no          | integer       | 
--  mqt_pcb_id_lot_no      | text          | 
--  mqt_pcb_id_serial_no   | text          | 
--  mqt_mjsid              | text          | 
--  mqt_bcrstatus          | text          | 
--  mqt_code               | text          | 
--  mqt_lane               | integer       | 
--  mqt_lotname            | text          | 
--  mqt_lotnumber          | integer       | 
--  mqt_output             | integer       | 
--  mqt_planid             | text          | 
--  mqt_productid          | text          | 
--  mqt_rev                | text          | 
--  mqt_serial             | text          | 
--  mqt_serialstatus       | text          | 
--  mqt_stage              | integer       | 
--  mqt_b                  | integer       | 
--  mqt_idnum              | integer       | 
--  mqt_turn               | integer       | 
--  mqt_ms                 | integer       | 
--  mqt_ts                 | integer       | 
--  mqt_fadd               | integer       | 
--  mqt_fsadd              | integer       | 
--  mqt_nhadd              | integer       | 
--  mqt_ncadd              | integer       | 
--  mqt_fblkcode           | text          | 
--  mqt_fblkserial         | text          | 
--  mqt_nblkcode           | text          | 
--  mqt_nblkserial         | text          | 
--  mqt_reelid             | text          | 
--  mqt_f                  | integer       | 
--  mqt_rcgx               | numeric(10,3) | 
--  mqt_rcgy               | numeric(10,3) | 
--  mqt_rcga               | numeric(10,3) | 
--  mqt_tcx                | numeric(10,3) | 
--  mqt_tcy                | numeric(10,3) | 
--  mqt_mposirecx          | numeric(10,3) | 
--  mqt_mposirecy          | numeric(10,3) | 
--  mqt_mposireca          | numeric(10,3) | 
--  mqt_mposirecz          | numeric(10,3) | 
--  mqt_thmax              | numeric(10,3) | 
--  mqt_thave              | numeric(10,3) | 
--  mqt_mntcx              | numeric(10,3) | 
--  mqt_mntcy              | numeric(10,3) | 
--  mqt_mntca              | numeric(10,3) | 
--  mqt_tlx                | numeric(10,3) | 
--  mqt_tly                | numeric(10,3) | 
--  mqt_inspectarea        | integer       | 
--  mqt_didnum             | integer       | 
--  mqt_ds                 | integer       | 
--  mqt_dispenseid         | text          | 
--  mqt_parts              | integer       | 
--  mqt_warpz              | numeric(10,3) | 
--  mqt_prepickuplot       | text          | 
--  mqt_prepickupsts       | text          | 
--  pos_filename_route     | text          | 
--  pos_filename_timestamp | bigint        | 
--  pos_filename           | text          | 
--  pos_filename_type      | text          | 
--  pos_filename_id        | numeric(30,0) | 
--  pos_history_id         | text          | 
--  pos_time_stamp         | text          | 
--  pos_crb_file_name      | text          | 
--  pos_product_name       | text          | 
--  pos_lot_idnum          | integer       | 
--  pos_lotnum             | integer       | 
--  pos_lot                | text          | 
--  pos_mcfilename         | text          | 
--  pos_filter             | text          | 
--  pos_autochg            | text          | 
--  pos_basechg            | text          | 
--  pos_lane               | text          | 
--  pos_productionid       | text          | 
--  pos_simproduct         | text          | 
--  pos_dgspcbname         | text          | 
--  pos_dgspcbrev          | text          | 
--  pos_dgspcbside         | text          | 
--  pos_dgsrefpin          | text          | 
--  pos_lot_c              | text          | 
--  pos_datagenmode        | text          | 
--  pos_mounthead          | text          | 
--  pos_vstpath            | text          | 
--  pos_targettact         | text          | 
--  pos_order              | text          | 
--  pos_lot_number         | integer       | 
--  pos_idnum              | integer       | 
--  pos_cadid              | text          | 
--  pos_x                  | text          | 
--  pos_y                  | text          | 
--  pos_a                  | text          | 
--  pos_parts              | text          | 
--  pos_brm                | text          | 
--  pos_turn               | text          | 
--  pos_dturn              | text          | 
--  pos_ts                 | text          | 
--  pos_ms                 | text          | 
--  pos_ds                 | text          | 
--  pos_np                 | text          | 
--  pos_dnp                | text          | 
--  pos_pu                 | text          | 
--  pos_side               | text          | 
--  pos_dpu                | text          | 
--  pos_head               | text          | 
--  pos_dhead              | text          | 
--  pos_ihead              | text          | 
--  pos_b                  | text          | 
--  pos_pg                 | text          | 
--  pos_s                  | text          | 
--  pos_rid                | text          | 
--  pos_c                  | text          | 
--  pos_m                  | text          | 
--  pos_mb                 | text          | 
--  pos_f                  | text          | 
--  pos_pr                 | text          | 
--  pos_priseq             | text          | 
--  pos_p                  | text          | 
--  pos_pad                | text          | 
--  pos_vw                 | text          | 
--  pos_stdpos             | text          | 
--  pos_land               | text          | 
--  pos_depend             | text          | 
--  pos_chkflag            | text          | 
--  pos_exchk              | text          | 
--  pos_grand              | text          | 
--  pos_marea              | text          | 
--  pos_rmset              | text          | 
--  pos_sh                 | text          | 
--  pos_scandir1           | text          | 
--  pos_scandir2           | text          | 
--  pos_ohl                | text          | 
--  pos_ohr                | text          | 
--  pos_apcctrl            | text          | 
--  pos_wg                 | text          | 
--  pos_skipnumber         | text          | 
--  aoi_filename           | text          | 
--  aoi_filename_type      | text          | 
--  aoi_filename_timestamp | bigint        | 
--  aoi_filename_route     | text          | 
--  aoi_filename_id        | numeric(30,0) | 
--  aoi_aoi_pcbid          | text          | 
--  aoi_date_time          | text          | 
--  aoi_cid                | text          | 
--  aoi_timestamp          | text          | 
--  aoi_crc                | text          | 
--  aoi_c2d                | text          | 
--  aoi_recipename         | text          | 
--  aoi_mid                | text          | 
--  aoi_p                  | integer       | 
--  aoi_cmp_idx            | integer       | 
--  aoi_sc                 | text          | 
--  aoi_pid                | text          | 
--  aoi_fc                 | text          | 
--  aoi_cmp                | integer       | 
--  aoi_cc                 | text          | 
--  aoi_ref                | text          | 
--  aoi_type               | text          | 
--  aoi_defect             | integer       | 
--  aoi_insp_type          | text          | 
--  aoi_lead_id            | text          | 
-- 
--             View "u03.mqt_pos_data_view"
--          Column         |     Type      | Modifiers 
-- ------------------------+---------------+-----------
--  mqt_filename_route     | text          | 
--  mqt_machine_order      | integer       | 
--  mqt_lane_no            | integer       | 
--  mqt_stage_no           | integer       | 
--  mqt_filename_timestamp | bigint        | 
--  mqt_filename_id        | numeric(30,0) | 
--  mqt_pcb_serial         | text          | 
--  mqt_pcb_id             | text          | 
--  mqt_output_no          | integer       | 
--  mqt_pcb_id_lot_no      | text          | 
--  mqt_pcb_id_serial_no   | text          | 
--  mqt_mjsid              | text          | 
--  mqt_bcrstatus          | text          | 
--  mqt_code               | text          | 
--  mqt_lane               | integer       | 
--  mqt_lotname            | text          | 
--  mqt_lotnumber          | integer       | 
--  mqt_output             | integer       | 
--  mqt_planid             | text          | 
--  mqt_productid          | text          | 
--  mqt_rev                | text          | 
--  mqt_serial             | text          | 
--  mqt_serialstatus       | text          | 
--  mqt_stage              | integer       | 
--  mqt_b                  | integer       | 
--  mqt_idnum              | integer       | 
--  mqt_turn               | integer       | 
--  mqt_ms                 | integer       | 
--  mqt_ts                 | integer       | 
--  mqt_fadd               | integer       | 
--  mqt_fsadd              | integer       | 
--  mqt_nhadd              | integer       | 
--  mqt_ncadd              | integer       | 
--  mqt_fblkcode           | text          | 
--  mqt_fblkserial         | text          | 
--  mqt_nblkcode           | text          | 
--  mqt_nblkserial         | text          | 
--  mqt_reelid             | text          | 
--  mqt_f                  | integer       | 
--  mqt_rcgx               | numeric(10,3) | 
--  mqt_rcgy               | numeric(10,3) | 
--  mqt_rcga               | numeric(10,3) | 
--  mqt_tcx                | numeric(10,3) | 
--  mqt_tcy                | numeric(10,3) | 
--  mqt_mposirecx          | numeric(10,3) | 
--  mqt_mposirecy          | numeric(10,3) | 
--  mqt_mposireca          | numeric(10,3) | 
--  mqt_mposirecz          | numeric(10,3) | 
--  mqt_thmax              | numeric(10,3) | 
--  mqt_thave              | numeric(10,3) | 
--  mqt_mntcx              | numeric(10,3) | 
--  mqt_mntcy              | numeric(10,3) | 
--  mqt_mntca              | numeric(10,3) | 
--  mqt_tlx                | numeric(10,3) | 
--  mqt_tly                | numeric(10,3) | 
--  mqt_inspectarea        | integer       | 
--  mqt_didnum             | integer       | 
--  mqt_ds                 | integer       | 
--  mqt_dispenseid         | text          | 
--  mqt_parts              | integer       | 
--  mqt_warpz              | numeric(10,3) | 
--  mqt_prepickuplot       | text          | 
--  mqt_prepickupsts       | text          | 
--  pos_filename_route     | text          | 
--  pos_filename_timestamp | bigint        | 
--  pos_filename           | text          | 
--  pos_filename_type      | text          | 
--  pos_filename_id        | numeric(30,0) | 
--  pos_history_id         | text          | 
--  pos_time_stamp         | text          | 
--  pos_crb_file_name      | text          | 
--  pos_product_name       | text          | 
--  pos_lot_idnum          | integer       | 
--  pos_lotnum             | integer       | 
--  pos_lot                | text          | 
--  pos_mcfilename         | text          | 
--  pos_filter             | text          | 
--  pos_autochg            | text          | 
--  pos_basechg            | text          | 
--  pos_lane               | text          | 
--  pos_productionid       | text          | 
--  pos_simproduct         | text          | 
--  pos_dgspcbname         | text          | 
--  pos_dgspcbrev          | text          | 
--  pos_dgspcbside         | text          | 
--  pos_dgsrefpin          | text          | 
--  pos_lot_c              | text          | 
--  pos_datagenmode        | text          | 
--  pos_mounthead          | text          | 
--  pos_vstpath            | text          | 
--  pos_targettact         | text          | 
--  pos_order              | text          | 
--  pos_lot_number         | integer       | 
--  pos_idnum              | integer       | 
--  pos_cadid              | text          | 
--  pos_x                  | text          | 
--  pos_y                  | text          | 
--  pos_a                  | text          | 
--  pos_parts              | text          | 
--  pos_brm                | text          | 
--  pos_turn               | text          | 
--  pos_dturn              | text          | 
--  pos_ts                 | text          | 
--  pos_ms                 | text          | 
--  pos_ds                 | text          | 
--  pos_np                 | text          | 
--  pos_dnp                | text          | 
--  pos_pu                 | text          | 
--  pos_side               | text          | 
--  pos_dpu                | text          | 
--  pos_head               | text          | 
--  pos_dhead              | text          | 
--  pos_ihead              | text          | 
--  pos_b                  | text          | 
--  pos_pg                 | text          | 
--  pos_s                  | text          | 
--  pos_rid                | text          | 
--  pos_c                  | text          | 
--  pos_m                  | text          | 
--  pos_mb                 | text          | 
--  pos_f                  | text          | 
--  pos_pr                 | text          | 
--  pos_priseq             | text          | 
--  pos_p                  | text          | 
--  pos_pad                | text          | 
--  pos_vw                 | text          | 
--  pos_stdpos             | text          | 
--  pos_land               | text          | 
--  pos_depend             | text          | 
--  pos_chkflag            | text          | 
--  pos_exchk              | text          | 
--  pos_grand              | text          | 
--  pos_marea              | text          | 
--  pos_rmset              | text          | 
--  pos_sh                 | text          | 
--  pos_scandir1           | text          | 
--  pos_scandir2           | text          | 
--  pos_ohl                | text          | 
--  pos_ohr                | text          | 
--  pos_apcctrl            | text          | 
--  pos_wg                 | text          | 
--  pos_skipnumber         | text          | 
-- 
--          Table "u03.pivot_index"
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
-- 
--          Table "u03.rst_filename_data"
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
--             Table "u03.sboard"
--     Column    |     Type      | Modifiers 
-- --------------+---------------+-----------
--  _filename_id | numeric(30,0) | 
--  _b           | text          | 
--  _scode       | text          | 
--  _sbcrstatus  | text          | 
-- Indexes:
--     "idx_sboard" btree (_filename_id)
-- 
--          Table "u03.u0x_filename_data"
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
-- 

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
    upx._filename_id,
    upx._author,
    upx._authortype,
    upx._comment,
    -- upx._date,
    upx._diff,
    upx._format,
    upx._machine,
    upx._mjsid,
    upx._version,
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
    aftf._filename,
    aftf._filename_type,
    aftf._filename_timestamp,
    aftf._filename_route,
    aftf._filename_id,
    aafd._filename_id,
    aafd._aoi_pcbid,
    aafd._date_time,
    ai._filename_id,
    ai._cid,
    ai._timestamp,
    ai._crc,
    ai._c2d,
    ai._recipename,
    ai._mid,
    ap._filename_id,
    ap._p,
    -- ap._cmp,
    case
        when (ap._cmp = -1) then 'PASSED'
        when (ap._cmp = 1) then 'FAILED'
        else 'UNKNOWN'
    end as aoi_board_status,
    ap._sc,
    ap._pid,
    ap._fc,
    mqt._filename_id,
    mqt._b,
    mqt._idnum,
    mqt._turn,
    mqt._ms,
    mqt._ts,
    mqt._fadd,
    mqt._fsadd,
    mqt._fblkcode,
    mqt._fblkserial,
    mqt._nhadd,
    mqt._ncadd,
    mqt._nblkcode,
    mqt._nblkserial,
    mqt._reelid,
    mqt._f,
    case
        when (mqt._f = 0) then 'MOUNT SUCCESS'
        when (mqt._f = 1) then 'EXHAUST'
        when (mqt._f = 2) then 'PICK UP ERROR BY VACUUM SENSOR DETECTION'
        when (mqt._f = 3) then 'PICK UP ERROR BY RECOGNITION'
        when (mqt._f = 4) then 'COMPONENT STAND ERROR'
        when (mqt._f = 5) then 'RECOGNITION ERROR'
        when (mqt._f = 6) then 'DROP ERROR'
        when (mqt._f = 7) then 'MOUNT ERROR'
        when (mqt._f = 8) then 'BLOW OUT ERROR'
        when (mqt._f = 9) then 'NO MOUNT OR INVALID BY MOUNT SUSPEND'
        when (mqt._f = 10) then 'BAD NOZZLE PICK UP ERROR'
        when (mqt._f = 11) then 'BAD NOZZLE RECOGNITION ERROR'
        when (mqt._f = 12) then 'CONTINUE START'
        when (mqt._f = 13) then 'APC MOUNT CANCEL'
        when (mqt._f = 14) then 'MOUNT BLOW ERROR'
        when (mqt._f = 15) then 'DETECT TAPE CHANGE'
        when (mqt._f = 16) then 'COMPONENT THICKNESS ERROR'
        when (mqt._f = 17) then 'PICK UP ERROR WHEN COUNT MANDATORY'
        when (mqt._f = 18) then 'LEAD/BALL FLOAT ERROR'
        when (mqt._f = 19) then 'DETECT SHIFT PICK UP POSITION'
        when (mqt._f = 20) then 'COMPONENT DROP DIPPING UNIT'
        else 'UNKNOWN FAILURE'
    end as attempt_status,
    mqt._rcgx,
    mqt._rcgy,
    mqt._rcga,
    mqt._tcx,
    mqt._tcy,
    mqt._mposirecx,
    mqt._mposirecy,
    mqt._mposireca,
    mqt._mposirecz,
    mqt._thmax,
    mqt._thave,
    mqt._mntcx,
    mqt._mntcy,
    mqt._mntca,
    mqt._tlx,
    mqt._tly,
    mqt._inspectarea,
    mqt._didnum,
    mqt._ds,
    mqt._dispenseid,
    mqt._parts,
    mqt._warpz,
    mqt._prepickuplot,
    mqt._prepickupsts,
    ccfd._filename_id,
    ccfd._history_id,
    ccfd._time_stamp,
    ccfd._crb_file_name,
    ccfd._product_name,
    cl._filename_id,
    cl._idnum,
    cl._lotnum,
    cl._lot,
    cl._mcfilename,
    cl._filter,
    cl._autochg,
    cl._basechg,
    cl._lane,
    cl._productionid,
    cl._simproduct,
    cl._dgspcbname,
    cl._dgspcbrev,
    cl._dgspcbside,
    cl._dgsrefpin,
    cl._c,
    cl._datagenmode,
    cl._mounthead,
    cl._vstpath,
    cl._order,
    cl._targettact,
    cp._filename_id,
    cp._lot_number,
    cp._idnum,
    cp._cadid,
    cp._x,
    cp._y,
    cp._a,
    cp._parts,
    cp._brm,
    cp._turn,
    cp._dturn,
    cp._ts,
    cp._ms,
    cp._ds,
    cp._np,
    cp._dnp,
    cp._pu,
    cp._side,
    cp._dpu,
    cp._head,
    cp._dhead,
    cp._ihead,
    cp._b,
    cp._pg,
    cp._s,
    cp._rid,
    cp._c,
    cp._m,
    cp._mb,
    cp._f,
    cp._pr,
    cp._priseq,
    cp._p,
    cp._pad,
    cp._vw,
    cp._stdpos,
    cp._land,
    cp._depend,
    cp._chkflag,
    cp._exchk,
    cp._grand,
    cp._marea,
    cp._rmset,
    cp._sh,
    cp._scandir1,
    cp._scandir2,
    cp._ohl,
    cp._ohr,
    cp._apcctrl,
    cp._wg,
    cp._skipnumber,
    acmp._filename_id,
    acmp._p,
    acmp._cmp,
    acmp._cc,
    acmp._ref,
    acmp._type,
    ad._filename_id,
    ad._cmp,
    ad._defect,
    ad._insp_type,
    ad._lead_id,
    null as dummy
from
    u03.filename_to_fid ftf
inner join
    u03.u0x_filename_data ufd
on
    ufd._filename_id = ftf._filename_id
inner join
    u03.mountqualitytrace mqt
on
    mqt._filename_id = ftf._filename_id
inner join
    u03.pivot_index upx
on
    upx._filename_id = ftf._filename_id
inner join
    u03.pivot_information upi
on
    upi._filename_id = ftf._filename_id
inner join
    aoi.insp ai
on
    upper(ai._c2d) = upper(ufd._pcb_id)
inner join
    aoi.filename_to_fid aftf
on
    aftf._filename_id = ai._filename_id
inner join
    aoi.aoi_filename_data aafd
on
    aafd._filename_id = ai._filename_id
inner join
    aoi.p ap
on
    ap._filename_id = ai._filename_id
inner join
    crb.crb_filename_data ccfd
on
    upper(ccfd._product_name) = upper(upx._mjsid)
inner join
    crb.lotnames cl
on
    cl._filename_id = ccfd._filename_id
and
    cl._lot = upi._lotname
inner join
    crb.positiondata cp
on
    cp._filename_id = ccfd._filename_id
and
    cp._lot_number = cl._lotnum
and
    cp._idnum = mqt._idnum
left join
    aoi.cmp as acmp
on
    acmp._filename_id = ai._filename_id
and
    acmp._p = ap._p
and
    acmp._ref = cp._c
left join
    aoi.defect ad
on
    ad._filename_id = ai._filename_id
and
    ad._cmp = acmp._cmp
where 
    ufd._pcb_id in
(
    'YEP0PTD000LA|00|A|101633701823|01',
    'YEP0PTD000LA|00|A|101633701825|01',
    'YEP0PTD000LA|00|A|101633701828|01',
    'YEP0PTD000LA|00|A|101633701830|01',
    'YEP0PTD000LA|00|A|101633701832|01',
    'YEP0PTD000LA|00|A|101633701834|01',
    'YEP0PTD000LA|00|A|101633701836|01',
    'YEP0PTD000LA|00|A|101633701838|01',
    'YEP0PTD000LA|00|A|101633701839|01',
    'YEP0PTD000LA|00|A|101633701840|01',
    'YEP0PTD000LA|00|A|101633701854|01',
    'YEP0PTD000LA|00|A|101633701856|01',
    'YEP0PTD000LA|00|A|101633701858|01',
    'YEP0PTD000LA|00|A|101633701860|01',
    'YEP0PTD000LA|00|A|101633701862|01',
    'YEP0PTD000LA|00|A|101633701864|01',
    'YEP0PTD000LA|00|A|101633701865|01',
    'YEP0PTD000LA|00|A|101633701866|01',
    'YEP0PTD000LA|00|A|101633701867|01',
    'YEP0PTD000LA|00|A|101633701869|01',
    'YEP0PTD000LA|00|A|101633701871|01',
    'YEP0PTD000LA|00|A|101633701872|01',
    'YEP0PTD000LA|00|A|101633701874|01',
    'YEP0PTD000LA|00|A|101633701875|01',
    'YEP0PTD000LA|00|A|101633701879|01',
    'YEP0PTD000LA|00|A|101633701880|01',
    'YEP0PTD000LA|00|A|101633701881|01',
    'YEP0PTD000LA|00|A|101633701889|01',
    'YEP0PTD000LA|00|A|101633701891|01',
    'YEP0PTD000LA|00|A|101633701893|01',
    'YEP0PTD000LA|00|A|101633701895|01',
    'YEP0PTD000LA|00|A|101633701897|01',
    'YEP0PTD000LA|00|A|101633701899|01',
    'YEP0PTD000LA|00|A|101633701901|01',
    'YEP0PTD000LA|00|A|101633701903|01',
    'YEP0PTD000LA|00|A|101633701905|01',
    'YEP0PTD000LA|00|A|101633701907|01',
    'YEP0PTD000LA|00|A|101633701908|01',
    'YEP0PTD000LA|00|A|101633701911|01',
    'YEP0PTD000LA|00|A|101633701913|01',
    'YEP0PTD000LA|00|A|101633701915|01',
    'YEP0PTD000LA|00|A|101633701917|01',
    'YEP0PTD000LA|00|A|101633701919|01',
    'YEP0PTD000LA|00|A|101633701921|01',
    'YEP0PTD000LA|00|A|101633701923|01',
    'YEP0PTD000LA|00|A|101633701963|01',
    'YEP0PTD000LA|00|A|101633701965|01',
    'YEP0PTD000LA|00|A|101633701967|01',
    'YEP0PTD000LA|00|A|101633701982|01',
    'YEP0PTD000LA|00|A|101633701983|01',
    'YEP0PTD000LA|00|A|101633701985|01',
    'YEP0PTD000LA|00|A|101633701987|01',
    'YEP0PTD000LA|00|A|101633701989|01',
    'YEP0PTD000LA|00|A|101633701991|01',
    'YEP0PTD000LA|00|A|101633701993|01',
    'YEP0PTD000LA|00|A|101633701997|01',
    'YEP0PTD000LA|00|A|101633701998|01',
    'YEP0PTD000LA|00|A|101633702000|01',
    'YEP0PTD000LA|00|A|101633702002|01',
    'YEP0PTD000LA|00|A|101633702004|01',
    'YEP0PTD000LA|00|A|101633702009|01',
    'YEP0PTD000LA|00|A|101633702011|01',
    'YEP0PTD000LA|00|A|101633702013|01',
    'YEP0PTD000LA|00|A|101633702015|01',
    'YEP0PTD000LA|00|A|101633702017|01',
    'YEP0PTD000LA|00|A|101633702019|01',
    'YEP0PTD000LA|00|A|101633702021|01',
    'YEP0PTD000LA|00|A|101633702023|01',
    'YEP0PTD000LA|00|A|101633702025|01',
    'YEP0PTD000LA|00|A|101633702027|01',
    'YEP0PTD000LA|00|A|101633702032|01',
    'YEP0PTD000LA|00|A|101633702033|01',
    'YEP0PTD000LA|00|A|101633702034|01',
    'YEP0PTD000LA|00|A|101633702035|01',
    'YEP0PTD000LA|00|A|101633702036|01',
    'YEP0PTD000LA|00|A|101633702037|01',
    'YEP0PTD000LA|00|A|101633702038|01',
    'YEP0PTD000LA|00|A|101633702039|01',
    'YEP0PTD000LA|00|A|101633702040|01',
    'YEP0PTD000LA|00|A|101633702041|01',
    'YEP0PTD000LA|00|A|101633702042|01',
    'YEP0PTD000LA|00|A|101633702043|01',
    'YEP0PTD000LA|00|A|101633702044|01',
    'YEP0PTD000LA|00|A|101633702045|01',
    'YEP0PTD000LA|00|A|101633702046|01',
    'YEP0PTD000LA|00|A|101633702047|01',
    'YEP0PTD000LA|00|A|101633702048|01',
    'YEP0PTD000LA|00|A|101633702049|01',
    'YEP0PTD000LA|00|A|101633702050|01',
    'YEP0PTD000LA|00|A|101633702051|01',
    'YEP0PTD000LA|00|A|101633702060|01',
    'YEP0PTD000LA|00|A|101633702061|01',
    'YEP0PTD000LA|00|A|101633702091|01',
    'YEP0PTD000LA|00|A|101633702093|01',
    'YEP0PTD000LA|00|A|101633702095|01',
    'YEP0PTD000LA|00|A|101633702097|01',
    'YEP0PTD000LA|00|A|101633702099|01',
    'YEP0PTD000LA|00|A|101633702101|01',
    'YEP0PTD000LA|00|A|101633702103|01',
    'YEP0PTD000LA|00|A|101633702105|01',
    'YEP0PTD000LA|00|A|101633800105|01',
    'YEP0PTD000LA|00|A|101633800129|01',
    'YEP0PTD000LA|00|A|101633800190|01',
    'YEP0PTD000LA|00|A|101633800192|01',
    'YEP0PTD000LA|00|A|101633800193|01',
    'YEP0PTD000LA|00|A|101633800195|01',
    'YEP0PTD000LA|00|A|101633800198|01',
    'YEP0PTD000LA|00|A|101633800200|01',
    'YEP0PTD000LA|00|A|101633800202|01',
    'YEP0PTD000LA|00|A|101633800205|01',
    'YEP0PTD000LA|00|A|101633800206|01',
    'YEP0PTD000LA|00|A|101633800208|01',
    'YEP0PTD000LA|00|A|101633800210|01',
    'YEP0PTD000LA|00|A|101633800212|01',
    'YEP0PTD000LA|00|A|101633800214|01',
    'YEP0PTD000LA|00|A|101633800216|01',
    'YEP0PTD000LA|00|A|101633800218|01',
    'YEP0PTD000LA|00|A|101633800220|01',
    'YEP0PTD000LA|00|A|101633800222|01',
    'YEP0PTD000LA|00|A|101633800225|01',
    'YEP0PTD000LA|00|A|101633800227|01',
    'YEP0PTD000LA|00|A|101633800229|01',
    'YEP0PTD000LA|00|A|101633800231|01',
    'YEP0PTD000LA|00|A|101633800233|01',
    'YEP0PTD000LA|00|A|101633800235|01',
    'YEP0PTD000LA|00|A|101633800237|01',
    'YEP0PTD000LA|00|A|101633800239|01',
    'YEP0PTD000LA|00|A|101633800327|01',
    'YEP0PTD000LA|00|A|101633800329|01',
    'YEP0PTD000LA|00|A|101633800330|01',
    'YEP0PTD000LA|00|A|101633800333|01',
    'YEP0PTD000LA|00|A|101633800335|01',
    'YEP0PTD000LA|00|A|101633800337|01',
    'YEP0PTD000LA|00|A|101633800341|01',
    'YEP0PTD000LA|00|A|101633800344|01',
    'YEP0PTD000LA|00|A|101633800346|01',
    'YEP0PTD000LA|00|A|101633800348|01',
    'YEP0PTD000LA|00|A|101633800350|01',
    'YEP0PTD000LA|00|A|101633800351|01',
    'YEP0PTD000LA|00|A|101633800353|01',
    'YEP0PTD000LA|00|A|101633800355|01',
    'YEP0PTD000LA|00|A|101633800357|01',
    'YEP0PTD000LA|00|A|101633800359|01',
    'YEP0PTD000LA|00|A|101633800362|01',
    'YEP0PTD000LA|00|A|101633800364|01',
    'YEP0PTD000LA|00|A|101633800366|01',
    'YEP0PTD000LA|00|A|101633800368|01',
    'YEP0PTD000LA|00|A|101633800370|01',
    'YEP0PTD000LA|00|A|101633800372|01',
    'YEP0PTD000LA|00|A|101633800374|01'
)
order by
    ftf._filename_route,
    ftf._filename_timestamp,
    ufd._machine_order,
    ufd._lane_no,
    ufd._stage_no
;

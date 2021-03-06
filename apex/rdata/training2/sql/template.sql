       Table "aoi.crb_filename_data"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _history_id    | text          | 
 _time_stamp    | text          | 
 _crb_file_name | text          | 
 _product_name  | text          | 
Indexes:
    "idx_crb_filename_data" btree (_filename_id)

           Table "aoi.filename_to_fid"
       Column        |     Type      | Modifiers 
---------------------+---------------+-----------
 _filename           | text          | 
 _filename_type      | text          | 
 _filename_timestamp | bigint        | 
 _filename_route     | text          | 
 _filename_id        | numeric(30,0) | 
Indexes:
    "idx_filename_to_fid_1" btree (_filename_id)
    "idx_filename_to_fid_2" btree (_filename_timestamp)
    "idx_filename_to_fid_3" btree (_filename_id, _filename_timestamp)
    "idx_filename_to_fid_4" btree (_filename_timestamp, _filename_id)

      Index "aoi.idx_crb_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "aoi.crb_filename_data"

      Index "aoi.idx_filename_to_fid_1"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "aoi.filename_to_fid"

         Index "aoi.idx_filename_to_fid_2"
       Column        |  Type  |     Definition      
---------------------+--------+---------------------
 _filename_timestamp | bigint | _filename_timestamp
btree, for table "aoi.filename_to_fid"

             Index "aoi.idx_filename_to_fid_3"
       Column        |     Type      |     Definition      
---------------------+---------------+---------------------
 _filename_id        | numeric(30,0) | _filename_id
 _filename_timestamp | bigint        | _filename_timestamp
btree, for table "aoi.filename_to_fid"

             Index "aoi.idx_filename_to_fid_4"
       Column        |     Type      |     Definition      
---------------------+---------------+---------------------
 _filename_timestamp | bigint        | _filename_timestamp
 _filename_id        | numeric(30,0) | _filename_id
btree, for table "aoi.filename_to_fid"

         Index "aoi.idx_information"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "aoi.information"

       Index "aoi.idx_lotinformation"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "aoi.lotinformation"

      Index "aoi.idx_rst_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "aoi.rst_filename_data"

      Index "aoi.idx_u0x_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "aoi.u0x_filename_data"

         Table "aoi.information"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_information" btree (_filename_id)

        Table "aoi.lotinformation"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_lotinformation" btree (_filename_id)

         Table "aoi.rst_filename_data"
       Column       |     Type      | Modifiers 
--------------------+---------------+-----------
 _filename_id       | numeric(30,0) | 
 _machine           | text          | 
 _lane              | integer       | 
 _date_time         | text          | 
 _serial_number     | text          | 
 _inspection_result | text          | 
 _board_removed     | text          | 
Indexes:
    "idx_rst_filename_data" btree (_filename_id)

         Table "aoi.u0x_filename_data"
      Column       |     Type      | Modifiers 
-------------------+---------------+-----------
 _filename_id      | numeric(30,0) | 
 _date             | text          | 
 _machine_order    | integer       | 
 _stage_no         | integer       | 
 _lane_no          | integer       | 
 _pcb_serial       | text          | 
 _pcb_id           | text          | 
 _output_no        | integer       | 
 _pcb_id_lot_no    | text          | 
 _pcb_id_serial_no | text          | 
Indexes:
    "idx_u0x_filename_data" btree (_filename_id)

         Table "db.product_data"
        Column         | Type | Modifiers 
-----------------------+------+-----------
 _product_id           | text | 
 _product_name         | text | 
 _dos_product_name     | text | 
 _patterns_per_panel   | text | 
 _panel_width          | text | 
 _panel_length         | text | 
 _panel_thickness      | text | 
 _camera_xaxis_top     | text | 
 _camera_yaxis_top     | text | 
 _camera_xaxis_bottom  | text | 
 _camera_yaxis_bottom  | text | 
 _tooling_pin_distance | text | 
 _barcodes_per_panel   | text | 
 _product_valid_flag   | text | 
 _tooling_pin          | text | 
 _conveyor_speed       | text | 
 _use_brd_file         | text | 
 _base_product_id      | text | 

        Table "db.product_run_history"
           Column           | Type | Modifiers 
----------------------------+------+-----------
 _prh_equipment_id          | text | 
 _prh_lane_no               | text | 
 _prh_stage_no              | text | 
 _prh_setup_id              | text | 
 _prh_start_time            | text | 
 _prh_end_time              | text | 
 _prh_plan_cycle_time       | text | 
 _prh_cycle_time1           | text | 
 _prh_cycle_time2           | text | 
 _prh_cycle_time3           | text | 
 _prh_bottleneck_machine    | text | 
 _prh_mount_mode            | text | 
 _prh_actual_time           | text | 
 _prh_production_time       | text | 
 _e_equipment_id            | text | 
 _e_equipment_name          | text | 
 _e_equipment_type          | text | 
 _e_icon_filename           | text | 
 _e_valid_flag              | text | 
 _e_equipment_abbr          | text | 
 _e_pmd_priority_group_id   | text | 
 _ps_setup_id               | text | 
 _ps_product_id             | text | 
 _ps_route_id               | text | 
 _ps_mix_name               | text | 
 _ps_ldf_file_name          | text | 
 _ps_machine_file_name      | text | 
 _ps_setup_valid_flag       | text | 
 _ps_last_modified_time     | text | 
 _ps_dos_file_name          | text | 
 _ps_model_string           | text | 
 _ps_top_bottom             | text | 
 _ps_pt_group_name          | text | 
 _ps_pt_lot_name            | text | 
 _ps_pt_mc_file_name        | text | 
 _ps_pt_downloaded_flag     | text | 
 _ps_pt_needs_download      | text | 
 _ps_sub_parts_flag         | text | 
 _ps_barcode_side           | text | 
 _ps_cycle_time             | text | 
 _ps_import_source          | text | 
 _ps_modified_import_source | text | 
 _ps_theoretical_xover_time | text | 
 _ps_publish_mode           | text | 
 _ps_pcb_name               | text | 
 _ps_master_mjs_id          | text | 
 _ps_led_valid_flag         | text | 
 _pd_product_id             | text | 
 _pd_product_name           | text | 
 _pd_dos_product_name       | text | 
 _pd_patterns_per_panel     | text | 
 _pd_panel_width            | text | 
 _pd_panel_length           | text | 
 _pd_panel_thickness        | text | 
 _pd_camera_xaxis_top       | text | 
 _pd_camera_yaxis_top       | text | 
 _pd_camera_xaxis_bottom    | text | 
 _pd_camera_yaxis_bottom    | text | 
 _pd_tooling_pin_distance   | text | 
 _pd_barcodes_per_panel     | text | 
 _pd_product_valid_flag     | text | 
 _pd_tooling_pin            | text | 
 _pd_conveyor_speed         | text | 
 _pd_use_brd_file           | text | 
 _pd_base_product_id        | text | 

             Table "db.reel_data"
           Column           | Type | Modifiers 
----------------------------+------+-----------
 _reel_id                   | text | 
 _part_no                   | text | 
 _mcid                      | text | 
 _vendor_no                 | text | 
 _lot_no                    | text | 
 _quantity                  | text | 
 _user_data                 | text | 
 _reel_barcode              | text | 
 _current_quantity          | text | 
 _update_time               | text | 
 _master_reel_id            | text | 
 _create_time               | text | 
 _part_class                | text | 
 _material_name             | text | 
 _prev_reel_id              | text | 
 _next_reel_id              | text | 
 _adjusted_current_quantity | text | 
 _tray_quantity             | text | 
 _bulk_master_id            | text | 
 _is_msd                    | text | 
 _market_usage              | text | 
 _stick_quantity            | text | 
 _stick_count               | text | 
 _supply_type               | text | 
 _master_stick_reel_id      | text | 
 _current_stick_count       | text | 

             Table "db.route_machines"
             Column              | Type | Modifiers 
---------------------------------+------+-----------
 _r_route_id                     | text | 
 _r_route_name                   | text | 
 _rl_pos                         | text | 
 _eq_equipment_id                | text | 
 _eq_equipment_name              | text | 
 _r_host_name                    | text | 
 _r_dos_line_no                  | text | 
 _r_flow_direction               | text | 
 _r_valid_flag                   | text | 
 _r_subimport_path               | text | 
 _r_stand_alone                  | text | 
 _r_route_startup                | text | 
 _r_lnb_host_name                | text | 
 _r_route_abbr                   | text | 
 _r_dgs_line_id                  | text | 
 _r_dgs_import_mode              | text | 
 _r_mgmt_upload_type             | text | 
 _r_sub_part_import_src          | text | 
 _r_navi_import_mode             | text | 
 _r_restricted_components_enable | text | 
 _r_separate_network_ip          | text | 
 _r_separate_network_enabled     | text | 
 _r_publish_mode                 | text | 
 _r_linked_to_publish            | text | 
 _r_publish_route_id             | text | 
 _r_disable_tray_part_scan       | text | 
 _r_enable_tray_interlock        | text | 
 _r_bmx_zone_id                  | text | 
 _r_bmx_storage_unit_id          | text | 
 _r_bmx_dedication_type          | text | 
 _r_pt200_line_id                | text | 
 _r_allow_delete                 | text | 
 _r_dgs_server_id                | text | 
 _r_erp_route_id                 | text | 
 _r_enable_tray_rfid             | text | 
 _rl_route_id                    | text | 
 _rl_zone_id                     | text | 
 _rl_dos_cell_no                 | text | 
 _rl_pro_module_no               | text | 
 _zl_equipment_id                | text | 
 _eq_equipment_type              | text | 
 _eq_icon_filename               | text | 
 _eq_valid_flag                  | text | 
 _eq_equipment_abbr              | text | 
 _eq_pmd_priority_group_id       | text | 
 _m_model_number                 | text | 
 _m_mgmt_report                  | text | 
 _m_double_feeder_mode           | text | 
 _m_ipc                          | text | 
 _m_valid_flag                   | text | 
 _m_spc                          | text | 
 _m_single_lane_mode             | text | 
 _m_machine_vendor               | text | 
 _m_num_stages                   | text | 
 _m_simulation_mode              | text | 
 _m_cph_in_thousands             | text | 
 _mm_model_number                | text | 
 _mm_mach_type                   | text | 
 _mm_mod_number                  | text | 
 _mm_mod_name                    | text | 
 _mm_carriage_type               | text | 
 _mm_description                 | text | 
 _mm_machine_vendor              | text | 
 _mm_num_stages                  | text | 
 _mm_simulation_mode             | text | 
 _mm_simulation_mode_config      | text | 

            Table "u01.count"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_count" btree (_filename_id)

       Table "u01.crb_filename_data"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _history_id    | text          | 
 _time_stamp    | text          | 
 _crb_file_name | text          | 
 _product_name  | text          | 
Indexes:
    "idx_crb_filename_data" btree (_filename_id)

          Table "u01.cycletime"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_cycletime" btree (_filename_id)

          Table "u01.delta_feeder"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _pcb_id        | text          | 
 _pcb_serial    | text          | 
 _machine_order | integer       | 
 _lane_no       | integer       | 
 _stage_no      | integer       | 
 _timestamp     | bigint        | 
 _fadd          | integer       | 
 _fsadd         | integer       | 
 _mjsid         | text          | 
 _lotname       | text          | 
 _reelid        | text          | 
 _partsname     | text          | 
 _output_no     | integer       | 
 _blkserial     | text          | 
 _pickup        | integer       | 
 _pmiss         | integer       | 
 _rmiss         | integer       | 
 _dmiss         | integer       | 
 _mmiss         | integer       | 
 _hmiss         | integer       | 
 _trsmiss       | integer       | 
 _mount         | integer       | 
Indexes:
    "idx_delta_feeder" btree (_filename_id)

          Table "u01.delta_nozzle"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _pcb_id        | text          | 
 _pcb_serial    | text          | 
 _machine_order | integer       | 
 _lane_no       | integer       | 
 _stage_no      | integer       | 
 _timestamp     | bigint        | 
 _nhadd         | integer       | 
 _ncadd         | integer       | 
 _mjsid         | text          | 
 _lotname       | text          | 
 _output_no     | integer       | 
 _pickup        | integer       | 
 _pmiss         | integer       | 
 _rmiss         | integer       | 
 _dmiss         | integer       | 
 _mmiss         | integer       | 
 _hmiss         | integer       | 
 _trsmiss       | integer       | 
 _mount         | integer       | 
Indexes:
    "idx_delta_nozzle" btree (_filename_id)

       Table "u01.delta_pivot_count"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _pcb_id        | text          | 
 _pcb_serial    | text          | 
 _machine_order | integer       | 
 _lane_no       | integer       | 
 _stage_no      | integer       | 
 _timestamp     | bigint        | 
 _mjsid         | text          | 
 _lotname       | text          | 
 _output_no     | integer       | 
 _bndrcgstop    | numeric(10,3) | 
 _bndstop       | numeric(10,3) | 
 _board         | numeric(10,3) | 
 _brcgstop      | numeric(10,3) | 
 _bwait         | numeric(10,3) | 
 _cderr         | numeric(10,3) | 
 _cmerr         | numeric(10,3) | 
 _cnvstop       | numeric(10,3) | 
 _cperr         | numeric(10,3) | 
 _crerr         | numeric(10,3) | 
 _cterr         | numeric(10,3) | 
 _cwait         | numeric(10,3) | 
 _fbstop        | numeric(10,3) | 
 _fwait         | numeric(10,3) | 
 _jointpasswait | numeric(10,3) | 
 _judgestop     | numeric(10,3) | 
 _lotboard      | numeric(10,3) | 
 _lotmodule     | numeric(10,3) | 
 _mcfwait       | numeric(10,3) | 
 _mcrwait       | numeric(10,3) | 
 _mhrcgstop     | numeric(10,3) | 
 _module        | numeric(10,3) | 
 _otherlstop    | numeric(10,3) | 
 _othrstop      | numeric(10,3) | 
 _pwait         | numeric(10,3) | 
 _rwait         | numeric(10,3) | 
 _scestop       | numeric(10,3) | 
 _scstop        | numeric(10,3) | 
 _swait         | numeric(10,3) | 
 _tdispense     | numeric(10,3) | 
 _tdmiss        | numeric(10,3) | 
 _thmiss        | numeric(10,3) | 
 _tmmiss        | numeric(10,3) | 
 _tmount        | numeric(10,3) | 
 _tpickup       | numeric(10,3) | 
 _tpmiss        | numeric(10,3) | 
 _tpriming      | numeric(10,3) | 
 _trbl          | numeric(10,3) | 
 _trmiss        | numeric(10,3) | 
 _trserr        | numeric(10,3) | 
 _trsmiss       | numeric(10,3) | 
Indexes:
    "idx_delta_pivot_count" btree (_filename_id)

        Table "u01.delta_pivot_time"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _pcb_id        | text          | 
 _pcb_serial    | text          | 
 _machine_order | integer       | 
 _lane_no       | integer       | 
 _stage_no      | integer       | 
 _timestamp     | bigint        | 
 _mjsid         | text          | 
 _lotname       | text          | 
 _output_no     | integer       | 
 _actual        | numeric(10,3) | 
 _bndrcgstop    | numeric(10,3) | 
 _bndstop       | numeric(10,3) | 
 _brcg          | numeric(10,3) | 
 _brcgstop      | numeric(10,3) | 
 _bwait         | numeric(10,3) | 
 _cderr         | numeric(10,3) | 
 _change        | numeric(10,3) | 
 _cmerr         | numeric(10,3) | 
 _cnvstop       | numeric(10,3) | 
 _cperr         | numeric(10,3) | 
 _crerr         | numeric(10,3) | 
 _cterr         | numeric(10,3) | 
 _cwait         | numeric(10,3) | 
 _dataedit      | numeric(10,3) | 
 _fbstop        | numeric(10,3) | 
 _fwait         | numeric(10,3) | 
 _idle          | numeric(10,3) | 
 _jointpasswait | numeric(10,3) | 
 _judgestop     | numeric(10,3) | 
 _load          | numeric(10,3) | 
 _mcfwait       | numeric(10,3) | 
 _mcrwait       | numeric(10,3) | 
 _mente         | numeric(10,3) | 
 _mhrcgstop     | numeric(10,3) | 
 _mount         | numeric(10,3) | 
 _otherlstop    | numeric(10,3) | 
 _othrstop      | numeric(10,3) | 
 _poweron       | numeric(10,3) | 
 _prdstop       | numeric(10,3) | 
 _prod          | numeric(10,3) | 
 _prodview      | numeric(10,3) | 
 _pwait         | numeric(10,3) | 
 _rwait         | numeric(10,3) | 
 _scestop       | numeric(10,3) | 
 _scstop        | numeric(10,3) | 
 _swait         | numeric(10,3) | 
 _totalstop     | numeric(10,3) | 
 _trbl          | numeric(10,3) | 
 _trserr        | numeric(10,3) | 
 _unitadjust    | numeric(10,3) | 
Indexes:
    "idx_delta_pivot_time" btree (_filename_id)

          Table "u01.dispenser"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _head        | text          | 
 _nhadd       | text          | 
 _blkcode     | text          | 
 _blkserial   | text          | 
 _usen        | text          | 
 _nozzlename  | text          | 
 _bondid      | text          | 
 _useb        | text          | 
 _bondlibname | text          | 
 _dispense    | text          | 
 _priming     | text          | 
 _psrerr      | text          | 
Indexes:
    "idx_dispenser" btree (_filename_id)

           Table "u01.filename_to_fid"
       Column        |     Type      | Modifiers 
---------------------+---------------+-----------
 _filename           | text          | 
 _filename_type      | text          | 
 _filename_timestamp | bigint        | 
 _filename_route     | text          | 
 _filename_id        | numeric(30,0) | 
Indexes:
    "idx_filename_to_fid_1" btree (_filename_id)
    "idx_filename_to_fid_2" btree (_filename_timestamp)
    "idx_filename_to_fid_3" btree (_filename_id, _filename_timestamp)
    "idx_filename_to_fid_4" btree (_filename_timestamp, _filename_id)

            Index "u01.idx_count"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.count"

      Index "u01.idx_crb_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.crb_filename_data"

          Index "u01.idx_cycletime"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.cycletime"

        Index "u01.idx_delta_feeder"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.delta_feeder"

        Index "u01.idx_delta_nozzle"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.delta_nozzle"

      Index "u01.idx_delta_pivot_count"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.delta_pivot_count"

      Index "u01.idx_delta_pivot_time"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.delta_pivot_time"

          Index "u01.idx_dispenser"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.dispenser"

      Index "u01.idx_filename_to_fid_1"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.filename_to_fid"

         Index "u01.idx_filename_to_fid_2"
       Column        |  Type  |     Definition      
---------------------+--------+---------------------
 _filename_timestamp | bigint | _filename_timestamp
btree, for table "u01.filename_to_fid"

             Index "u01.idx_filename_to_fid_3"
       Column        |     Type      |     Definition      
---------------------+---------------+---------------------
 _filename_id        | numeric(30,0) | _filename_id
 _filename_timestamp | bigint        | _filename_timestamp
btree, for table "u01.filename_to_fid"

             Index "u01.idx_filename_to_fid_4"
       Column        |     Type      |     Definition      
---------------------+---------------+---------------------
 _filename_timestamp | bigint        | _filename_timestamp
 _filename_id        | numeric(30,0) | _filename_id
btree, for table "u01.filename_to_fid"

            Index "u01.idx_index"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.index"

         Index "u01.idx_information"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.information"

       Index "u01.idx_inspectiondata"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.inspectiondata"

      Index "u01.idx_mountpickupfeeder"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.mountpickupfeeder"

      Index "u01.idx_mountpickupnozzle"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.mountpickupnozzle"

         Index "u01.idx_pivot_count"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.pivot_count"

         Index "u01.idx_pivot_time"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.pivot_time"

      Index "u01.idx_rst_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.rst_filename_data"

            Index "u01.idx_time"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.time"

      Index "u01.idx_u0x_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u01.u0x_filename_data"

            Table "u01.index"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_index" btree (_filename_id)

         Table "u01.information"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_information" btree (_filename_id)

        Table "u01.inspectiondata"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_inspectiondata" btree (_filename_id)

      Table "u01.mountpickupfeeder"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _blkcode     | text          | 
 _blkserial   | text          | 
 _usef        | integer       | 
 _partsname   | text          | 
 _fadd        | integer       | 
 _fsadd       | integer       | 
 _reelid      | text          | 
 _user        | integer       | 
 _pickup      | integer       | 
 _pmiss       | integer       | 
 _rmiss       | integer       | 
 _dmiss       | integer       | 
 _mmiss       | integer       | 
 _hmiss       | integer       | 
 _trsmiss     | integer       | 
 _mount       | integer       | 
 _lname       | text          | 
 _tgserial    | text          | 
Indexes:
    "idx_mountpickupfeeder" btree (_filename_id)

      Table "u01.mountpickupnozzle"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _head        | integer       | 
 _nhadd       | integer       | 
 _ncadd       | integer       | 
 _blkcode     | text          | 
 _blkserial   | text          | 
 _user        | integer       | 
 _nozzlename  | integer       | 
 _pickup      | integer       | 
 _pmiss       | integer       | 
 _rmiss       | integer       | 
 _dmiss       | integer       | 
 _mmiss       | integer       | 
 _hmiss       | integer       | 
 _trsmiss     | integer       | 
 _mount       | integer       | 
Indexes:
    "idx_mountpickupnozzle" btree (_filename_id)

          Table "u01.pivot_count"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _bndrcgstop    | numeric(10,3) | 
 _bndstop       | numeric(10,3) | 
 _board         | numeric(10,3) | 
 _brcgstop      | numeric(10,3) | 
 _bwait         | numeric(10,3) | 
 _cderr         | numeric(10,3) | 
 _cmerr         | numeric(10,3) | 
 _cnvstop       | numeric(10,3) | 
 _cperr         | numeric(10,3) | 
 _crerr         | numeric(10,3) | 
 _cterr         | numeric(10,3) | 
 _cwait         | numeric(10,3) | 
 _fbstop        | numeric(10,3) | 
 _fwait         | numeric(10,3) | 
 _jointpasswait | numeric(10,3) | 
 _judgestop     | numeric(10,3) | 
 _lotboard      | numeric(10,3) | 
 _lotmodule     | numeric(10,3) | 
 _mcfwait       | numeric(10,3) | 
 _mcrwait       | numeric(10,3) | 
 _mhrcgstop     | numeric(10,3) | 
 _module        | numeric(10,3) | 
 _otherlstop    | numeric(10,3) | 
 _othrstop      | numeric(10,3) | 
 _pwait         | numeric(10,3) | 
 _rwait         | numeric(10,3) | 
 _scestop       | numeric(10,3) | 
 _scstop        | numeric(10,3) | 
 _swait         | numeric(10,3) | 
 _tdispense     | numeric(10,3) | 
 _tdmiss        | numeric(10,3) | 
 _thmiss        | numeric(10,3) | 
 _tmmiss        | numeric(10,3) | 
 _tmount        | numeric(10,3) | 
 _tpickup       | numeric(10,3) | 
 _tpmiss        | numeric(10,3) | 
 _tpriming      | numeric(10,3) | 
 _trbl          | numeric(10,3) | 
 _trmiss        | numeric(10,3) | 
 _trserr        | numeric(10,3) | 
 _trsmiss       | numeric(10,3) | 
Indexes:
    "idx_pivot_count" btree (_filename_id)

           Table "u01.pivot_time"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _actual        | numeric(10,3) | 
 _bndrcgstop    | numeric(10,3) | 
 _bndstop       | numeric(10,3) | 
 _brcg          | numeric(10,3) | 
 _brcgstop      | numeric(10,3) | 
 _bwait         | numeric(10,3) | 
 _cderr         | numeric(10,3) | 
 _change        | numeric(10,3) | 
 _cmerr         | numeric(10,3) | 
 _cnvstop       | numeric(10,3) | 
 _cperr         | numeric(10,3) | 
 _crerr         | numeric(10,3) | 
 _cterr         | numeric(10,3) | 
 _cwait         | numeric(10,3) | 
 _dataedit      | numeric(10,3) | 
 _fbstop        | numeric(10,3) | 
 _fwait         | numeric(10,3) | 
 _idle          | numeric(10,3) | 
 _jointpasswait | numeric(10,3) | 
 _judgestop     | numeric(10,3) | 
 _load          | numeric(10,3) | 
 _mcfwait       | numeric(10,3) | 
 _mcrwait       | numeric(10,3) | 
 _mente         | numeric(10,3) | 
 _mhrcgstop     | numeric(10,3) | 
 _mount         | numeric(10,3) | 
 _otherlstop    | numeric(10,3) | 
 _othrstop      | numeric(10,3) | 
 _poweron       | numeric(10,3) | 
 _prdstop       | numeric(10,3) | 
 _prod          | numeric(10,3) | 
 _prodview      | numeric(10,3) | 
 _pwait         | numeric(10,3) | 
 _rwait         | numeric(10,3) | 
 _scestop       | numeric(10,3) | 
 _scstop        | numeric(10,3) | 
 _swait         | numeric(10,3) | 
 _totalstop     | numeric(10,3) | 
 _trbl          | numeric(10,3) | 
 _trserr        | numeric(10,3) | 
 _unitadjust    | numeric(10,3) | 
Indexes:
    "idx_pivot_time" btree (_filename_id)

         Table "u01.rst_filename_data"
       Column       |     Type      | Modifiers 
--------------------+---------------+-----------
 _filename_id       | numeric(30,0) | 
 _machine           | text          | 
 _lane              | integer       | 
 _date_time         | text          | 
 _serial_number     | text          | 
 _inspection_result | text          | 
 _board_removed     | text          | 
Indexes:
    "idx_rst_filename_data" btree (_filename_id)

             Table "u01.time"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_time" btree (_filename_id)

         Table "u01.u0x_filename_data"
      Column       |     Type      | Modifiers 
-------------------+---------------+-----------
 _filename_id      | numeric(30,0) | 
 _date             | text          | 
 _machine_order    | integer       | 
 _stage_no         | integer       | 
 _lane_no          | integer       | 
 _pcb_serial       | text          | 
 _pcb_id           | text          | 
 _output_no        | integer       | 
 _pcb_id_lot_no    | text          | 
 _pcb_id_serial_no | text          | 
Indexes:
    "idx_u0x_filename_data" btree (_filename_id)

            Table "u03.brecg"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _idnum       | text          | 
 _brecx       | text          | 
 _brecy       | text          | 
Indexes:
    "idx_brecg" btree (_filename_id)

          Table "u03.brecgcalc"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _idnum       | text          | 
 _breccalcx   | text          | 
 _breccalcy   | text          | 
Indexes:
    "idx_brecgcalc" btree (_filename_id)

       Table "u03.crb_filename_data"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _history_id    | text          | 
 _time_stamp    | text          | 
 _crb_file_name | text          | 
 _product_name  | text          | 
Indexes:
    "idx_crb_filename_data" btree (_filename_id)

       Table "u03.elapsetimerecog"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _beamno      | text          | 
 _targetno    | text          | 
 _f           | text          | 
 _recx        | text          | 
 _recy        | text          | 
 _recz        | text          | 
 _rect        | text          | 
 _stockerno   | text          | 
 _turnno      | text          | 
Indexes:
    "idx_elapsetimerecog" btree (_filename_id)

           Table "u03.filename_to_fid"
       Column        |     Type      | Modifiers 
---------------------+---------------+-----------
 _filename           | text          | 
 _filename_type      | text          | 
 _filename_timestamp | bigint        | 
 _filename_route     | text          | 
 _filename_id        | numeric(30,0) | 
Indexes:
    "idx_filename_to_fid_1" btree (_filename_id)
    "idx_filename_to_fid_2" btree (_filename_timestamp)
    "idx_filename_to_fid_3" btree (_filename_id, _filename_timestamp)
    "idx_filename_to_fid_4" btree (_filename_timestamp, _filename_id)

         Table "u03.heightcorrect"
     Column     |     Type      | Modifiers 
----------------+---------------+-----------
 _filename_id   | numeric(30,0) | 
 _b             | text          | 
 _idnum         | text          | 
 _measureresult | text          | 
Indexes:
    "idx_heightcorrect" btree (_filename_id)

            Index "u03.idx_brecg"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.brecg"

          Index "u03.idx_brecgcalc"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.brecgcalc"

      Index "u03.idx_crb_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.crb_filename_data"

       Index "u03.idx_elapsetimerecog"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.elapsetimerecog"

      Index "u03.idx_filename_to_fid_1"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.filename_to_fid"

         Index "u03.idx_filename_to_fid_2"
       Column        |  Type  |     Definition      
---------------------+--------+---------------------
 _filename_timestamp | bigint | _filename_timestamp
btree, for table "u03.filename_to_fid"

             Index "u03.idx_filename_to_fid_3"
       Column        |     Type      |     Definition      
---------------------+---------------+---------------------
 _filename_id        | numeric(30,0) | _filename_id
 _filename_timestamp | bigint        | _filename_timestamp
btree, for table "u03.filename_to_fid"

             Index "u03.idx_filename_to_fid_4"
       Column        |     Type      |     Definition      
---------------------+---------------+---------------------
 _filename_timestamp | bigint        | _filename_timestamp
 _filename_id        | numeric(30,0) | _filename_id
btree, for table "u03.filename_to_fid"

        Index "u03.idx_heightcorrect"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.heightcorrect"

            Index "u03.idx_index"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.index"

         Index "u03.idx_information"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.information"

      Index "u03.idx_mountexchangereel"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.mountexchangereel"

       Index "u03.idx_mountlatestreel"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.mountlatestreel"

      Index "u03.idx_mountnormaltrace"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.mountnormaltrace"

      Index "u03.idx_mountqualitytrace"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.mountqualitytrace"

      Index "u03.idx_rst_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.rst_filename_data"

           Index "u03.idx_sboard"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.sboard"

      Index "u03.idx_u0x_filename_data"
    Column    |     Type      |  Definition  
--------------+---------------+--------------
 _filename_id | numeric(30,0) | _filename_id
btree, for table "u03.u0x_filename_data"

            Table "u03.index"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_index" btree (_filename_id)

         Table "u03.information"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _name        | text          | 
 _value       | text          | 
Indexes:
    "idx_information" btree (_filename_id)

      Table "u03.mountexchangereel"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _blkcode     | text          | 
 _blkserial   | text          | 
 _ftype       | text          | 
 _fadd        | text          | 
 _fsadd       | text          | 
 _use         | text          | 
 _pestatus    | text          | 
 _pcstatus    | text          | 
 _remain      | text          | 
 _init        | text          | 
 _partsname   | text          | 
 _custom1     | text          | 
 _custom2     | text          | 
 _custom3     | text          | 
 _custom4     | text          | 
 _reelid      | text          | 
 _partsemp    | text          | 
 _active      | text          | 
Indexes:
    "idx_mountexchangereel" btree (_filename_id)

       Table "u03.mountlatestreel"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _blkcode     | text          | 
 _blkserial   | text          | 
 _ftype       | text          | 
 _fadd        | text          | 
 _fsadd       | text          | 
 _use         | text          | 
 _pestatus    | text          | 
 _pcstatus    | text          | 
 _remain      | text          | 
 _init        | text          | 
 _partsname   | text          | 
 _custom1     | text          | 
 _custom2     | text          | 
 _custom3     | text          | 
 _custom4     | text          | 
 _reelid      | text          | 
 _partsemp    | text          | 
 _active      | text          | 
 _tgserial    | text          | 
Indexes:
    "idx_mountlatestreel" btree (_filename_id)

       Table "u03.mountnormaltrace"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _b           | text          | 
 _idnum       | text          | 
 _fadd        | text          | 
 _fsadd       | text          | 
 _nhadd       | text          | 
 _ncadd       | text          | 
 _reelid      | text          | 
Indexes:
    "idx_mountnormaltrace" btree (_filename_id)

       Table "u03.mountqualitytrace"
    Column     |     Type      | Modifiers 
---------------+---------------+-----------
 _filename_id  | numeric(30,0) | 
 _b            | integer       | 
 _idnum        | integer       | 
 _turn         | integer       | 
 _ms           | integer       | 
 _ts           | integer       | 
 _fadd         | integer       | 
 _fsadd        | integer       | 
 _fblkcode     | text          | 
 _fblkserial   | text          | 
 _nhadd        | integer       | 
 _ncadd        | integer       | 
 _nblkcode     | text          | 
 _nblkserial   | text          | 
 _reelid       | text          | 
 _f            | integer       | 
 _rcgx         | numeric(10,3) | 
 _rcgy         | numeric(10,3) | 
 _rcga         | numeric(10,3) | 
 _tcx          | numeric(10,3) | 
 _tcy          | numeric(10,3) | 
 _mposirecx    | numeric(10,3) | 
 _mposirecy    | numeric(10,3) | 
 _mposireca    | numeric(10,3) | 
 _mposirecz    | numeric(10,3) | 
 _thmax        | numeric(10,3) | 
 _thave        | numeric(10,3) | 
 _mntcx        | numeric(10,3) | 
 _mntcy        | numeric(10,3) | 
 _mntca        | numeric(10,3) | 
 _tlx          | numeric(10,3) | 
 _tly          | numeric(10,3) | 
 _inspectarea  | integer       | 
 _didnum       | integer       | 
 _ds           | integer       | 
 _dispenseid   | text          | 
 _parts        | integer       | 
 _warpz        | numeric(10,3) | 
 _prepickuplot | text          | 
 _prepickupsts | text          | 
Indexes:
    "idx_mountqualitytrace" btree (_filename_id)

         Table "u03.rst_filename_data"
       Column       |     Type      | Modifiers 
--------------------+---------------+-----------
 _filename_id       | numeric(30,0) | 
 _machine           | text          | 
 _lane              | integer       | 
 _date_time         | text          | 
 _serial_number     | text          | 
 _inspection_result | text          | 
 _board_removed     | text          | 
Indexes:
    "idx_rst_filename_data" btree (_filename_id)

            Table "u03.sboard"
    Column    |     Type      | Modifiers 
--------------+---------------+-----------
 _filename_id | numeric(30,0) | 
 _b           | text          | 
 _scode       | text          | 
 _sbcrstatus  | text          | 
Indexes:
    "idx_sboard" btree (_filename_id)

         Table "u03.u0x_filename_data"
      Column       |     Type      | Modifiers 
-------------------+---------------+-----------
 _filename_id      | numeric(30,0) | 
 _date             | text          | 
 _machine_order    | integer       | 
 _stage_no         | integer       | 
 _lane_no          | integer       | 
 _pcb_serial       | text          | 
 _pcb_id           | text          | 
 _output_no        | integer       | 
 _pcb_id_lot_no    | text          | 
 _pcb_id_serial_no | text          | 
Indexes:
    "idx_u0x_filename_data" btree (_filename_id)


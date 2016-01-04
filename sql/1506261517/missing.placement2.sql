-- routes route_id
-- routes route_name
-- routes host_name
-- routes dos_line_no
-- routes flow_direction
-- routes valid_flag
-- routes subimport_path
-- routes stand_alone
-- routes route_startup
-- routes lnb_host_name
-- routes route_abbr
-- routes dgs_line_id
-- routes dgs_import_mode
-- routes mgmt_upload_type
-- routes navi_import_mode
-- routes sub_part_import_src
-- routes restricted_components_enabled
-- routes separate_network_ip
-- routes separate_network_enabled
-- routes publish_mode
-- routes publish_route_id
-- routes linked_to_publish
-- routes disable_tray_part_scan
-- routes enable_tray_interlock
-- routes bmx_zone_id
-- routes bmx_storage_unit_id
-- routes bmx_dedication_type
-- routes pt200_line_id
-- routes allow_delete
-- routes dgs_server_id
-- routes erp_route_id

-- panel_placement_header panel_equipment_id
-- panel_placement_header equipment_id
-- panel_placement_header master_placement_id
-- panel_placement_header panel_placement_id
-- panel_placement_header timestamp
-- panel_placement_header trx_product_id
-- 
-- panel_placement_details panel_placement_id
-- panel_placement_details reel_id
-- panel_placement_details nc_placement_id
-- panel_placement_details pattern_no
-- panel_placement_details z_num
-- panel_placement_details pu_num
-- panel_placement_details part_no
-- panel_placement_details custom_area1
-- panel_placement_details custom_area2
-- panel_placement_details custom_area3
-- panel_placement_details custom_area4
-- panel_placement_details ref_designator

-- panels panel_id
-- panels equipment_id
-- panels nc_version
-- panels start_time
-- panels end_time
-- panels panel_equipment_id
-- panels panel_source
-- panels panel_trace
-- panels stage_no
-- panels lane_no
-- panels job_id
-- panels setup_id
-- panels trx_product_id

-- tracking_data serial_no
-- tracking_data prod_model_no
-- tracking_data panel_id
-- tracking_data pattern_id
-- tracking_data barcode
-- tracking_data setup_id
-- tracking_data top_bottom
-- tracking_data timestamp
-- tracking_data import_flag

-- panel_barcode_map module_id
-- panel_barcode_map panel_id
-- panel_barcode_map panel_id_string
-- panel_barcode_map timestamp
-- panel_barcode_map lane_no
-- panel_barcode_map setup_id

-- panel_strace_header panel_equipment_id
-- panel_strace_header equipment_id
-- panel_strace_header master_strace_id
-- panel_strace_header panel_strace_id
-- panel_strace_header timestamp
-- panel_strace_header trx_product_id

-- panel_strace_details panel_strace_id
-- panel_strace_details reel_id
-- panel_strace_details z_num
-- panel_strace_details pu_num
-- panel_strace_details part_no
-- panel_strace_details custom_area1
-- panel_strace_details custom_area2
-- panel_strace_details custom_area3
-- panel_strace_details custom_area4
-- panel_strace_details feeder_bc

-- panel_placement_header panel_equipment_id
-- panel_placement_header equipment_id
-- panel_placement_header master_placement_id
-- panel_placement_header panel_placement_id
-- panel_placement_header timestamp
-- panel_placement_header trx_product_id

-- panel_placement_details panel_placement_id
-- panel_placement_details reel_id
-- panel_placement_details nc_placement_id
-- panel_placement_details pattern_no
-- panel_placement_details z_num
-- panel_placement_details pu_num
-- panel_placement_details part_no
-- panel_placement_details custom_area1
-- panel_placement_details custom_area2
-- panel_placement_details custom_area3
-- panel_placement_details custom_area4
-- panel_placement_details ref_designator


-- reel_data reel_id
-- reel_data part_no
-- reel_data mcid
-- reel_data vendor_no
-- reel_data lot_no
-- reel_data quantity
-- reel_data user_data
-- reel_data reel_barcode
-- reel_data current_quantity
-- reel_data update_time
-- reel_data master_reel_id
-- reel_data create_time
-- reel_data part_class
-- reel_data material_name
-- reel_data prev_reel_id
-- reel_data next_reel_id
-- reel_data adjusted_current_quantity
-- reel_data tray_quantity
-- reel_data bulk_master_id
-- reel_data is_msd

-- feeder_counts feeder_id
-- feeder_counts subslot
-- feeder_counts components_fed
-- feeder_counts total_components_fed
-- feeder_counts update_time
-- feeder_counts placement_count
-- feeder_counts total_placement_count
-- feeder_counts pickup_miss
-- feeder_counts total_pickup_miss
-- feeder_counts pickup_error
-- feeder_counts total_pickup_error
-- feeder_counts shape_error
-- feeder_counts total_shape_error
-- feeder_counts recognition_error
-- feeder_counts total_recognition_error

-- product_spc_npm productid
-- product_spc_npm programid
-- product_spc_npm stage
-- product_spc_npm timestamp

-- product_run_history product_run_history_id
-- product_run_history equipment_id
-- product_run_history lane_no
-- product_run_history setup_id
-- product_run_history start_time
-- product_run_history end_time

-- nc_detail nc_version
-- nc_detail cassette
-- nc_detail slot
-- nc_detail subslot
-- nc_detail tva

-- dgs_nc_placement_detail dgs_product_data_id
-- dgs_nc_placement_detail dgs_product_setup_id
-- dgs_nc_placement_detail idnum
-- dgs_nc_placement_detail ref_designator
-- dgs_nc_placement_detail part_name
-- dgs_nc_placement_detail pattern_number

-- nc_placement_detail nc_placement_id
-- nc_placement_detail idnum
-- nc_placement_detail ref_designator
-- nc_placement_detail part_name
-- nc_placement_detail pattern_number
-- nc_placement_detail nc_version

-- dgs_nc_summary dgs_product_data_id
-- dgs_nc_summary physical_equipment_id
-- dgs_nc_summary dgs_glue_total

-- nc_summary setup_id
-- nc_summary equipment_id
-- nc_summary nc_version
-- nc_summary tva
-- nc_summary double_feeder_flag
-- nc_summary glue_total
-- nc_summary solder_total

-- system_config attribute_name
-- system_config attribute_value

-- product_setup product_id
-- product_setup route_id
-- product_setup mix_name
-- product_setup setup_id
-- product_setup ldf_file_name
-- product_setup machine_file_name
-- product_setup setup_valid_flag
-- product_setup last_modified_time
-- product_setup dos_file_name
-- product_setup model_string
-- product_setup top_bottom
-- product_setup pt_group_name
-- product_setup pt_lot_name
-- product_setup pt_mc_file_name
-- product_setup pt_downloaded_flag
-- product_setup pt_needs_download
-- product_setup sub_parts_flag
-- product_setup barcode_side
-- product_setup cycle_time
-- product_setup import_source
-- product_setup modified_import_source
-- product_setup theoretical_xover_time
-- product_setup publish_mode
-- product_setup master_mjs_id
-- product_setup pcb_name

-- product_data product_id
-- product_data product_name
-- product_data dos_product_name
-- product_data patterns_per_panel
-- product_data panel_width
-- product_data panel_length
-- product_data panel_thickness
-- product_data camera_xaxis_top
-- product_data camera_yaxis_top
-- product_data camera_xaxis_bottom
-- product_data camera_yaxis_bottom
-- product_data tooling_pin_distance
-- product_data barcodes_per_panel
-- product_data product_valid_flag
-- product_data tooling_pin
-- product_data conveyor_speed
-- product_data use_brd_file
-- product_data base_product_id
-- 

-- select 
--     -- top(5000)
--     r.route_id as            'r.route_id',
--     r.route_name as          'r.route_name',
--     rl.pos as                'rl.pos',
--     rl.zone_id as            'rl.zone_id',
--     z.zone_name as           'z.zone_name',
--     z.trace_level as         'z.trace_level',
--     z.module_id as           'z.module_id',
--     zl.pos as                'zl.pos',
--     zl.equipment_id as       'zl.equipment_id',
--     ph.equipment_id as       'ph.equipment_id',
--     ph.panel_equipment_id as 'ph.panel_equipment_id',
--     ph.trx_product_id as     'ph.trx_product_id',
--     ph.master_placement_id as   'ph.master_placement_id',
--     ph.panel_placement_id as    'ph.panel_placement_id',
--     ph.timestamp as          'ph.timestamp',
--     p.panel_id as            'p.panel_id',
--     p.equipment_id as        'p.equipment_id',
--     p.nc_version as          'p.nc_version',
--     p.start_time as          'p.start_time',
--     p.end_time as            'p.end_time',
--     p.panel_equipment_id as  'p.panel_equipment_id',
--     p.panel_source as        'p.panel_source',
--     p.panel_trace as         'p.panel_trace',
--     p.stage_no as            'p.stage_no',
--     p.lane_no as             'p.lane_no',
--     p.job_id as              'p.job_id',
--     p.setup_id as            'p.setup_id',
--     p.trx_product_id as      'p.trx_product_id',
--     td.serial_no as          'td.serial_no',
--     td.barcode as            'td.barcode',
--     td.prod_model_no as      'td.prod_model_no',
--     td.panel_id as           'td.panel_id',
--     td.pattern_id as         'td.pattern_id',
--     td.setup_id as           'td.setup_id',
--     td.top_bottom as         'td.top_bottom',
--     td.timestamp as          'td.timestamp',
--     td.import_flag as        'td.import_flag',
--     pd.panel_placement_id as 'pd.panel_placement_id',
--     pd.reel_id as            'pd.reel_id',
--     pd.nc_placement_id as    'pd.nc_placement_id',
--     pd.pattern_no as         'pd.pattern_no',
--     pd.z_num as              'pd.z_num',
--     pd.pu_num as             'pd.pu_num',
--     pd.part_no as            'pd.part_no',
--     pd.custom_area1 as       'pd.custom_area1',
--     pd.custom_area2 as       'pd.custom_area2',
--     pd.custom_area3 as       'pd.custom_area3',
--     pd.custom_area4 as       'pd.custom_area4',
--     pd.ref_designator as     'pd.ref_designator'
-- from
--     routes r
-- inner join
--     route_layout rl
-- on
--     rl.route_id = r.route_id
-- inner join
--     zones z
-- on
--     z.zone_id = rl.zone_id
-- left join
--     zone_layout zl
-- on
--     zl.zone_id = rl.zone_id
-- left join
--     panel_placement_header ph
-- on
--     ph.equipment_id = zl.equipment_id
-- left join
--     panels p
-- on
--     p.panel_equipment_id = ph.panel_equipment_id
-- left join
--     tracking_data td
-- on
--     td.panel_id = p.panel_id
-- left join
--     panel_placement_details pd
-- on
--     pd.panel_placement_id = ph.master_placement_id
-- where
--     r.valid_flag = 't'
-- and
--     z.valid_flag = 't'
-- and
--     z.module_id > 0
-- order by
--     r.route_id asc,
--     rl.pos asc,
--     ph.equipment_id asc,
--     td.serial_no asc,
--     p.stage_no asc,
--     p.lane_no asc,
--     ph.panel_equipment_id asc
-- go

-- + TZ=Europe/Madrid
-- + export TZ
-- + date -d '2015/06/16 04:13:00' +%s
-- 1434420780
-- + date -d '2015/06/16 04:20:00' +%s
-- 1434421200

-- select 
--     r.route_id as            'r.route_id',
--     r.route_name as          'r.route_name',
--     rl.pos as                'rl.pos',
--     rl.zone_id as            'rl.zone_id',
--     z.zone_name as           'z.zone_name',
--     z.trace_level as         'z.trace_level',
--     z.module_id as           'z.module_id',
--     zl.pos as                'zl.pos',
--     zl.equipment_id as       'zl.equipment_id',
--     ph.equipment_id as       'ph.equipment_id',
--     ph.panel_equipment_id as 'ph.panel_equipment_id',
--     ph.trx_product_id as     'ph.trx_product_id',
--     ph.master_placement_id as   'ph.master_placement_id',
--     ph.panel_placement_id as    'ph.panel_placement_id',
--     ph.timestamp as          'ph.timestamp',
--     p.panel_id as            'p.panel_id',
--     p.equipment_id as        'p.equipment_id',
--     p.nc_version as          'p.nc_version',
--     p.start_time as          'p.start_time',
--     p.end_time as            'p.end_time',
--     p.panel_equipment_id as  'p.panel_equipment_id',
--     p.panel_source as        'p.panel_source',
--     p.panel_trace as         'p.panel_trace',
--     p.stage_no as            'p.stage_no',
--     p.lane_no as             'p.lane_no',
--     p.job_id as              'p.job_id',
--     p.setup_id as            'p.setup_id',
--     p.trx_product_id as      'p.trx_product_id',
--     td.serial_no as          'td.serial_no',
--     td.barcode as            'td.barcode',
--     td.prod_model_no as      'td.prod_model_no',
--     td.panel_id as           'td.panel_id',
--     td.pattern_id as         'td.pattern_id',
--     td.setup_id as           'td.setup_id',
--     td.top_bottom as         'td.top_bottom',
--     td.timestamp as          'td.timestamp',
--     td.import_flag as        'td.import_flag',
--     pd.panel_placement_id as 'pd.panel_placement_id',
--     pd.reel_id as            'pd.reel_id',
--     pd.nc_placement_id as    'pd.nc_placement_id',
--     pd.pattern_no as         'pd.pattern_no',
--     pd.z_num as              'pd.z_num',
--     pd.pu_num as             'pd.pu_num',
--     pd.part_no as            'pd.part_no',
--     pd.custom_area1 as       'pd.custom_area1',
--     pd.custom_area2 as       'pd.custom_area2',
--     pd.custom_area3 as       'pd.custom_area3',
--     pd.custom_area4 as       'pd.custom_area4',
--     pd.ref_designator as     'pd.ref_designator'
-- from
--     routes r
-- inner join
--     route_layout rl
-- on
--     rl.route_id = r.route_id
-- inner join
--     zones z
-- on
--     z.zone_id = rl.zone_id
-- left join
--     zone_layout zl
-- on
--     zl.zone_id = rl.zone_id
-- left join
--     panel_placement_header ph
-- on
--     ph.equipment_id = zl.equipment_id
-- left join
--     panels p
-- on
--     p.panel_equipment_id = ph.panel_equipment_id
-- left join
--     tracking_data td
-- on
--     td.panel_id = p.panel_id
-- left join
--     panel_placement_details pd
-- on
--     pd.panel_placement_id = ph.master_placement_id
-- where
--     r.valid_flag = 't'
-- and
--     r.route_id = 1003
-- and
--     z.valid_flag = 't'
-- and
--     z.module_id > 0
-- and
--     zl.pos = 1
-- and
--     p.end_time >= 1434420780
-- and
--     p.end_time < 1434421200
-- order by
--     r.route_id asc,
--     rl.pos asc,
--     ph.equipment_id asc,
--     td.serial_no asc,
--     p.stage_no asc,
--     p.lane_no asc,
--     ph.panel_equipment_id asc
-- go

select 
    r.route_id,
    rl.pos,
    ph.equipment_id,
    td.serial_no,
    p.stage_no,
    p.lane_no,
    ph.panel_equipment_id,
    count(pd.panel_placement_id) as 'count_pd_panel_placement_id'
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    z.zone_id = rl.zone_id
left join
    zone_layout zl
on
    zl.zone_id = rl.zone_id
left join
    panel_placement_header ph
on
    ph.equipment_id = zl.equipment_id
left join
    panels p
on
    p.panel_equipment_id = ph.panel_equipment_id
left join
    tracking_data td
on
    td.panel_id = p.panel_id
left join
    panel_placement_details pd
on
    pd.panel_placement_id = ph.master_placement_id
where
    r.valid_flag = 't'
and
    r.route_id = 1003
and
    z.valid_flag = 't'
and
    z.module_id > 0
and
    zl.pos = 1
and
    p.end_time >= 1434420780
and
    p.end_time < 1434421200
group by
    r.route_id,
    rl.pos,
    ph.equipment_id,
    td.serial_no,
    p.stage_no,
    p.lane_no,
    ph.panel_equipment_id
order by
    r.route_id asc,
    rl.pos asc,
    ph.equipment_id asc,
    td.serial_no asc,
    p.stage_no asc,
    p.lane_no asc,
    ph.panel_equipment_id asc
go
